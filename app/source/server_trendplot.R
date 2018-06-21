
trend_data<-reactive({
  #data for plotting
  df %>% filter(breaks %in% input$parea) %>% 
    filter(variable %in% input$var_select) %>% mutate(
      my_text = paste0("<b>",breaks,"</b><br>",wrappedv,"<br>",round(percentage, digits=1),"% +/-",round(ci*100, digits=1),"<br>N = ",samplesize)
    )
})

output$trendplot <- renderPlotly({
  if (input$erbar==TRUE){
    plot_ly(trend_data(), 
            x=~year, 
            y=~percentage, 
            text=~my_text, 
            hoverinfo="text",
            color=~breaks, 
            colors=pdivcols) %>%
      add_markers(y=~percentage, error_y=list(array = ~ci*100)) %>% 
      add_lines(y=~percentage, linetype=~wrappedv) -> p
  } else {
    plot_ly(trend_data(), 
            x=~year, 
            y=~percentage,
            text=~my_text, 
            hoverinfo="text",
            color=~breaks, 
            colors=pdivcols) %>%
      add_markers(y=~percentage) %>% 
      add_lines(y=~percentage, linetype=~wrappedv) -> p
  }
  if (input$showleg==FALSE){
    p %>% layout(xaxis=list(title=""),
                 yaxis=list(title=~ylabel,ticksuffix = "%"),
                 showlegend=FALSE,
                 height = input$plotHeight, 
                 autosize=TRUE) %>% config(modeBarButtonsToRemove = modebar_remove)
  } else{
    p %>% layout(xaxis=list(title=""),
                 yaxis=list(title=~ylabel,ticksuffix = "%"),
                 legend = list(orientation = "h", xanchor = "center", yanchor="top", x = 0.5),
                 height = input$plotHeight, 
                 autosize=TRUE) %>% config(modeBarButtonsToRemove = modebar_remove)
    
  }
})
