sidebarLayout(
  sidebarPanel(
    conditionalPanel(
      condition="input.plottingov == 'breakdown'",
      htmlOutput('overview_1')
    ),
    conditionalPanel(
      condition="input.plottingov == 'trends'",
      htmlOutput('overview_2')
    ),
    selectizeInput("ov_var",label="Choose a section of the survey",choices=list("National Indicators"=all_vars[[1]],"Survey Sections"=names(all_vars)),multiple=F,selected=NULL),
    conditionalPanel(
      condition="input.plottingov == 'breakdown'",
      selectizeInput("ov_year",label="Choose Year",choices=years,selected=years[length(years)],multiple=F)
    ),
    conditionalPanel(
      condition="input.plottingov == 'trends'",
      selectizeInput("ov_pdiv",label="Choose Division",choices=pdivis,selected=pdivis[1],multiple=F)
    ),
    uiOutput("variable_info")
  ),
  
  mainPanel(
    tabsetPanel(id="plottingov",selected="breakdown",
                tabPanel(title="1 Year Breakdown",value="breakdown",
                         div(class="plot-container",
                             tags$img(src="spinner.gif", id="loading-spinner"),
                             plotlyOutput("ov_currentplot", height = "auto",width='100%')
                         ),
                         tags$p("Click on the results of a division to see how it has performed over time.")
                ),
                tabPanel(title="Within Division Trends",value="trends",
                         div(class="plot-container",
                             tags$img(src="spinner.gif", id="loading-spinner"),
                             plotlyOutput("ov_trendplot", height = "100%",width='100%')
                         ),
                         tags$p("Click on the results of a year to see all divisions for that year."),
                         checkboxInput("showleg",label = "Show Legend",value=TRUE),
                         uiOutput("var_select2")
                )
    )
  )
)
