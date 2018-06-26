plotfunc<-function(x,pd,pdat){
  pdat %>% filter(variable %in% x) %>% 
    filter(police_div %in% pd) -> bardata 
  pdat %>% filter(variable %in% x) %>%
    filter(police_div %in% c("National Average")) -> linedata
  plot_ly(bardata,
          x=~year,
          y=~percentage,
          color=~change,
          colors=~overview_cols,
          text=~my_text3,
          hoverinfo="text",
          type="bar",name=~variable) %>%
    add_lines(data=linedata, color=~police_div, colors=overview_cols) %>%
    layout(yaxis=list(title=~ylabel, ticksuffix = "%"),
           xaxis=list(title="",tickangle=0))
}