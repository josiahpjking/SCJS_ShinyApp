######
#DATA - this is not reactive. For each variable in each year it tests whether a division is signif different from national average and specifies the direction.
# it also takes into account the direction of the variable (some are reverse coded).
# the testing is done as per the current method for the SCJS, which asks |p1-p2| > sqrt(ci1^2 + ci2^2).
# the CIs are calculated as SE(p)*1.96*design factor (pre defined for each year). This is all done in the loader.R script.
######

#filter to just national average data
df %>% filter(police_div=="National Average") %>% mutate(
  nat_avgp = percentage,
  nat_avgci = ci
) %>% select(variable,year,nat_avgp,nat_avgci) %>%
  #join and do proportion testing for all other data.
  left_join(df, .) %>% 
    mutate(
      p_diff=percentage-nat_avgp,
      p_diff2=ifelse(reverse_coded==1,0-p_diff,p_diff),
      p_direction=ifelse(p_diff2==0,"No difference",
                         ifelse(p_diff2>0,"More Positive","Less Positive")),
      c=sqrt((ci^2)+(nat_avgci^2)),
      change=ifelse(((abs(p_diff)/100)>c)==TRUE & p_direction=="More Positive","More Positive",
                    ifelse(((abs(p_diff)/100)>c)==TRUE & p_direction=="Less Positive","Less Positive","No difference")),
      
      #####
      # TEXT wrapping (easiest way to make plotly show all the labels etc.)
      #####
      wrapped_name = sapply(name_trunc, FUN = function(x) {paste(strwrap(x, width = 35), collapse = "<br>")}),
      
      #text for current_plot
      my_text = paste0("<b>",police_div,"</b><br>",year,"<br>",wrapped_name,"<br><b>",round(percentage, digits=1),"</b>% +/-",round(ci*100, digits=1),", N = ",samplesize,"<br><i><b>Click to see this division relative<br>to the national average over time.<i></b>"),
      #text for trendplot
      my_text2 = paste0("<b>",year,"</b><br>",police_div,"<br>",wrapped_name,"<br><b>",round(percentage, digits=1),"</b>% +/-",round(ci*100, digits=1),", N = ",samplesize,"<br><i><b>Click to see this year<br>for all divisions.<i></b>"),
      #truncated text for multi questions
      my_text3 = paste0(wrapped_name,"<br><b>",round(percentage, digits=1),"</b>% +/-",round(ci*100, digits=1),", N = ",samplesize),
      #text for nat average lines
      natav_text = paste0("<b>",police_div,"</b><br>",year,"<br>",wrapped_name,"<br><b>",round(percentage, digits=1),"</b>% +/-",round(ci*100, digits=1),", N = ",samplesize),
      #wrapped pdiv name
      wrappedpolice_div=sapply(gsub(" Division","",police_div), FUN = function(x) {paste(strwrap(x, width = 20), collapse = "<br>")})
      ) %>% 
  select(-c(p_direction,c)) -> overview_data



