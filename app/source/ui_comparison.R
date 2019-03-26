comparison_page <- sidebarLayout(
  # side bar - user input survey section. render info on selection. 
  sidebarPanel(
    div(class="sidebartext",
        tags$p("Test for significant differences (color coding) between specific divisions and/or across survey years.")
    ),
    selectizeInput("comp_var", label = "Choose a section of the survey", choices=list("Survey Sections"=names(all_vars[-1])), selected=names(all_vars)[2], multiple=F),
    uiOutput("variable_info_comp")
  ),
  
  # main panel. inputs at the top = division, year, division, year. plot below.
  mainPanel(
    div(id="compare-top",
        div(class="comp-in",selectizeInput("comp_pdiv1",NULL,choices=pdivis, selected="National Average", multiple = F),
        selectizeInput("comp_year1",NULL,choices=years, selected=years[1], multiple = F)),
        div(class="comp-in-text",tags$h5("Compared to")),
        div(class="comp-in",selectizeInput("comp_pdiv2",NULL,choices=pdivis, selected="National Average", multiple = F),
        selectizeInput("comp_year2",NULL,choices=years, selected=years[length(years)], multiple = F)),
        tags$p(style="text-align:center; font-size: 10px","*From 2016 responses from two survey years are combined to provide more robust estimates at a Police Division level."),
        HTML("<p style='font-size: 11px'>Percentages on the either side of the figure below are compared <b>against one another.</b>
             <br>If significantly different, the more positive result is shown in <b style='color:#6baed6'>light blue</b> and the less positive result in <b style='color:#08519c'>dark blue.</b> If there is no significant difference between variables in each selection, the bars will be coloured <b style='color:grey'>grey.</b></p>")
    ),
    
    #plot
    div(id="compare-outputs",
        div(class="plot-container",
            tags$img(src="spinner.gif", id="loading-spinner"),
            plotlyOutput('compar_plot')
        )
    )
  )
)
