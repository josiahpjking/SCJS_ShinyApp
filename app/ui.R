library(shiny)
library(plotly)
require(tidyr)
require(dplyr)
require(magrittr)


body<-navbarPage(title="",id="main",position="fixed-top", collapsible=TRUE,
                 
                 
    tabPanel("Home",icon = icon('home',lib="glyphicon"),
             div(class="toptext", 
                 tags$p("The Scottish Crime and Justice Survey (SCJS) is a large-scale social survey which asks people about their experiences and perceptions of crime. The survey is important because it provides a picture of crime in Scotland, including crimes that haven't been reported to/recorded by the police and captured in police recorded crime statistics. This ShinyApp gives a breakdown of different elements of the SCJS by Police Divisions. When designing this app, we had in mind two main questions that users might have about responses to the survey:"),
                 div(class="questions",
                     tags$p("Which police divisions in Scotland are over/under-performing, and have specific divisions been consistent over time relative to the National Average?")),
                 div(class="questions",
                     tags$p("How is Scotland as a whole changing over time?")),
                 tags$p("The App features a number of different tools to meet these needs, which are detailed below. For information about the in-built statistical testing in these tools, and links to other SCJS publications, see the Help & Information tab.")
             ),
             
             div(class="home_buttons",
                 actionLink("link_overview",
                            div(class="button-text", 
                                tags$img(src="overview.png"),
                                tags$p("Use the Division Overview tab to see how police divisions have been performing relative to the National Average. Choose between any of the Survey's 3 National Indicators or whole sections of the survey.")
                                )
                 ),
                 actionLink("link_compare",
                            div(class="button-text", 
                                tags$img(src="comparison.png"),
                                tags$p("Use the comparison tool to look at the data in more depth: Pick and choose specific years and/or specific police divisions, and compare the results of the survey.")
                            )
                 ),
                 actionLink("link_trends",
                            div(class="button-text",
                                tags$img(src="trends.png"),
                                tags$p("Use the Trends tab to look at how specific questions in the SCJS have changed over time. These trends can also be disaggregated by division.")
                                )
                 ),
                 actionLink("link_tables",
                            div(class="button-text", 
                                tags$img(src="tables.png"),
                                tags$p("If you don't like all the visual stuff and just want some numbers, then head to the Tables section. You can download tables of proportions and sample sizes for all variables included in this app.")
                            )
                 )
             )
             
    ),
    
    ##########
    #Overview tab.
    ##########
    
    tabPanel("Overview of Police Divisions", value="main_overview",
             sidebarLayout(
               sidebarPanel(
                 selectizeInput("ov_var",label="Choose an area of the survey",choices=list("National Indicators"=all_vars[[1]],"Survey Sections"=names(all_vars)),multiple=F,selected=NULL),
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
                                      tags$p("Click on a division to see how it has performed over time."),
                                      div(class="plot-container",
                                          tags$img(src="spinner.gif", id="loading-spinner"),
                                          plotlyOutput("ov_currentplot", height = "auto",width='100%')
                                      )
                             ),
                             tabPanel(title="Within Division Trends",value="trends",
                                      tags$p("Click on a year to see all divisions."),
                                      div(class="plot-container",
                                          tags$img(src="spinner.gif", id="loading-spinner"),
                                          plotlyOutput("ov_trendplot", height = "100%",width='100%')
                                      )
                             )
                 ),
                 checkboxInput("showleg",label = "Show Legend",value=TRUE)
               )
             )
    ),
    
    ##########
    #COMPARISON TOOL (main_compare)
    ##########
    
    tabPanel("Comparison Tool", value="main_compare", icon = icon('bar-chart'),
             sidebarLayout(
               sidebarPanel(
                 selectizeInput("survey_section_compare", label = "Choose an area of the survey", choices=list("Survey Sections"=names(all_vars)), selected=names(all_vars)[1], multiple=F),
                 div(class="sidebartext",
                     tags$p("Choose a section of the survey (e.g. confidence in the local police) and compare how one specific division compares to another or to the national average, or compare the same division in different survey years."),
                     tags$p("Significant differences between adjacent proportions are colour coded (the better-performing proportion will be green and the worse-performing proportion will be red. Non-significant differences will be grey).")
                 )
               ),
               mainPanel(
                 div(id="compare_inputs",
                 fluidRow(
                   column(width=6,align="center",selectizeInput("parea1",NULL,choices=pdivis, selected="National Average", multiple = F)),
                   column(width=6,align="center",selectizeInput("parea2",NULL,choices=pdivis, selected="National Average", multiple = F))
                 ),
                 fluidRow(
                   column(width=6,align="center",selectizeInput("year1",NULL,choices=years, selected=years[1], multiple = F)),
                   column(width=6,align="center",selectizeInput("year2",NULL,choices=years, selected=years[length(years)], multiple = F))
                 )),
                 
                 fluidRow(
                   column(width=12,align="center",
                          div(class="plot-container",
                              tags$img(src="spinner.gif", id="loading-spinner"),
                              plotlyOutput('compar_plot', height = "100%",width='90%')
                          )
                   )
                 )
                 
               )
             )
    ),
    
    ##########
    #TRENDS OVER TIME (main_trends)
    ##########
    
    tabPanel("Visualise Trends", value="main_trends", icon = icon('line-chart'),
             sidebarLayout(
               
               sidebarPanel(
                 selectizeInput("survey_section", label = "Choose an area of the survey", choices=list("Survey Sections"=names(all_vars)), selected=names(all_vars)[1], multiple=F),
                 uiOutput('var_select'),
                 selectizeInput("parea",label="Choose Police Divisions",choices=pdivis, selected="National Average", multiple = T, options = list(maxItems = length(pdivis))),
                 div(class="sidebartext",
                     tags$p("Here you can visualise the trends over time of various questions of the survey."),
                     tags$p("Choose an area of the survey to focus on, and then explore the variables which the SCJS collects in that area."),
                     tags$p("You can also select individual police divisions to see how trends have varied for different areas."),
                     tags$p("Information regarding confidence intervals and sample sizes is available when hovering the mouse over a line on the plot."),
                     actionLink("link_compare1",
                            "If you wish to find out whether a difference is significant or not, head to the comparison tool.")
                 )
               ),
               
               mainPanel(
                 div(id="trendplottext", tags$p("Hover over the cursor over a point to see more information.")),
                 div(class="plot-container",
                     tags$img(src="spinner.gif", id="loading-spinner"),
                     plotlyOutput("trendplot", height = "100%",width='100%')),
                 checkboxInput("erbar",label = "Show Confidence Intervals",value=FALSE),
                 checkboxInput("showleg1",label = "Show Legend",value=FALSE),
                 actionButton("reset_trends","Reset plot")
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
             div(class="toptext",id="hi1",
                 tags$h5("SCJS Questions"),
                 tags$p("To calculate proportions of, for example, survey respondents expressing confidence in the local police, categories of responses to survey questions have been collapsed across the levels of confidence (e.g. 'Fairly Confident' and 'Very Confident' are both contribute equally to these proportions). For the few exceptional questions (such as perceiving the 'same or less' crime), care has been taken in the labels and information-on-hover to reflect this. More information and the entire questionnaire can be found on ",tags$a(target="_blank",tags$ins("the SCJS publication page."),href="http://www.gov.scot/Topics/Statistics/Browse/Crime-Justice/crime-and-justice-survey/publications"))
             ),
             
             div(class="toptext",id="hi2",
                 tags$h5("Statistical Testing tool"),
                 tags$p("This tool replicates the excel workbook found on",
                        tags$a(target="_blank",tags$ins("the SCJS website."),href="http://www.gov.scot/Topics/Statistics/Browse/Crime-Justice/Datasets/SCJS/SCJS201617StatsTestingTool")),
                 tags$p("SCJS estimates are based on a representative sample of the population of Scotland aged 16 or over living in private households. A sample, as used in the SCJS, is a small-scale representation of the population from which it is drawn. Any sample survey may produce estimates that differ from the values that would have been obtained if the whole population had been interviewed. The magnitude of these differences is related to the size and variability of the estimate, and the design of the survey, including sample size. It is however possible to calculate the range of values between which the population figures are estimated to lie; known as the confidence interval (also referred to as margin of error). At the 95 per cent confidence level, when assessing the results of a single survey it is assumed that there is a one in 20 chance that the true population value will fall outside the 95 per cent confidence interval range calculated for the survey estimate. Similarly, over many repeats of a survey under the same conditions, one would expect that the confidence interval would contain the true population value 95 times out of 100. Because of sampling variation, changes in reported estimates between survey years or between population subgroups may occur by chance. In other words, the change may simply be due to which respondents were randomly selected for interview. Whether this is likely to be the case can be assessed using standard statistical tests. These tests indicate whether differences are likely to be due to chance or represent a real difference. In general, only differences that are statistically significant at the five per cent level (and are therefore likely to be real as opposed to occurring by chance) are reported."),
                 
                 
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
             ),
             div(class="toptext",id="hi3",
                 tags$h5("Rounding"),
                 tags$p("All proportions and confidence intervals presented here are rounded to 1dp. The in-built proportion testing in the app (which colours visual elements red/green/grey accordingly) uses unrounded proportions. Using the stats-testing tool on rounded proportions may yield slightly different results to those displayed in the rest of the app.")
             )
    )
)





fluidPage(
  includeCSS("./www/stuff.css"),
  
  tags$h1(class="head-control",
          a(target="_blank",href="http://www.gov.scot/Topics/Statistics/Browse/Crime-Justice/crime-and-justice-survey","Scottish Crime & Justice Survey"),
          tags$img(src="scotgov.png",width=200,align="right")
  ),
  
  body
)
