div(id="home",
  div(id="home-toptext",
      tags$p("The Scottish Crime and Justice Survey (SCJS) is a large-scale social survey which asks people about their experiences and perceptions of crime. The survey is important because it provides a picture of crime in Scotland, including crimes that haven't been reported to/recorded by the police and captured in police recorded crime statistics."),
      tags$h3("The National Picture"),
      div(id="indicators",
          uiOutput("natind1"),
          uiOutput("natind2"),
          uiOutput("natind3")
      ),
      
      
      tags$h3("Police Division Tools"),

      div(class="home_allbuttons",
          actionLink("link_divisions",
                     div(class="home-button", 
                         div(class="button-head",
                             tags$img(src="overview.png"),
                             tags$h4("Division Breakdowns")),
                         tags$p("See how police divisions have been performing relative to the National Average. Choose between any of the Survey's 3 National Indicators or whole sections of the survey.")
                     )
          ),
          actionLink("link_compare",
                     div(class="home-button", 
                         div(class="button-head",
                             tags$img(src="comparison.png"),
                             tags$h4("Comparison Tool")),
                         tags$p("Look at the data in more depth: Pick and choose specific years and/or specific police divisions, and compare the results of the survey.")
                     )
          ),
          actionLink("link_trends",
                     div(class="home-button",
                         div(class="button-head",
                             tags$img(src="trends.png"),
                             tags$h4("Trends Over Time")),
                         tags$p("See how specific questions in the SCJS have changed over time. These trends can also be disaggregated by division.")
                     )
          ),
          actionLink("link_tables",
                     div(class="home-button", 
                         div(class="button-head",
                             tags$img(src="tables.png"),
                             tags$h4("Tables")),
                         tags$p("Don't like all the visual stuff and just want some numbers? You can download tables of percentages and sample sizes for all variables included in this app.")
                     )
          )
      )
  ),
  
  div(id="map",
      selectInput("map_var",label=NULL,choices=all_vars[[1]],selected=all_vars[[1]][1],multiple=F),
      leafletOutput("pdiv_map",height="600px")
  )
  
  
)


