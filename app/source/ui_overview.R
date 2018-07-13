overview_page <- 
  sidebarLayout(
  sidebarPanel(
    conditionalPanel(
      condition="input.ovplotting == 'breakdown'",
      htmlOutput('overview_1')
    ),
    conditionalPanel(
      condition="input.ovplotting == 'trends'",
      htmlOutput('overview_2')
    ),
    selectizeInput("ov_var",label="Choose a section of the survey",choices=list("National Indicators"=all_vars[[1]],"Survey Sections"=names(all_vars)),multiple=F,selected=NULL),
    conditionalPanel(
      condition="input.ovplotting == 'breakdown'",
      selectizeInput("ov_year",label="Choose Year",choices=years,selected=years[length(years)],multiple=F)
    ),
    conditionalPanel(
      condition="input.ovplotting == 'trends'",
      selectizeInput("ov_pdiv",label="Choose Division",choices=pdivis,selected=pdivis[12],multiple=F)
    ),
    uiOutput("variable_info_ov")
  ),
  
  mainPanel(
    tabsetPanel(id="ovplotting",selected="breakdown",
                tabPanel(title="Single Year",value="breakdown",
                         div(class="plot-container",
                             tags$img(src="spinner.gif", id="loading-spinner"),
                             plotlyOutput("ov_currentplot", height = "auto",width='100%')
                         ),
                         div(class="plot-below",tags$p("Click on the results of a division to see how it has performed over time."))
                ),
                tabPanel(title="Divisions Over Time",value="trends",
                         uiOutput("ov_var2"),
                         div(class="plot-container",
                             tags$img(src="spinner.gif", id="loading-spinner"),
                             plotlyOutput("ov_trendplot", height = "100%",width='100%')
                         ),
                         div(class="plot-below",tags$p("Click on the results of a year to see all divisions for that year."))
                ),
                div(class="plot-below",checkboxInput("showleg",label = "Show Legend",value=FALSE))       
    )
  )
)
