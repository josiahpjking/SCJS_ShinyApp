library(shiny)
library(plotly)
require(tidyr)
require(dplyr)
require(magrittr)
library(shinydashboard)

header <- titlePanel(title="Scottish Crime & Justice Survey", 
                          tags$li(a(href = 'http://www.gov.scot/Topics/Statistics/Browse/Crime-Justice/crime-and-justice-survey',
                                    img(src = "www/scotgov.png",align="right",height = "30px"))))


#

body<-navbarPage(title=header, id="main",
    tabPanel("Home",icon = icon('home',lib="glyphicon"),
             fluidRow(
               column(width=6,align="center",actionLink("link_overview", "Overview",icon=icon("bar-chart","fa-3x"))),
               column(width=6,align="center",actionLink("link_trends", "Visualise",icon=icon("bar-chart","fa-3x")))
             ),
             fluidRow(
               column(width=6,align="center",actionLink("link_compare", "Compare",icon=icon("bar-chart","fa-3x"))),
               column(width=6,align="center",actionLink("link_tables", "Tables",icon=icon("bar-chart","fa-3x")))
             ),
             htmlOutput('home_summary')
    ),
    tabPanel("Scotland Overview", value="main_overview",
             sidebarLayout(
               sidebarPanel(
                 selectizeInput("ov_var",label="Choose National Indicator",choices=c(all_vars[[1]],all_vars[[3]]),multiple=F,selected=NULL),
                 conditionalPanel(
                   condition="input.plottingov == 'breakdown'",
                   selectizeInput("ov_year",label="Choose Year",choices=years,selected=years[length(years)],multiple=F)
                 ),
                 conditionalPanel(
                   condition="input.plottingov == 'trends'",
                   selectizeInput("ov_pdiv",label="Choose Division",choices=pdivis,selected=pdivis[1],multiple=F)
                 )
               ),
               mainPanel(
                 tabsetPanel(id="plottingov",selected="breakdown",
                             tabPanel(title="1 Year Breakdown",value="breakdown",
                                      plotlyOutput("ov_currentplot", height = "100%",width='100%')
                             ),
                             tabPanel(title="Within Division Trends",value="trends",
                                      plotlyOutput("ov_trendplot", height = "100%",width='100%')
                             ),
                             tabPanel(title="Animated plot over years",value="anim",
                                      plotlyOutput("ov_animateplot", height = "100%",width='100%')
                             )
                 )
               )
             )
    ),
    tabPanel("Visualise Trends", value="main_trends", icon = icon('line-chart'),
             fluidRow(
               column(width=12,align="right",uiOutput("plotopts"))
             ),
             fluidRow(
               column(width=4, htmlOutput('trend_summary')),
               column(width=8, plotlyOutput("trendplot", height = "100%",width='100%'))
             ),
             fluidRow(
               column(width=4,selectizeInput("survey_section", label = "Choose Survey Area", choices=names(all_vars), selected=names(all_vars)[1], multiple=F)),
               column(width=4,uiOutput('var_select')),
               column(width=4,selectizeInput("parea",label="Choose Police Divisions",choices=pdivis, selected="National Average", multiple = T, options = list(maxItems = length(pdivis))))
             ),
             fluidRow(
               column(width=12,align="right", actionButton("reset_trends", "Reset Plot"))
             )
    ),
    tabPanel("Comparison Tool", value="main_compare", icon = icon('bar-chart'),
             htmlOutput('compare_summary'),
             fluidRow(
               column(width=12,align="center",selectizeInput("survey_section_compare", label = "Choose Survey Area", choices=names(all_vars), selected=names(all_vars)[1], multiple=F))
             ),
             fluidRow(
               column(width=6,align="center",selectizeInput("parea1",NULL,choices=pdivis, selected="National Average", multiple = F)),
               column(width=6,align="center",selectizeInput("parea2",NULL,choices=pdivis, selected="National Average", multiple = F))
             ),
             fluidRow(
               column(width=6,align="center",selectizeInput("year1",NULL,choices=years, selected=years[length(years)], multiple = F)),
               column(width=6,align="center",selectizeInput("year2",NULL,choices=years, selected=years[length(years)], multiple = F))
             ),
             fluidRow(
               column(width=12,align="center",plotlyOutput('compar_plot', height = "100%",width='90%'))
             )
    ),
    tabPanel("Tables", value="main_tables", icon = icon('download-alt', lib='glyphicon'),
             fluidRow(
               column(width=5,selectizeInput("table_var",label="Choose Variables",choices = c("Select All", unname(unlist(all_vars))), selected=all_vars[[1]][1], options=list(maxItems=length(unlist(all_vars))))),
               column(width=5,selectizeInput("table_pdiv",label="Choose Police Divisions",choices=c("Select All", pdivis), selected="National Average", options = list(maxItems = length(pdivis)))),
               column(width=2,downloadButton("downloadData", "Download"))
             ),
             tabsetPanel(selected="perc",
               tabPanel(title="Percentages",value="perc",
                        tableOutput('table_p')
               ),
               tabPanel(title="Sample Sizes",value="samps",
                        tableOutput('table_ss')
               )
             )
    ),
    tabPanel("Help & Information", value="main_help", icon=icon('info-sign',lib="glyphicon"),
             htmlOutput('stt_summary'),
             fluidRow(
               column(width=6,align="center",textInput("stt_p1", "Percentage", value = "")),
               column(width=6,align="center",textInput("stt_p2", "Percentage", value = ""))
             ),
             fluidRow(
               column(width=6,align="center",textInput("stt_ss1", "Sample Size", value = "")),
               column(width=6,align="center",textInput("stt_ss2", "Sample Size", value = ""))
             ),
             fluidRow(
               column(width=6,align="center",selectizeInput("stt_y1","Year",choices=years, multiple = F)),
               column(width=6,align="center",selectizeInput("stt_y2","Year",choices=years, multiple = F))
             ),
             fluidRow(
               column(width=12,align="center",div(htmlOutput("stt_results"), style = "text-align: center"))
             )
    )
)

ui <- fluidPage(body, skin="blue")