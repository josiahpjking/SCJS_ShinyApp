overview_data <- reactive({
  df %>% filter(police_div=="National Average") %>% mutate(
    nat_avgp = percentage,
    nat_avgci = ci
  ) %>% select(variable,year,nat_avgp,nat_avgci) -> nat_avg
  
  left_join(df, nat_avg) %>% 
    mutate(
      p_diff=percentage-nat_avgp,
      p_diff2=ifelse(reverse_coded==1,0-p_diff,p_diff),
      p_direction=ifelse(p_diff2==0,"No difference",
                         ifelse(p_diff2>0,"More Positive","Less Positive")),
      c=sqrt((ci^2)+(nat_avgci^2)),
      change=ifelse(((abs(p_diff)/100)>c)==TRUE & p_direction=="More Positive","More Positive",
                    ifelse(((abs(p_diff)/100)>c)==TRUE & p_direction=="Less Positive","Less Positive","No difference")),
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
      wrappedpolice_div=sapply(gsub(" Division","",police_div), FUN = function(x) {paste(strwrap(x, width = 15), collapse = "<br>")})
      ) %>% select(-c(p_direction,c))
  })
 

output$ov_currentplot <- renderPlotly({
  if(!(input$ov_var %in% names(all_vars))){
    overview_data() %>% filter(variable %in% input$ov_var) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div == "National Average") -> line_data
    
    overview_data() %>% filter(variable %in% input$ov_var) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div!="National Average") -> bar_data
    
      plot_ly(bar_data,
              x=~wrappedpolice_div,
              y=~percentage,
              color=~change,
              text=~my_text,
              hoverinfo="text",
              colors=overview_cols,
              type="bar") %>%
      layout(title=paste0("<b>",input$ov_year,"</b><br>",paste(strwrap(input$ov_var, width = 75), collapse = "<br>")),
             margin = list(t=70, b = 100),
             showlegend=input$showleg,
             height = input$plotHeight, 
             autosize=TRUE,
             yaxis=list(title="Percentage",ticksuffix = "%"),
             xaxis=list(title="",tickangle=90,
                        categoryarray=~wrappedpolice_div[order(p_diff)], categoryorder="array")
      ) %>%
        add_lines(inherit=F,
                  data=line_data, 
                  x=bar_data$wrappedpolice_div,
                  y=~percentage,
                  color=~police_div,
                  text=~natav_text, hoverinfo="text") %>% config(modeBarButtonsToRemove = modebar_remove)

  } else if(input$ov_var %in% names(all_vars)){
    
    #get plotting order (can't do it as above.)
    overview_data() %>% filter(variable %in% all_vars[[input$ov_var]]) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div!="National Average") %>%
      group_by(wrappedpolice_div) %>%
      summarise(
        av=mean(p_diff2,na.rm=T)
      ) %>% arrange(av) %>%
      mutate(plotorder=seq(1:nrow(.))) -> orderwrap
    
    
    overview_data() %>% filter(variable %in% all_vars[[input$ov_var]]) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div!="National Average") -> bar_data
    
    bar_data %>% select(variable, wrappedpolice_div) %>%
      left_join(., 
                overview_data() %>% 
                  filter(variable %in% all_vars[[input$ov_var]]) %>% 
                  filter(year %in% input$ov_year) %>% 
                  filter(police_div=="National Average") %>%
                  select(-wrappedpolice_div)
      ) -> line_data
    
    plot_ly(bar_data %>% group_by(wrappedpolice_div),
            x=~wrappedpolice_div,
            split=~wrapped_name,
            legendgroup=~wrapped_name) %>%
      add_trace(x=~wrappedpolice_div,
                y=~p_diff,
                color=~change,
                text=~my_text,
                hoverinfo="text",
                colors=overview_cols,
                type="scatter",mode="markers",marker = list(symbol=24, size = 15),
                split=~wrapped_name,
                legendgroup=~wrapped_name) %>%
      layout(title=paste0("<b>",input$ov_year,"</b><br>",input$ov_var),
        margin = list(t=70, b = 100),
        showlegend=input$showleg,
        height = input$plotHeight, 
        autosize=TRUE,
        yaxis=list(title="Percentage Point Difference <br> from National Average",ticksuffix = "%"),
        xaxis=list(title="",
                   tickangle=90,
                   categoryarray=~orderwrap$wrappedpolice_div, 
                   categoryorder="array")
      ) %>% #add_lines(data=line_data,
             #         linetype=~wrapped_name,
              #        y=~percentage,
               #       split=~wrapped_name,
                #      line=list(color="black"),
                 #     #opacity=1,
                  #    text=~natav_text, hoverinfo="text",
                   #   showlegend=T) %>% 
      config(modeBarButtonsToRemove = modebar_remove)
  }
})

output$ov_trendplot <- renderPlotly({
  if(!(input$ov_var %in% names(all_vars))){
    overview_data() %>% filter(variable %in% input$ov_var) %>% 
      filter(police_div %in% input$ov_pdiv) -> bardata 
    overview_data() %>% filter(variable %in% input$ov_var) %>%
      filter(police_div %in% c("National Average")) -> linedata
    plot_ly(bardata,
            x=~year,
            y=~percentage,
            color=~change,
            colors=~overview_cols,
            text=~my_text2,
            hoverinfo="text",
            type="bar") %>%
    add_lines(data=linedata,color=~police_div, colors=overview_cols) %>%
      layout(title=paste0("<b>",input$ov_pdiv,"</b><br>",paste(strwrap(input$ov_var, width = 70), collapse = "<br>")),
             margin=list(t=70),
             showlegend=input$showleg,
             yaxis=list(title="Percentage",ticksuffix = "%"),
             xaxis=list(title="Year"),
             height = input$plotHeight, 
             autosize=TRUE) %>% config(modeBarButtonsToRemove = modebar_remove)
  } else if(input$ov_var %in% names(all_vars)){
    overview_data() %>% filter(variable %in% input$ov_var2) %>%
      filter(police_div %in% c("National Average",input$ov_pdiv)) %>% 
      mutate(
        perc1 = ifelse(police_div=="National Average",percentage, NA),
        perc2 = ifelse(police_div==input$ov_pdiv, percentage, NA)
      ) %>% 
      plot_ly(., 
              x=~year,
              y=~perc1,
              type="scatter",mode="lines",
              text=~my_text2,hoverinfo="text",
              color=~variable,
              line=list(color="black"),
              colors=overview_cols, showlegend=F) %>%
        add_trace(type="bar",mode="marker", y=~perc2, color=~change) %>%
        layout(title=paste0("<b>",input$ov_pdiv,"</b><br>",paste(strwrap(input$ov_var2, width = 70), collapse = "<br>")),
          showlegend=input$showleg,
          margin=list(t=70),
          yaxis=list(title="Percentage",ticksuffix = "%"),
          xaxis=list(title="Year"),
          height = input$plotHeight, 
          autosize=TRUE) %>% config(modeBarButtonsToRemove = modebar_remove)
  }
})
