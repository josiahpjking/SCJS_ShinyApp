library(shiny)
library(leaflet)
library(plotly)
require(tidyr)
require(dplyr)
require(magrittr)

source("source/ui_home.R")
source("source/ui_overview.R")
source("source/ui_comparison.R")
source("source/ui_trends.R")
source("source/ui_tables.R")
source("source/ui_help.R")


fluidPage(
  
  #get CSS style stuff.
  includeCSS("./www/stuff.css"),
  includeCSS("./www/bootstrap-theme.min.css"),
  
  #main body of app. It's a navbar, so menu at top, different tabs.
  #each tab is sourced from a separate file to help the layout be a little easier to get to grips with.
  
  navbarPage(title="",
             id="main",
             position="fixed-top", 
             collapsible=TRUE,
             
             header = div(id="header-back",
                          div(id="header-content",
                              tags$h1(id = "header-text", a(target="_blank",href="http://www.gov.scot/Topics/Statistics/Browse/Crime-Justice/crime-and-justice-survey","Scottish Crime & Justice Survey"))
                          )
             ),
             
             tabPanel("Home",icon = icon('home',lib="glyphicon"),
                      home_page
             ),
             tabPanel("Breakdown by Police Divisions", value="main_divisions",
                      overview_page
             ),
             tabPanel("Comparison Tool", value="main_compare", icon = icon('bar-chart'),
                      comparison_page
             ),
             tabPanel("Visualise Trends", value="main_trends", icon = icon('line-chart'),
                      trends_page
             ),
             tabPanel("Tables", value="main_tables", icon = icon('download-alt', lib='glyphicon'),
                      table_page
             ),
             tabPanel("Help & Information", value="main_help", icon=icon('info-sign',lib="glyphicon"),
                      help_page
             )
  )
)
