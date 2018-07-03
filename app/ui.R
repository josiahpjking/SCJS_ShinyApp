library(shiny)
library(leaflet)
library(plotly)
require(tidyr)
require(dplyr)
require(magrittr)

fluidPage(
  
  #get CSS style stuff.
  includeCSS("./www/stuff.css"),
  
  #main body of app. It's a navbar, so menu at top, different tabs.
  #each tab is sourced from a separate file to help the layout be a little easier to get to grips with.
  navbarPage(title="",
             id="main",
             position="fixed-top", 
             collapsible=TRUE,
             
             header = div(class="header-back",
               tags$h1(class="head-control",
                     a(target="_blank",href="http://www.gov.scot/Topics/Statistics/Browse/Crime-Justice/crime-and-justice-survey","Scottish Crime & Justice Survey"),
                     tags$img(src="scotgov.png",width=200,align="left")
             )),
             #########
             #HOME
             #########
             tabPanel("Home",icon = icon('home',lib="glyphicon"),
                      source("source/ui_home.R")
             ),
             
             ##########
             #Overviews (main_overview)
             ##########
             tabPanel("Overview of Police Divisions", value="main_overview",
                      source("source/ui_overview.R", verbose=F)
             ),
             
             ##########
             #COMPARISON TOOL (main_compare)
             ##########
             
             tabPanel("Comparison Tool", value="main_compare", icon = icon('bar-chart'),
                      source("source/ui_comparison.R")
             ),
             
             ##########
             #TRENDS OVER TIME (main_trends)
             ##########
             
             tabPanel("Visualise Trends", value="main_trends", icon = icon('line-chart'),
                      source("source/ui_trends.R")
             ),
             
             ##########
             #TABLES (main_tables)
             ##########
             tabPanel("Tables", value="main_tables", icon = icon('download-alt', lib='glyphicon'),
                      source("source/ui_tables.R")
             ),
             
             
             ##########
             #HELP & INFO (main_help)
             ##########
             tabPanel("Help & Information", value="main_help", icon=icon('info-sign',lib="glyphicon"),
                      source("source/ui_help.R")
             )
  )
)
