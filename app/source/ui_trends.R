trends_page <- 
  sidebarLayout(
  sidebarPanel(
    ############### INPUTS/SIDE PANEL
    div(class="sidebartext",
        
        tags$p("Here you can visualise trends over time of various questions of the survey."),
        tags$p("Choose a section of the survey to focus on, and then explore the variables which the SCJS collects in that area. You can also pick and choose which police divisions to show."),
        tags$p("Information regarding confidence intervals and sample sizes is available when hovering the mouse over the plot."),
        
        actionLink("link_compare1",
                   tags$p(style="color:DarkBlue","While confidence intervals go some way to indicating significant differences in results, if you wish to find out whether two percentages are significantly different or not, head to the comparison tool."))
    ),
    
    selectizeInput("trends_pdiv",label="Choose Police Divisions",choices=pdivis, selected="National Average", multiple = T, options = list(maxItems = length(pdivis))),
    
    selectizeInput("trends_var", label = "Choose a section of the survey", choices=list("Survey Sections"=names(all_vars)), selected=names(all_vars)[1], multiple=F),
    
    uiOutput('trends_var2')
  ),
  ############### OUTPUTS/PLOT PANEL
  mainPanel(
    div(class="plot-container",
        tags$img(src="spinner.gif", id="loading-spinner"),
        plotlyOutput("trendplot", height = "100%",width='100%')),
    div(class="plot-below",
        tags$p("Hover over the cursor over a point to see more information."),
        checkboxInput("erbar",label = "Show 95% Confidence Intervals",value=TRUE),
        checkboxInput("showleg1",label = "Show Legend",value=TRUE),
        actionButton("reset_trends","Reset plot")
    )
  )
)