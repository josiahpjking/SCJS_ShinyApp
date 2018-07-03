
trend_data<-reactive({
  #data for plotting
  df %>% filter(police_div %in% input$trends_pdiv) %>% 
    filter(variable %in% input$trends_var2) %>% mutate(
      wrapped_name = sapply(name_trunc, FUN = function(x) {paste(strwrap(x, width = 35), collapse = "<br>")}),
      my_text = paste0("<b>",police_div,"</b><br>",year,"<br>",wrapped_name,"<br><b>",round(percentage, digits=1),"</b>% +/-",round(ci*100, digits=1),", N = ",samplesize)
    ) %>% filter(!is.na(p))
})

output$trendplot <- renderPlotly({
  if (input$erbar==TRUE){
    plot_ly(trend_data(), 
            x=~year, 
            y=~percentage, 
            text=~my_text, 
            hoverinfo="text",
            color=~police_div, 
            colors=pdivcols) %>%
      add_markers(y=~percentage, error_y=list(array = ~ci*100), showlegend=FALSE) %>%
      add_lines(y=~percentage, linetype=~wrapped_name) -> p
  } else {
    plot_ly(trend_data(), 
            x=~year, 
            y=~percentage,
            text=~my_text, 
            hoverinfo="text",
            color=~police_div, 
            colors=pdivcols) %>%
      add_markers(y=~percentage, showlegend=FALSE) %>% 
      add_lines(y=~percentage, linetype=~wrapped_name) -> p
  }
  p %>% layout(xaxis=list(title=""),
               showlegend=input$showleg1,
               yaxis=list(title=~ylabel,ticksuffix = "%"),
               legend = list(x=1.1,y=1),
               height = input$plotHeight) %>% config(modeBarButtonsToRemove = modebar_remove)
})
