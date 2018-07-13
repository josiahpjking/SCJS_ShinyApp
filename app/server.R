library(shiny)
library(leaflet)
library(plotly)
require(tidyr)
require(dplyr)
require(magrittr)

source("source/plotfunc.R")
selected_pclick <- 0 #declare outside the server function
selected_y <- 0

server <- function(input, output, session){
  
  source("source/variable_information.R", local = TRUE)
  
  source("source/server_home.R",local=T)
  
  source("source/server_map.R",local=T)
  
  #source("source/server_summary.R", local = TRUE)
  
  source("source/server_trendplot.R", local = TRUE)
  
  source("source/server_compare.R", local = TRUE)
  
  source("source/server_table.R", local = TRUE)
  
  source("source/server_overview.R", local = TRUE)
  
}
