overview_data <- reactive({
  df %>% filter(variable %in% c(all_vars[[1]],all_vars[[3]])) %>% filter(breaks=="National Average") %>% mutate(
    nat_avgp = percentage,
    nat_avgci = ci
  ) %>% select(variable,year,nat_avgp,nat_avgci) -> nat_avg
    
  left_join(df %>% filter(variable %in% c(all_vars[[1]],all_vars[[3]])), nat_avg) %>% 
    mutate(
      p_diff=percentage-nat_avgp,
      p_diff=ifelse(reverse_coded==1,0-p_diff,p_diff),
      p_direction=ifelse(p_diff==0,"Same",
                         ifelse(p_diff>0,"Better","Worse")),
      c=sqrt((ci^2)+(nat_avgci^2)),
      change=ifelse(((abs(p_diff)/100)>c)==TRUE & p_direction=="Better","Better",
                    ifelse(((abs(p_diff)/100)>c)==TRUE & p_direction=="Worse","Worse","Same")),
      my_text = paste0("<b>",breaks,"</b><br>",wrappedv,"<br>",round(percentage, digits=1),"% +/-",round(ci*100, digits=1),"<br>N = ",samplesize)
      ) %>% select(-c(p_direction,c))
  })
  
output$ov_currentplot <- renderPlotly({
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
            colors=c("Same"="#BDBDBD","Better"="#82FA58","Worse"="#FA5858"),
            type="bar") %>% layout(margin = list(b = 100),
                                   showlegend=FALSE,
                                   height = input$plotHeight, 
                                   autosize=TRUE,
                                   yaxis=list(title="Percentage difference from<br>National Average",ticksuffix = "%"),
                                   xaxis=list(title="",
                                              tickangle=90,
                                              categoryarray=~wrappedbreaks[order(p_diff)], 
                                              categoryorder="array")
            ) %>% config(modeBarButtonsToRemove = modebar_remove)
})

output$ov_trendplot <- renderPlotly({
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
    layout(showlegend=FALSE,
           yaxis=list(ticksuffix = "%"),
           height = input$plotHeight, 
           autosize=TRUE) %>% config(modeBarButtonsToRemove = modebar_remove)
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
            colors=c("none"="#BDBDBD","up"="#82FA58","down"="#FA5858"),
            type="bar") %>% layout(margin = list(b = 100),
                                   showlegend=FALSE,
                                   height = input$plotHeight, 
                                   autosize=TRUE,
                                   yaxis=list(title="Percentage difference from<br>National Average",ticksuffix = "%"),
                                   xaxis=list(title="",tickangle=90)
            ) %>% config(modeBarButtonsToRemove = modebar_remove)
})


