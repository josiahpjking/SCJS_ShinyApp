library(shiny)
library(leaflet)
library(plotly)
require(tidyr)
require(dplyr)
require(magrittr)
require(forcats)


#source("source/plotfunc.R") no longer used

# these are for the plotly click hack. need to declare outside server function.
selected_pclick <- 0 
selected_y <- 0

server <- function(input, output, session){
  
  source("source/variable_information.R", local = TRUE)
  
  source("source/server_home.R",local=T)
  
  source("source/server_map.R",local=T)
  
  source("source/server_trendplot.R", local = TRUE)
  
  source("source/server_compare.R", local = TRUE)
  
  source("source/server_table.R", local = TRUE)
  
  source("source/server_overview.R", local = TRUE)
  
}
