sidebarLayout(
  sidebarPanel(
    div(class="sidebartext",
        tags$p("Choose a section of the survey (e.g. confidence in the local police) and compare between specific divisions and/or across survey years."),
        tags$p("The selections you make will be compared", tags$b("against one another."),"For each question, if there is a significant difference between the two selections, the more positive result will be coloured", tags$b(style="color:red","red"), "and the less positive result will be coloured",tags$b(style="color:LimeGreen","green."), "If there is no significant difference between your two selections, the bars will be coloured",tags$b(style="color:grey","grey.")
        )
    ),
    selectizeInput("comp_var", label = "Choose a section of the survey", choices=list("Survey Sections"=names(all_vars)), selected=names(all_vars)[1], multiple=F),
    uiOutput("variable_info_comp")
  ),
  mainPanel(
    div(id="compare-top",
        div(class="compare-inputs",
            div(class="compare-row",selectizeInput("comp_pdiv1",NULL,choices=pdivis, selected="National Average", multiple = F)),
            div(class="compare-row",selectizeInput("comp_year1",NULL,choices=years, selected=years[1], multiple = F))
        ),
        div(class="compare-inputs-text",
            div(class="compare-row",tags$h5("Compared to"))
        ),
        div(class="compare-inputs",
            div(class="compare-row",selectizeInput("comp_pdiv2",NULL,choices=pdivis, selected="National Average", multiple = F)),
            div(class="compare-row",selectizeInput("comp_year2",NULL,choices=years, selected=years[length(years)], multiple = F))
        )
    ),
    div(id="compare-outputs",
        tags$p("Percentages on the either side of the figure below are compared", tags$b("against one another.")),
        tags$p("If significantly different, the more positive result is shown in", tags$b(style="color:LimeGreen","green"), "and the less positive result in",tags$b(style="color:red","red.")),
        div(class="plot-container",
            tags$img(src="spinner.gif", id="loading-spinner"),
            plotlyOutput('compar_plot')
        )
    )
  )
)
