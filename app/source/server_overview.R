overview_data <- reactive({
  df %>% filter(breaks=="National Average") %>% mutate(
    nat_avgp = percentage,
    nat_avgci = ci
  ) %>% select(variable,year,nat_avgp,nat_avgci) -> nat_avg
    
  left_join(df, nat_avg) %>% 
    mutate(
      p_diff=percentage-nat_avgp,
      p_diff2=ifelse(reverse_coded==1,0-p_diff,p_diff),
      p_direction=ifelse(p_diff2==0,"Same",
                         ifelse(p_diff2>0,"Better","Worse")),
      c=sqrt((ci^2)+(nat_avgci^2)),
      change=ifelse(((abs(p_diff)/100)>c)==TRUE & p_direction=="Better","Better",
                    ifelse(((abs(p_diff)/100)>c)==TRUE & p_direction=="Worse","Worse","Same")),
      my_text = paste0("<b>",breaks,"</b><br>",wrapped_name,"<br>",round(percentage, digits=1),"% +/-",round(ci*100, digits=1),"<br>N = ",samplesize)
      ) %>% select(-c(p_direction,c))
  })
 

output$ov_currentplot <- renderPlotly({
  if(!(input$ov_var %in% names(all_vars))){
    overview_data() %>% filter(variable %in% input$ov_var) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(breaks!="National Average") %>%
      mutate(
        wrappedbreaks=sapply(gsub(" Division","",breaks), FUN = function(x) {paste(strwrap(x, width = 15), collapse = "<br>")})
      ) %>%
      plot_ly(.,
              x=~wrappedbreaks,
              y=~p_diff,
              color=~change,
              text=~my_text,
              hoverinfo="text",
              colors=overview_cols,
              type="bar") %>% layout(margin = list(b = 100),
                                     showlegend=input$showleg,
                                     height = input$plotHeight, 
                                     autosize=TRUE,
                                     yaxis=list(title="Percentage difference from<br>National Average",ticksuffix = "%"),
                                     xaxis=list(title="",
                                                tickangle=90,
                                                categoryarray=~wrappedbreaks[order(p_diff)], 
                                                categoryorder="array")
              ) %>% config(modeBarButtonsToRemove = modebar_remove)
  } else if(input$ov_var %in% names(all_vars)){
    overview_data() %>% filter(variable %in% all_vars[[input$ov_var]]) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(breaks!="National Average") %>%
      mutate(
        wrappedbreaks=sapply(gsub(" Division","",breaks), FUN = function(x) {paste(strwrap(x, width = 15), collapse = "<br>")})
      ) %>%
      group_by(wrappedbreaks) %>%
      summarise(
        av=mean(p_diff2)
      ) %>% arrange(av) %>% mutate(plotorder=seq(1:nrow(.))) -> orderwrap
    
    
    overview_data() %>% filter(variable %in% all_vars[[input$ov_var]]) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(breaks!="National Average") %>%
      mutate(
        wrappedbreaks=sapply(gsub(" Division","",breaks), FUN = function(x) {paste(strwrap(x, width = 15), collapse = "<br>")})
      ) %>% 
      plot_ly(.,
              x=~wrappedbreaks,
              y=~p_diff,
              color=~change,
              text=~my_text,
              hoverinfo="text",
              colors=overview_cols,
              type="scatter",mode="markers",marker = list(symbol=24, size = 12)
              ) %>%
        layout(margin = list(b = 100),
               showlegend=input$showleg,
               height = input$plotHeight, 
               autosize=TRUE,
               yaxis=list(title="Percentage difference from<br>National Average",ticksuffix = "%"),
               xaxis=list(title="",
                          tickangle=90,
                          categoryarray=~orderwrap$wrappedbreaks, 
                          categoryorder="array")
        ) %>% config(modeBarButtonsToRemove = modebar_remove)
  }
})

output$ov_trendplot <- renderPlotly({
  if(!(input$ov_var %in% names(all_vars))){
    overview_data() %>% filter(variable %in% input$ov_var) %>% 
      filter(breaks %in% input$ov_pdiv) -> bardata 
    overview_data() %>% filter(variable %in% input$ov_var) %>%
      filter(breaks %in% c("National Average")) -> linedata
    plot_ly(bardata,
            x=~year,
            y=~percentage,
            color=~change,
            colors=~overview_cols,
            text=~my_text,
            hoverinfo="text",
            type="bar") %>%
    add_lines(data=linedata, color=~breaks, colors=overview_cols) %>%
      layout(showlegend=input$showleg,
             yaxis=list(ticksuffix = "%"),
             xaxis=list(title=""),
             height = input$plotHeight, 
             autosize=TRUE) %>% config(modeBarButtonsToRemove = modebar_remove)
  } else if(input$ov_var %in% names(all_vars)){
    
    pheight=(length(all_vars[[input$ov_var]])*100)+100
    subplot(lapply(all_vars[[input$ov_var]], function(x) plotfunc(x,input$ov_pdiv,overview_data())),nrows=round(length(all_vars[[input$ov_var]])/2),titleY=FALSE,titleX=FALSE) %>% 
      layout(showlegend=input$showleg,height=pheight) %>% config(modeBarButtonsToRemove = modebar_remove) 

  }
  
})



output$ov_animateplot <- renderPlotly({
  overview_data() %>% filter(variable %in% input$ov_var) %>%
    filter(breaks!="National Average") %>%
    mutate(
      wrappedbreaks=sapply(gsub(" Division","",breaks), FUN = function(x) {paste(strwrap(x, width = 15), collapse = "<br>")})
    ) %>%
    plot_ly(.,
            x=~wrappedbreaks,
            y=~p_diff,
            color=~change,
            frame=~year,
            text=~my_text,
            hoverinfo="text",
            colors=overview_cols,
            type="bar") %>% layout(margin = list(b = 100),
                                   showlegend=FALSE,
                                   height = input$plotHeight, 
                                   autosize=TRUE,
                                   yaxis=list(title="Percentage difference from<br>National Average",ticksuffix = "%"),
                                   xaxis=list(title="",tickangle=90)
            ) %>% config(modeBarButtonsToRemove = modebar_remove)
})


