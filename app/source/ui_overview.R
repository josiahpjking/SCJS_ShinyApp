overview_page <- 
  sidebarLayout(
    #side bar
    sidebarPanel(
      #user inputs survey section.
      selectizeInput("ov_var",label="Choose an area of the survey or an individual variable",choices=c(list("Survey Sections"=names(all_vars[-1])),all_vars[-1]),multiple=F,selected=NULL),
      #if looking at the breakdown (single year), then user inputs year
      conditionalPanel(
        condition="input.ovplotting == 'breakdown'",
        selectizeInput("ov_year",label="Choose Year",choices=years,selected=years[length(years)],multiple=F),
        tags$p(style="text-align:left; font-size: 10px","*From 2016, responses from two survey years are combined to provide more robust estimates at a Police Division level.")
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
                           )
                  ),
                  #view single division all years.
                  tabPanel(title="Divisions Over Time",value="trends",
                           #uiOutput("ov_var2"),
                           #selectInput("ov_var2",label = "Choose variable:",choices=all_vars[-1]),
                           div(class="plot-container",
                               tags$img(src="spinner.gif", id="loading-spinner"),
                               plotlyOutput("ov_trendplot", height = "100%",width='100%')
                           )
                  )
      ),
      div(class="vis_info",
          tags$body(includeScript("./www/moreclick3.js")),
          HTML('<h5>Visualisation Info</h5>
               <span class="more3">See how divisions compare to the National Average for a chosen year or over time. Division level results are color coded according to whether they are significantly different to the National Average: <b style="color:#6baed6">More Positive (light blue)</b> or <b style="color:#08519c">Less Positive (dark blue)</b> and <b style="color:grey">No significant difference (Grey)</b><br>Hover the mouse over the graph to display more information (percentages, sample sizes, confidence intervals) about each data point.</span>')
          )
    )
)
