library(shiny)
library(leaflet)
library(plotly)
require(tidyr)
require(dplyr)
require(magrittr)

#home tab - text, indicator graphics, map, button links
source("source/ui_home.R")
#overview tab - sidebar inputs and variable info, main = plots.
source("source/ui_overview.R")
#comparison tab - sidebar input, main = input and plot
source("source/ui_comparison.R")
#trends tab - sidebar input, main = plot
source("source/ui_trends.R")
#tables tab - user inputs at top, table below
source("source/ui_tables.R")
#just text.
source("source/ui_help.R")
#credits (links to JAS, etc.)
source("source/ui_links.R")

headpanel<-div(id="header-content",
                tags$h1(id = "header-text", a(target="_blank",href="http://www.gov.scot/Topics/Statistics/Browse/Crime-Justice/crime-and-justice-survey","SCOTTISH CRIME & JUSTICE SURVEY"))
)


fluidPage(title="Scottish Crime and Justice Survey", #set title for easier relocating on browser.
  
  #get CSS style stuff.
  includeCSS("./www/stuff.css"),
  includeCSS("./www/bootstrap-theme.min.css"),
  #main body of app. It's a navbar, so menu at top, different tabs.
  #each tab is sourced from a separate file to help the layout be a little easier to get to grips with.
  
  navbarPage(title="",
             id="main",
             position="fixed-top", 
             collapsible=TRUE,
             
             header = div(id = "header-blank",
                          div(id="beta",
                              tags$img(src="beta.png"))
                          ),
             
             tabPanel("Home",icon = icon('home',lib="glyphicon"),
                      headpanel,
                      tags$h4(style="color: black", "Disclaimer: This site is still in Beta. Layout and data have not yet been finalised and quality assured."),
                      home_page
             ),
             tabPanel("Breakdown by Police Divisions", value="main_divisions", icon = icon('bar-chart'),
                      headpanel,
                      overview_page
             ),
             tabPanel("Comparison Tool", value="main_compare", icon=icon('balance-scale'),
                      headpanel,
                      comparison_page
             ),
             tabPanel("Visualise Trends", value="main_trends", icon = icon('line-chart'),
                      headpanel,
                      trends_page
             ),
             tabPanel("Tables", value="main_tables", icon = icon('download-alt', lib='glyphicon'),
                      headpanel,
                      table_page
             ),
             tabPanel("Help & Information", value="main_help", icon=icon('info-sign',lib="glyphicon"),
                      headpanel,
                      help_page
             )
  ),
  linkpanel
)
