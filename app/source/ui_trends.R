sidebarLayout(
  sidebarPanel(
    selectizeInput("survey_section", label = "Choose a section of the survey", choices=list("Survey Sections"=names(all_vars)), selected=names(all_vars)[1], multiple=F),
    uiOutput('var_select'),
    selectizeInput("parea",label="Choose Police Divisions",choices=pdivis, selected="National Average", multiple = T, options = list(maxItems = length(pdivis))),
    div(class="sidebartext",
        tags$p("Here you can visualise the trends over time of various questions of the survey."),
        tags$p("Choose a section of the survey to focus on, and then explore the variables which the SCJS collects in that area."),
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