plotfunc<-function(x,pd,pdat){
  pdat %>% filter(variable %in% x) %>% 
    filter(breaks %in% pd) -> bardata 
  pdat %>% filter(variable %in% x) %>%
    filter(breaks %in% c("National Average")) -> linedata
  plot_ly(bardata,
          x=~year,
          y=~percentage,
          color=~change,
          colors=~overview_cols,
          text=~my_text,
          hoverinfo="text",
          type="bar",name=~variable) %>%
    add_lines(data=linedata, color=~breaks, colors=overview_cols) %>%
    layout(yaxis=list(title=~ylabel, ticksuffix = "%"),
           xaxis=list(title="",tickangle=0))
}