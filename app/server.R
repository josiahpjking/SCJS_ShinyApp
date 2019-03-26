library(shiny)
library(leaflet)
library(plotly)
library(tidyr)
library(dplyr)
library(magrittr)
library(forcats)


#source("source/plotfunc.R") no longer used

# these are for the plotly click hack. need to declare outside server function.
selected_pclick <- NULL

server <- function(input, output, session){
  #suppressing warnings. for some reason the app was throwing an explicit id warning message. after researching it seems that suppressing the message won't have any adverse effect. See this for more details:
  # https://github.com/hrbrmstr/metricsgraphics/issues/49
  options(warn = -1)
  
  source("source/variable_information.R", local = TRUE)
  
  source("source/server_home.R",local=T)
  
  source("source/server_map.R",local=T)
  
  source("source/server_trendplot.R", local = TRUE)
  
  source("source/server_compare.R", local = TRUE)
  
  source("source/server_table.R", local = TRUE)
  
  source("source/server_overview.R", local = TRUE)
  
}
