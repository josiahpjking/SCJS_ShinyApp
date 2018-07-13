home_page <- div(id="home",
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
                         tags$p("How have police divisions been performing relative to the National Average?")
                     )
          ),
          actionLink("link_compare",
                     div(class="home-button", 
                         div(class="button-head",
                             tags$img(src="comparison.png"),
                             tags$h4("Comparison Tool")),
                         tags$p("Compare responses between divisions and across survey years.")
                     )
          ),
          actionLink("link_trends",
                     div(class="home-button",
                         div(class="button-head",
                             tags$img(src="trends.png"),
                             tags$h4("Trends")),
                         tags$p("See how responses to the SCJS have changed over time. Trends can be disaggregated by division.")
                     )
          ),
          actionLink("link_tables",
                     div(class="home-button", 
                         div(class="button-head",
                             tags$img(src="tables.png"),
                             tags$h4("Tables")),
                         tags$p("Don't like visual stuff? Just want some numbers? Download tables of percentages and sample sizes for all variables included here.")
                     )
          )
      )
  ),
  
  div(id="map",
      selectInput("map_var",label=NULL,choices=all_vars[[1]],selected=all_vars[[1]][1],multiple=F),
      leafletOutput("pdiv_map",height="600px")
  )
  
  
)


