
#####
#SINGLE YEAR PLOT
#####
#this is the plot for a single year of all police divisions, ordered by difference from national average.
#it's a horrible ifelse because it plots bars when user selects single variables, and markers when user selects whole survey areas (multiple questions)
output$ov_currentplot <- renderPlotly({
  #BAR PLOT
  if(!(input$ov_var %in% names(all_vars))){
    #national average data
    df %>% filter(variable %in% input$ov_var) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div == "National Average") -> line_data
    #division data
    df %>% filter(variable %in% input$ov_var) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div!="National Average") -> bar_data
    
    #PLOT
    plot_ly(bar_data,
              x=~wrappedpolice_div,
              y=~percentage,
              color=~change,
              text=~my_text_a,
              hoverinfo="text",
              colors=overview_cols,
              type="bar", 
              source="clickable") %>%
      layout(
        annotations=list(text=paste0("<b>",input$ov_year,"</b><br>",paste(strwrap(input$ov_var, width = 50), collapse = "<br>"),"<br><i style='font-size:10px'>Click on a division to see its results over time</i>"),
                         xref="paper",x=0.5,
                         yref="paper",y=1,yshift=70,showarrow=FALSE, 
                         font=list(size=10,color='rgb(0,0,0)')),
        #title=paste0("<b>",input$ov_year,"</b><br>",paste(strwrap(input$ov_var, width = 40), collapse = "<br>"),"<br><i style='font-size:10px'>Click on a division to see how it has performed over time</i>"),
             titlefont=list(size=14),
             margin = list(t=100, b = 135),
             showlegend=FALSE,#input$showleg,
             legend = list(x=1.1,y=1),
             #height = input$plotHeight, 
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
    df %>% filter(variable %in% all_vars[[input$ov_var]]) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div!="National Average") %>%
      group_by(wrappedpolice_div) %>%
      summarise(
        av=mean(p_diff2,na.rm=T)
      ) %>% arrange(av) %>%
      mutate(plotorder=seq(1:nrow(.))) -> orderwrap
    
    #division data
    df %>% filter(variable %in% all_vars[[input$ov_var]]) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div!="National Average") -> bar_data
    
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
                type="scatter",mode="markers",marker = list(size = 15),
                #symbol = I(1),
                alpha=.7,
                split=~wrapped_name,
                legendgroup=~wrapped_name) %>%
      layout(
        annotations=list(text=paste0("<b>",input$ov_year,"</b><br>",paste(strwrap(input$ov_var, width = 50), collapse = "<br>"),"<br><i style='font-size:10px'>Click on a point to see an individual variable</i>"),
                         xref="paper",x=0.5,
                         yref="paper",y=1,yshift=70,showarrow=FALSE, 
                         font=list(size=10,color='rgb(0,0,0)')),
        #title=paste0("<b>",input$ov_year,"</b><br>",paste(strwrap(input$ov_var, width = 40), collapse = "<br>"),"<br><i style='font-size:10px'>Click on a point to see an individual variable</i>"),
        titlefont=list(size=14),
        margin = list(t=100, b = 135),
        showlegend=FALSE,
        #height = input$plotHeight, 
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
  if(input$ovplotting=="breakdown"){
    invalidateLater(2000)  
  }
  if(input$ov_var %in% names(all_vars)){
    df %>% filter(variable %in% all_vars[[input$ov_var]][1]) %>% 
      filter(police_div %in% input$ov_pdiv) -> bardata
    df %>% filter(variable %in% all_vars[[input$ov_var]][1]) %>%
      filter(police_div %in% c("National Average")) -> linedata
    paste0("<b>",input$ov_pdiv,"</b><br>",paste(strwrap(all_vars[[input$ov_var]][1], width = 40), collapse = "<br>")) -> plottitle
  }else{
    df %>% filter(variable %in% input$ov_var) %>% 
      filter(police_div %in% input$ov_pdiv) -> bardata
    df %>% filter(variable %in% input$ov_var) %>%
      filter(police_div %in% c("National Average")) -> linedata
    paste0("<b>",input$ov_pdiv,"</b><br>",paste(strwrap(input$ov_var, width = 50), collapse = "<br>")) -> plottitle
    plottitle<-paste0(plottitle,"<br><i style='font-size:10px'>Click on a bar to see that section of the survey<br>for all divisions in that year</i>")
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
    layout(
      annotations=list(text=plottitle,
                       xref="paper",x=0.5,
                       yref="paper",y=1,yshift=70,showarrow=FALSE, 
                       font=list(size=10,color='rgb(0,0,0)')),
      #title=plottitle,
           titlefont=list(size=12),
           margin=list(t=100),
           showlegend=FALSE,#input$showleg,
           yaxis=list(title="Percentage",ticksuffix = "%"),
           xaxis=list(title="Year"),
           #height = input$plotHeight, 
           autosize=TRUE) %>% config(modeBarButtonsToRemove = modebar_remove)
})


#####
#PLOTLY CLICKS 
#####
#this responds to clicks on the graph and takes the user to the other graph based on x axis clicks.
observe({
  d <- event_data("plotly_click", source="clickable")
  if(!isTRUE(all.equal(selected_pclick,d))){
    selected_pclick <<- d
    new_value <- ifelse(is.null(d),"0",d$x) # 0 if no selection
    new_value <- gsub("<br>"," ",new_value)
    new_value <- gsub(")"," Division)",new_value)
    
    if(!is.null(selected_pclick) && input$ovplotting == 'breakdown'){
      if(!(input$ov_var %in% names(all_vars))){
        updateTabsetPanel(session, "ovplotting", selected = "trends")
        updateSelectizeInput(session, "ov_pdiv", selected = new_value)
      }
      #a hack to change variable based on nearest y value. not great :/
      if(input$ov_var %in% names(all_vars)){
        df %>% filter(
          police_div %in% new_value,
          year %in% input$ov_year,
          variable %in% all_vars[[input$ov_var]]) %>% 
        select(variable,p_diff) %>%
          arrange(p_diff) -> yopts
        newy = d$y
        newv = yopts$variable[which.min(abs(yopts$p_diff - newy))]
        updateSelectInput(session, "ov_var", selected = as.character(newv))
      }
    }
    if(!is.null(selected_pclick) && input$ovplotting == 'trends'){
      updateSelectizeInput(session, "ov_var",
          selected=ifelse(input$ov_var %in% names(all_vars), input$ov_var, names(all_vars[-1])[grepl(input$ov_var,all_vars[-1])]))
      invalidateLater(2000,session)
      updateTabsetPanel(session, "ovplotting", selected = "breakdown")
      updateSelectizeInput(session, "ov_year", selected = new_value)
    }
  }
})

########
# VARIABLE INFO 
########
# this updates the text information on the selected area of the survey (see variable_information.R for text)
output$variable_info_ov<-renderUI({
  div(class="variable_info",
      tags$body(includeScript("./www/moreclick.js")),
      HTML(paste0("<h5>",input$ov_var,"</h5>",
                  '<span class="more">',variable_info_list[[input$ov_var]],"</span>"))
      
  )
})
