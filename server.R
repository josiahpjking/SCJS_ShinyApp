library(shiny)
library(plotly)
require(tidyr)
require(dplyr)
require(magrittr)
library(shinydashboard)




server <- function(input, output, session){
  
  
  
  
  observeEvent(input$link_overview,{
    newvalue <- "main_overview"
    updateTabItems(session, "main", newvalue)
  })
  observeEvent(input$link_trends,{
    newvalue <- "main_trends"
    updateTabItems(session, "main", newvalue)
  })
  observeEvent(input$link_compare,{
    newvalue <- "main_compare"
    updateTabItems(session, "main", newvalue)
  })
  observeEvent(input$link_tables,{
    newvalue <- "main_tables"
    updateTabItems(session, "main", newvalue)
  })
  
  
  
  
  
  
  
  
  
  output$plotopts<-renderUI({
    list(
      div(style="display:inline-block",checkboxInput("erbar",label = "Show CIs:",value=FALSE)),
      div(style="display:inline-block",checkboxInput("showleg",label = "Show Legend:",value=FALSE))
         )
  })
    
  
  
  
  
  #server side update of variable selection for trend plot based on what section of the survey they are interested in.
  output$var_select = renderUI({
    selectizeInput("var_select",label = "Choose Variables",choices=all_vars[[input$survey_section]],multiple=T,selected=all_vars[[input$survey_section]][1])
  })
  
  
  observe({
      d <- event_data("plotly_click")
      new_value <- ifelse(is.null(d),"0",d$x) # 0 if no selection
      new_value <- gsub("<br>"," ",new_value)
      new_value <- gsub(")"," Division)",new_value)
      if(selected_pclick!=new_value) {
        selected_pclick <<- new_value 
        if(selected_pclick !=0 && input$plottingov == 'breakdown'){
          updateTabsetPanel(session, "plottingov", selected = "trends")
          updateSelectizeInput(session, "ov_pdiv", selected = selected_pclick)
        }
        if(selected_pclick !=0 && input$plottingov == 'trends'){
          updateTabsetPanel(session, "plottingov", selected = "breakdown")
          updateSelectizeInput(session, "ov_year", selected = selected_pclick)
        }
      }
    })
  

  source("server_icon.R", local = TRUE)
  
  source("server_summary.R", local = TRUE)
  
  source("server_trendplot.R", local = TRUE)
  
  source("server_compare.R", local = TRUE)
  
  source("server_table.R", local = TRUE)
  
  source("server_overview.R", local = TRUE)
  
  

  
  output$stt_results<-renderPrint({
    p1=as.numeric(input$stt_p1)/100
    p2=as.numeric(input$stt_p2)/100
    ss1=as.numeric(input$stt_ss1)
    ss2=as.numeric(input$stt_ss2)
    ci1=1.96*sqrt(((p1*(1-p1)))/ss1)*des_factors$des_f[des_factors$year==input$stt_y1]
    ci2=1.96*sqrt(((p2*(1-p2)))/ss2)*des_factors$des_f[des_factors$year==input$stt_y2]
    signif=ifelse(abs(p1-p2)>sqrt((ci1^2)+ci2^2),"<font color='green'>is significantly different from</font>","<font color='red'>is NOT significantly different from</font>")
    cat(input$stt_p1,"+/-",round(ci1*100,1),"<br><b>",signif,"</b><br>",input$stt_p2,"+/-",round(ci2*100,1),sep=" ")
  })
  


  #reset trend plots
  observeEvent(input$reset_trends, {
    updateSelectizeInput(session, "parea", selected = "National Average")
    updateSelectizeInput(session, "var_select", selected = all_vars[[input$survey_section]][1])
  })
  
  
  
  #select all tables
  observe({
    if("Select All" %in% input$table_pdiv){
      updateSelectizeInput(session, "table_pdiv", choices = pdivis)
    }
    if("Select All" %in% input$table_var){
      updateSelectizeInput(session, "table_var", selected = unname(unlist(all_vars)))
    }
  })
  

}
