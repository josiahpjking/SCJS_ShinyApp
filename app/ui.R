library(shiny)
library(plotly)
require(tidyr)
require(dplyr)
require(magrittr)


body<-navbarPage(title="",id="main",position="fixed-top",
    tabPanel("Home",icon = icon('home',lib="glyphicon"),
             div(class="toptext", 
                 tags$p("The Scottish Crime and Justice Survey (SCJS) is a large-scale social survey which asks people about their experiences and perceptions of crime. The survey is important because it provides a picture of crime in Scotland, including crimes that haven't been reported to/recorded by the police and captured in police recorded crime statistics."),
                 tags$p("This ShinyApp gives a breakdown of different elements of the SCJS by Police Divisions. The App features a number of different tools to display the data in ways which meet a variety of needs.")
                 ),
             
             div(class="home_buttons",
                 
                 div(class="button-text",
                 actionLink("link_overview",tags$img(class="w3-hover-opacity", src="overview.png")),
                 tags$p("Use the Overview tab to see how police divisions have been performing relative to the National Average. Choose between any of the Survey's 3 National Indicators or whole sections of the survey.")
                 ),
                 div(class="button-text",
                     actionLink("link_trends",tags$img(class="w3-hover-opacity", src="trends.png")),
                     tags$p("Use the Visualise Trends tab to look at how specific questions in the SCJS have changed over time. These trends can also be disaggregated by division.")
                 ),
                 div(class="button-text",
                     actionLink("link_compare",tags$img(class="w3-hover-opacity", src="comparison.png")),
                     tags$p("If you're interested in comparing different divisions to one another (or to the National Average), or comparing one division's performance in specific years, then use this comparison tool.")
                 ),
                 div(class="button-text",
                     actionLink("link_tables",tags$img(class="w3-hover-opacity", src="tables.png")),
                     tags$p("If you don't like all the visual stuff and just want some numbers, then head to the Tables section. You can download tables of proportions and sample sizes for all variables included in this app.")
                 )
             )
             
    ),
    
    tabPanel("Scotland Overview", value="main_overview",
             sidebarLayout(
               sidebarPanel(
                 selectizeInput("ov_var",label="Choose an area of the survey",choices=c(all_vars[[1]],names(all_vars)),multiple=F,selected=NULL),
                 conditionalPanel(
                   condition="input.plottingov == 'breakdown'",
                   selectizeInput("ov_year",label="Choose Year",choices=years,selected=years[length(years)],multiple=F),
                   htmlOutput('overview_1')
                 ),
                 conditionalPanel(
                   condition="input.plottingov == 'trends'",
                   selectizeInput("ov_pdiv",label="Choose Division",choices=pdivis,selected=pdivis[1],multiple=F),
                   htmlOutput('overview_2')
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
                 ),
                 checkboxInput("showleg",label = "Show Legend",value=FALSE)
               )
             )
    ),
    
    ##########
    #TRENDS OVER TIME (main_trends)
    ##########
    tabPanel("Visualise Trends", value="main_trends", icon = icon('line-chart'),
             sidebarLayout(
               sidebarPanel(
                 selectizeInput("survey_section", label = "Choose an area of the survey", choices=names(all_vars), selected=names(all_vars)[1], multiple=F),
                 uiOutput('var_select'),
                 selectizeInput("parea",label="Choose Police Divisions",choices=pdivis, selected="National Average", multiple = T, options = list(maxItems = length(pdivis))),
                 htmlOutput('trend_summary')
               ),
               mainPanel(
                 plotlyOutput("trendplot", height = "100%",width='100%'),
                 checkboxInput("erbar",label = "Show Confidence Intervals",value=FALSE),
                 checkboxInput("showleg",label = "Show Legend",value=FALSE)
               )
             )
    ),
    
    ##########
    #COMPARISON TOOL (main_compare)
    ##########
    
    tabPanel("Comparison Tool", value="main_compare", icon = icon('bar-chart'),
             sidebarLayout(
               sidebarPanel(
                 selectizeInput("survey_section_compare", label = "Choose an area of the survey", choices=names(all_vars), selected=names(all_vars)[1], multiple=F),
                 div(class="sidebartext",
                     tags$p("Choose a section of the survey (e.g. confidence in the local police) and compare how one specific division compares to another or to the national average, or compare the same division in different survey years."),
                     tags$p("Significant differences between adjacent proportions are colour coded (the better-performing proportion will be green and the worse-performing proportion will be red. Non-significant differences will be grey)."),
                     tags$p("Hover the mouse over a bar to see the specific question/variable")
                 )
               ),
               mainPanel(
                 fluidRow(
                   column(width=6,align="center",selectizeInput("parea1",NULL,choices=pdivis, selected="National Average", multiple = F)),
                   column(width=6,align="center",selectizeInput("parea2",NULL,choices=pdivis, selected="National Average", multiple = F))
                 ),
                 fluidRow(
                   column(width=6,align="center",selectizeInput("year1",NULL,choices=years, selected=years[1], multiple = F)),
                   column(width=6,align="center",selectizeInput("year2",NULL,choices=years, selected=years[length(years)], multiple = F))
                 ),
                 
                 fluidRow(
                   column(width=12,align="center",plotlyOutput('compar_plot', height = "100%",width='90%'))
                 )
                 
               )
             )
    ),
    
    ##########
    #TABLES (main_tables)
    ##########
    
    tabPanel("Tables", value="main_tables", icon = icon('download-alt', lib='glyphicon'),
             fluidRow(
               div(class="tvar",
              column(width=5,
                     selectizeInput("table_var",label="Choose Variables",choices = c("Select All", all_vars), selected=c(all_vars[[1]][1]), multiple=T, options=list(maxItems=length(unlist(all_vars))))),
               column(width=5,
                      selectizeInput("table_pdiv",label="Choose Police Divisions",choices=c("Select All", pdivis), selected="National Average", options = list(maxItems = length(pdivis))),
                      div(class="tableopts",
                          downloadButton("downloadData", "Download")),
                      div(class="tableopts",
                          actionButton("reset_tables", "Reset")
                      ))
             )),
             tabsetPanel(selected="perc",
               tabPanel(title="Percentages",value="perc",
                        tableOutput('table_p')
               ),
               tabPanel(title="Sample Sizes",value="samps",
                        tableOutput('table_ss')
               )
             )
    ),
    
    
    ##########
    #HELP & INFO (main_help)
    ##########
    
    
    tabPanel("Help & Information", value="main_help", icon=icon('info-sign',lib="glyphicon"),
             div(class="toptext",htmlOutput('stt_summary')),
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





fluidPage(
  includeCSS("./www/stuff.css"),
  
  tags$h1(class="head-control",
          a(href="http://www.gov.scot/Topics/Statistics/Browse/Crime-Justice/crime-and-justice-survey","Scottish Crime & Justice Survey"),
          tags$img(src="scotgov.png",width=200,align="right")
  ),

    
  body
)
