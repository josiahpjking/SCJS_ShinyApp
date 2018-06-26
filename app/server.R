library(shiny)
library(plotly)
require(tidyr)
require(dplyr)
require(magrittr)


#setwd("\\\\scotland.gov.uk/dc2/fs4_home/Z613379/pdiv_shiny/v9/app")
source("source/plotfunc.R")
selected_pclick <- 0 #declare outside the server function
load(file = "data/app_preamble.RData")


server <- function(input, output, session){
  
  source("source/server_summary.R", local = TRUE)
  
  source("source/server_trendplot.R", local = TRUE)
  
  source("source/server_compare.R", local = TRUE)
  
  source("source/server_table.R", local = TRUE)
  
  source("source/server_overview.R", local = TRUE)
  
  source("source/server_statstool.R", local = TRUE)
  
  
  
  observeEvent(input$link_overview,{
    newvalue <- "main_overview"
    updateTabsetPanel(session, "main", newvalue)
  })
  observeEvent(input$link_trends,{
    newvalue <- "main_trends"
    updateTabsetPanel(session, "main", newvalue)
  })
  observeEvent(input$link_compare,{
    newvalue <- "main_compare"
    updateTabsetPanel(session, "main", newvalue)
  })
  observeEvent(input$link_tables,{
    newvalue <- "main_tables"
    updateTabsetPanel(session, "main", newvalue)
  })
  observeEvent(input$link_compare1,{
    newvalue <- "main_compare"
    updateTabsetPanel(session, "main", newvalue)
  })

  
  ######
  #server side inputs
  ######
  #plotting options. 
  output$plotopts<-renderUI({
    list(
      div(class="plotcontrol",
          checkboxInput("erbar",label = "Show Confidence Intervals",value=FALSE)),
      div(class="plotcontrol",
          checkboxInput("showleg",label = "Show Legend",value=FALSE))
    )
  })
    
  #variable selection - based on list index of all vars (i.e. nat indicators).
  output$var_select = renderUI({
    selectizeInput("var_select",label = "Choose Variables",choices=all_vars[[input$survey_section]],multiple=T,selected=all_vars[[input$survey_section]][1])
  })
  
  
  
  
  ########
  #Observes
  ########
  
  #tab_overview: plotly clicks for overview data.
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
  
  #tab_trends: reset plots
  observeEvent(input$reset_trends, {
    updateSelectizeInput(session, "parea", selected = "National Average")
    updateSelectizeInput(session, "var_select", selected = all_vars[[input$survey_section]][1])
  })
  
  #tab_tables: reset tables
  observeEvent(input$reset_tables, {
    updateSelectizeInput(session, "table_pdiv", selected = "National Average")
    updateSelectizeInput(session, "table_var", selected = all_vars[[1]][1])
  })
  
  #tab_tables: select all (vars/divisions)
  observe({
    if("Select All" %in% input$table_pdiv){
      updateSelectizeInput(session, "table_pdiv", selected = pdivis)
    }
    if("Select All" %in% input$table_var){
      updateSelectizeInput(session, "table_var", selected = unname(unlist(all_vars)))
    }
  })
  



  

}
