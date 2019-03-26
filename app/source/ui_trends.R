trends_page <- 
  sidebarLayout(
    
    # sidebar = user inputs, link to comparison tab, 
    sidebarPanel(
      div(class="sidebartext",
          tags$p("Visualise trends over time for various questions in the SJCS.")
      ),
      selectizeInput("trends_pdiv",label="Choose Police Divisions",choices=pdivis, selected="National Average", multiple = T, options = list(maxItems = length(pdivis))),
      
      selectizeInput("trends_var", label = "Choose a section of the survey", choices=list("Survey Sections"=names(all_vars[-1])), selected=names(all_vars)[2], multiple=F),
      
      uiOutput('trends_var2'),
      
      div(class="variable_info",
          tags$body(includeScript("./www/moreclick4.js")),
          HTML('<h5>Visualisation Info</h5>
               <span class="more4">Choose a section of the survey to focus on, and then explore the variables which the SCJS collects. You can also pick and choose which police divisions to show.<br>Information regarding confidence intervals and sample sizes is available when hovering the mouse over the plot.<br><br>While confidence intervals go some way to indicating significant differences in results, if you wish to find out whether two percentages are significantly different or not, head to the comparison tool.</span>')
          )
    ),
  
    
    #main panel - plot
    mainPanel(
      div(class="plot-container",
            tags$img(src="spinner.gif", id="loading-spinner"),
            plotlyOutput("trendplot", height = "100%",width='100%')),
      div(class="plot-below",
          tags$p(style="text-align:left; font-size: 12px","*From 2016, responses from two survey years are combined to provide more robust estimates at a Police Division level."),
          tags$p("Hover over the cursor over a point to see more information."),
          checkboxInput("trendzoom",label="Y-axis Zoom",value=FALSE),
          checkboxInput("showleg1",label = "Show Legend",value=TRUE),
          checkboxInput("erbar",label = "Show 95% Confidence Intervals",value=TRUE),
          actionButton("reset_trends","Reset plot")
      )
    )
)