#####
#SINGLE YEAR PLOT
#####
#this is the plot for a single year of all police divisions, ordered by difference from national average.
#it's a horrible ifelse because it plots bars when user selects single variables, and markers when user selects whole survey areas (multiple questions)
output$ov_currentplot <- renderPlotly({
  #BAR PLOT
  if(!(input$ov_var %in% names(all_vars))){
    #national average data
    overview_data %>% filter(variable %in% input$ov_var) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div == "National Average") -> line_data
    #division data
    overview_data %>% filter(variable %in% input$ov_var) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div!="National Average") -> bar_data
    
    #PLOT
    plot_ly(bar_data,
              x=~wrappedpolice_div,
              y=~percentage,
              color=~change,
              text=~my_text,
              hoverinfo="text",
              colors=overview_cols,
              type="bar", 
              source="clickable") %>%
      layout(title=paste0("<b>",input$ov_year,"</b><br>",paste(strwrap(input$ov_var, width = 40), collapse = "<br>")),
             titlefont=list(size=14),
             margin = list(t=100, b = 135),
             showlegend=input$showleg,
             legend = list(x=1.1,y=1),
             height = input$plotHeight, 
             autosize=TRUE,
             yaxis=list(title="Percentage",ticksuffix = "%"),
             xaxis=list(title="",tickangle=90,
                        categoryarray=~wrappedpolice_div[order(p_diff2)], categoryorder="array")
      ) %>%
        add_lines(inherit=F,
                  data=line_data, 
                  x=bar_data$wrappedpolice_div,
                  y=~percentage,
                  color=~police_div,
                  text=~natav_text, hoverinfo="text") %>% config(modeBarButtonsToRemove = modebar_remove)

  } else if(input$ov_var %in% names(all_vars)){
    
    #SCATTER PLOT
    #first get order for plotting x axis (this is because for multiple questions it's ordered by avg diff from national average. and you can't do it as easily as above.)
    overview_data %>% filter(variable %in% all_vars[[input$ov_var]]) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div!="National Average") %>%
      group_by(wrappedpolice_div) %>%
      summarise(
        av=mean(p_diff2,na.rm=T)
      ) %>% arrange(av) %>%
      mutate(plotorder=seq(1:nrow(.))) -> orderwrap
    
    #division data
    overview_data %>% filter(variable %in% all_vars[[input$ov_var]]) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div!="National Average") -> bar_data
    
    #national average data (not actually shown in the end..)
    bar_data %>% select(variable, wrappedpolice_div) %>%
      left_join(., 
                overview_data %>% 
                  filter(variable %in% all_vars[[input$ov_var]]) %>% 
                  filter(year %in% input$ov_year) %>% 
                  filter(police_div=="National Average") %>%
                  select(-wrappedpolice_div)
      ) -> line_data
    
    plot_ly(bar_data %>% group_by(wrappedpolice_div),
            x=~wrappedpolice_div,
            split=~wrapped_name,
            legendgroup=~wrapped_name, 
            source="clickable") %>%
      add_trace(x=~wrappedpolice_div,
                y=~p_diff,
                color=~change,
                text=~my_text,
                hoverinfo="text",
                colors=overview_cols,
                type="scatter",mode="markers",marker = list(symbol=24, size = 15),
                split=~wrapped_name,
                legendgroup=~wrapped_name) %>%
      layout(title=paste0("<b>",input$ov_year,"</b><br>",paste(strwrap(input$ov_var, width = 40), collapse = "<br>"),"<br>(each point is a variable in the survey)"),
        titlefont=list(size=14),
        margin = list(t=100, b = 135),
        showlegend=FALSE,
        height = input$plotHeight, 
        autosize=TRUE,
        yaxis=list(title="Percentage Point Difference <br> from National Average",ticksuffix = "%"),
        xaxis=list(title="",
                   tickangle=90,
                   categoryarray=~orderwrap$wrappedpolice_div, 
                   categoryorder="array")
      ) %>% config(modeBarButtonsToRemove = modebar_remove)
  }
})


######
# DIVISION OVER TIME PLOT
######
#this is the barplot fora single division over time. coloured by signif difference from national average, with national average as a solid line.
output$ov_trendplot <- renderPlotly({
  if(!(input$ov_var %in% names(all_vars))){
    overview_data %>% filter(variable %in% input$ov_var) %>% 
      filter(police_div %in% input$ov_pdiv) -> bardata
    overview_data %>% filter(variable %in% input$ov_var) %>%
      filter(police_div %in% c("National Average")) -> linedata
    paste0("<b>",input$ov_pdiv,"</b><br>",paste(strwrap(input$ov_var, width = 40), collapse = "<br>")) -> plottitle
  } else if(input$ov_var %in% names(all_vars)){
    #filter by ov_var2 because different level (survey section selected, so needs specific variable)
    overview_data %>% filter(variable %in% input$ov_var2) %>% 
      filter(police_div %in% input$ov_pdiv) -> bardata
    overview_data %>% filter(variable %in% input$ov_var2) %>%
      filter(police_div %in% c("National Average")) -> linedata
    paste0("<b>",input$ov_pdiv,"</b><br>",paste(strwrap(input$ov_var2, width = 40), collapse = "<br>")) -> plottitle
  }
  plot_ly(bardata,
          x=~year,
          y=~percentage,
          color=~change,
          colors=~overview_cols,
          text=~my_text2,
          hoverinfo="text",
          type="bar",
          source="clickable") %>%
    add_lines(data=linedata,color=~police_div, colors=overview_cols) %>%
    layout(title=plottitle,
           titlefont=list(size=12),
           margin=list(t=100),
           showlegend=input$showleg,
           yaxis=list(title="Percentage",ticksuffix = "%"),
           xaxis=list(title="Year"),
           height = input$plotHeight, 
           autosize=TRUE) %>% config(modeBarButtonsToRemove = modebar_remove)
})

