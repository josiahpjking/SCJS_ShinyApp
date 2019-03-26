
#####
#VARIABLE SELECTION > update based on survey area selection.
#####
output$trends_var2 = renderUI({
  selectizeInput("trends_var2",label = "Choose Variables",choices=all_vars[[input$trends_var]],selected=all_vars[[input$trends_var]][1],multiple=F)
})

#####
#DATA - filter and make some string variables for plotting
#####
trend_data<-reactive({
  df %>% filter(police_div %in% input$trends_pdiv) %>% 
    filter(variable %in% input$trends_var2) %>% filter(!is.na(p)) %>%
    mutate(
      year_end = as.numeric(paste0("20",stringr::str_sub(gsub("\\*","",year),-2,-1)))
    )
})

#####
#PLOT TRENDS. this is a fairly simply plot, but has to accommodate options of error bars. 
#####
output$trendplot <- renderPlotly({
  if (input$erbar==TRUE){
      plot_ly(trend_data() %>% arrange(police_div), 
              x=~year, 
              y=~percentage, 
              text=~my_text_trend, 
              hoverinfo="text",
              color=~police_div, 
              colors=pdivcols) %>%
        add_markers(y=~percentage, error_y=list(array = ~ci*100),
                    legendgroup=~police_div,showlegend=FALSE) %>%
        add_lines(y=~percentage, linetype=~wrapped_name, legendgroup=~police_div) -> p
    } else {
      plot_ly(trend_data(), 
              x=~year, 
              y=~percentage,
              text=~my_text_trend, 
              hoverinfo="text",
              color=~police_div, 
              colors=pdivcols) %>%
        add_markers(y=~percentage, legendgroup=~police_div, showlegend=FALSE) %>% 
        add_lines(y=~percentage, linetype=~wrapped_name, legendgroup=~police_div) -> p
    }
    if(input$trendzoom==FALSE){
      p %>% layout(yaxis=list(range=c(0,100))) -> p
    }
    p %>% layout(xaxis=list(title="",dtick=1),#,tickangle=45),
                 showlegend=input$showleg1,
                 yaxis=list(title=~ylabel,ticksuffix = "%"),
                 legend = list(x=1.1,y=1),
                 height = input$plotHeight) %>% config(modeBarButtonsToRemove = modebar_remove)
})


#####
#This is the link to the comparison tool, which is shown in the sidebar of the trends tab.
#####
# observeEvent(input$link_compare1,{
#   newvalue <- "main_compare"
#   updateTabsetPanel(session, "main", newvalue)
# })


#####
#RESET TRENDS PLOT
#####
observeEvent(input$reset_trends, {
  updateSelectizeInput(session, "trends_pdiv", selected = "National Average")
  updateSelectizeInput(session, "trends_var2", selected = all_vars[[input$trends_var]][1])
  updateCheckboxInput(session, "trendzoom", value=FALSE)
  updateCheckboxInput(session, "erbar", value=TRUE)
  updateCheckboxInput(session, "showleg1", value=TRUE)
})


