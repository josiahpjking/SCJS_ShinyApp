library(shiny)
library(leaflet)
library(plotly)
require(tidyr)
require(dplyr)
require(magrittr)


#setwd("\\\\scotland.gov.uk/dc2/fs4_home/Z613379/pdiv_shiny/v9/app")
source("source/plotfunc.R")
selected_pclick <- 0 #declare outside the server function


server <- function(input, output, session){
  
  source("source/variable_information.R", local = TRUE)
  
  source("source/server_map.R",local=T)
  
  source("source/server_summary.R", local = TRUE)
  
  source("source/server_trendplot.R", local = TRUE)
  
  source("source/server_compare.R", local = TRUE)
  
  source("source/server_table.R", local = TRUE)
  
  source("source/server_overview.R", local = TRUE)
  
  source("source/server_statstool.R", local = TRUE)
  
  ########
  #HOME SCREEN BUTTONS
  ########
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
  
  #LINK FROM TRENDS > COMPARISONS
  observeEvent(input$link_compare1,{
    newvalue <- "main_compare"
    updateTabsetPanel(session, "main", newvalue)
  })
  
  ###########################
  ######
  #server side inputs
  
  #overview_tab - input variable selection based on survey area.
  output$ov_var2 = renderUI({
    if(!(input$ov_var %in% names(all_vars) ))
      return()
    selectInput("ov_var2",label = "Choose variable:",choices=c("All",all_vars[[input$ov_var]]), selected="All")
  })
  
  #trends_tab - input variable selection based on survey area.
  output$trends_var2 = renderUI({
    checkboxGroupInput("trends_var2",label = "Choose Variables",choices=all_vars[[input$trends_var]],selected=all_vars[[input$trends_var]][1])
  })
  
  #overview_tab - observe plotly click to change graph based on x value.
  observe({
      d <- event_data("plotly_click")
      new_value <- ifelse(is.null(d),"0",d$x) # 0 if no selection
      new_value <- gsub("<br>"," ",new_value)
      new_value <- gsub(")"," Division)",new_value)
      if(selected_pclick!=new_value) {
        selected_pclick <<- new_value 
        if(selected_pclick !=0 && input$ovplotting == 'breakdown'){
          updateTabsetPanel(session, "ovplotting", selected = "trends")
          updateSelectizeInput(session, "ov_pdiv", selected = selected_pclick)
        }
        if(selected_pclick !=0 && input$ovplotting == 'trends'){
          updateTabsetPanel(session, "ovplotting", selected = "breakdown")
          updateSelectizeInput(session, "ov_year", selected = selected_pclick)
        }
      }
    })
  
  
  #RESET TREND PLOTS
  observeEvent(input$reset_trends, {
    updateSelectizeInput(session, "trend_pdiv", selected = "National Average")
    updateSelectizeInput(session, "trends_var2", selected = all_vars[[input$trends_var]][1])
  })
  
  #RESET TABLES
  observeEvent(input$reset_tables, {
    updateSelectizeInput(session, "table_pdiv", selected = "National Average")
    updateSelectizeInput(session, "table_var", selected = all_vars[[1]][1])
  })
  
  #SELECT ALL in TABLES
  observe({
    if("Select All" %in% input$table_pdiv){
      updateSelectizeInput(session, "table_pdiv", selected = pdivis)
    }
    if("Select All" %in% input$table_var){
      updateSelectizeInput(session, "table_var", selected = unname(unlist(all_vars)))
    }
  })
  

}