#####
#VARIABLE SELECTION > update based on survey area selection.
#####
output$ov_var2 = renderUI({
  if(!(input$ov_var %in% names(all_vars) ))
    return()
  selectInput("ov_var2",label = "Choose variable:",choices=all_vars[[input$ov_var]])
})


#####
#PLOTLY CLICKS 
#####
#this responds to clicks on the graph and takes the user to the other graph based on x axis clicks.
observe({
  d <- event_data("plotly_click", source="clickable")
  new_value <- ifelse(is.null(d),"0",d$x) # 0 if no selection
  new_value <- gsub("<br>"," ",new_value)
  new_value <- gsub(")"," Division)",new_value)
  if(selected_pclick!=new_value){
    selected_pclick <<- new_value 
    if(selected_pclick !=0 && input$ovplotting == 'breakdown'){
      updateTabsetPanel(session, "ovplotting", selected = "trends")
      updateSelectizeInput(session, "ov_pdiv", selected = selected_pclick)

      #a hack to change variable based on nearest y value. not great :/
      overview_data %>% filter(
        police_div %in% selected_pclick,
        year %in% input$ov_year,
        variable %in% all_vars[[input$ov_var]]) %>% 
      select(variable,p_diff) %>%
        arrange(p_diff) -> yopts
      newy = d$y
      newv = yopts$variable[which.min(abs(yopts$p_diff - newy))]
      updateSelectInput(session, "ov_var2", selected = newv)
    }
    if(selected_pclick !=0 && input$ovplotting == 'trends'){
      updateTabsetPanel(session, "ovplotting", selected = "breakdown")
      updateSelectizeInput(session, "ov_year", selected = selected_pclick)
    }
  }
})


########
# VARIABLE INFO 
########
# this updates the text information on the selected area of the survey (see variable_information.R for text)
output$variable_info_ov<-renderUI({
  div(class="variable_info",
      variable_info_list[[input$ov_var]]
  )
})

#####
#GRAPH INFO - info for ov_currentplot
#####
output$overview_1 <- renderUI({
  div(
    tags$p("Compared to the National Average, see which divisions had",
           tags$b(style="color:LimeGreen","More Positive (green)"),"or",tags$b(style="color:#fb7171","Less Positive (red)"),
           "responses to the SCJS for a chosen year",tags$b(style="color:grey","(grey indicates no significant difference from the National Average).")),
    tags$i("Hover the mouse over the graph to display more information (percentages, sample sizes, confidence intervals) about each data point.")
  )
})
#####
#GRAPH INFO  info for ov_trendplot
#####
output$overview_2 <- renderUI({
  div(
    tags$i("See how a chosen police division has performed over time, with each year showing whether that division had ",
           tags$b(style="color:LimeGreen","More Positive (green)"),"or",tags$b(style="color:#fb7171","Less Positive (red)"),
           "responses to the SCJS than the National Average",tags$b(style="color:black","(black line)"),"in that year",tags$b(style="color:grey","(grey indicates no significant difference).")),
    tags$p("Hover the mouse over the graph to display more information (percentages, sample sizes, confidence intervals) about each data point.")
  )
})





