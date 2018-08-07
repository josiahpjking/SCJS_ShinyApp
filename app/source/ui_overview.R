overview_page <- 
  sidebarLayout(
    #side bar
    sidebarPanel(
      #if looking at the breakdown (single year) display this text (see server_overview.R)
      conditionalPanel(
        condition="input.ovplotting == 'breakdown'",
        htmlOutput('overview_1')
      ),
      #if looking at the trend display this text (see server_overview.R)
      conditionalPanel(
        condition="input.ovplotting == 'trends'",
        htmlOutput('overview_2')
      ),
      
      #user inputs survey section.
      selectizeInput("ov_var",label="Choose a section of the survey",choices=list("National Indicators"=all_vars[[1]],"Survey Sections"=names(all_vars)),multiple=F,selected=NULL),
      #if looking at the breakdown (single year), then user inputs year
      conditionalPanel(
        condition="input.ovplotting == 'breakdown'",
        selectizeInput("ov_year",label="Choose Year",choices=years,selected=years[length(years)],multiple=F)
      ),
      #if looking at the trend (single division over years), then user inputs division
      conditionalPanel(
        condition="input.ovplotting == 'trends'",
        selectizeInput("ov_pdiv",label="Choose Division",choices=pdivis,selected="National Average",multiple=F)
      ),
      uiOutput("variable_info_ov")
    ),
    
    
    #main panel - tabpanel
    mainPanel(
      tabsetPanel(id="ovplotting",selected="breakdown",
                  #view single year all divisions.
                  tabPanel(title="Single Year",value="breakdown",
                           div(class="plot-container",
                               tags$img(src="spinner.gif", id="loading-spinner"),
                               plotlyOutput("ov_currentplot", height = "auto",width='100%')
                           ),
                           div(class="plot-below",tags$p("Click on the results of a division to see how it has performed over time."))
                  ),
                  #view single division all years.
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
