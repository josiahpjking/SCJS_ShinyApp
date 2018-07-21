home_page <- div(id="home",
  div(id="home-toptext",
      tags$p("The Scottish Crime and Justice Survey (SCJS) is a large-scale social survey which asks people about their experiences and perceptions of crime. The survey is important because it provides a picture of crime in Scotland, including crimes that haven't been reported to/recorded by the police and captured in police recorded crime statistics."),
      tags$h3("National Performance"),
      tags$p("The SCJS captures data on 3 National Indicators, which enable the measurement of progress towards acheiving of a safer, more successful and prosperous Scotland. For more information, visit the",tags$a(target="_blank",tags$ins("National Performance Framework website."),href="http://nationalperformance.gov.scot")),
      div(id="indicators",
          uiOutput("natind1"),
          uiOutput("natind2"),
          uiOutput("natind3")
      ),
      tags$h3("Police Division Tools"),
      tags$p("Using the tools below, you can investigate how responses differ between Police Divisions for a selection of survey areas, including rates of crime victimisation, confidence in/attitudes to the police, and perceptions of local people & crime."),
      div(class="home_allbuttons",
          actionLink("link_divisions",
                     div(class="home-button", 
                         div(class="button-head",
                             tags$h4("Division Breakdowns"),
                             tags$img(src="divisionicons.png")),
                         tags$p("See how police divisions have been performing relative to the National Average")
                     )
          ),
          actionLink("link_compare",
                     div(class="home-button", 
                         div(class="button-head",
                             tags$h4("Comparison Tool"),
                             tags$img(src="comparisonicons.png")),
                         tags$p("Compare responses between divisions and across survey years")
                     )
          ),
          actionLink("link_trends",
                     div(class="home-button",
                         div(class="button-head",
                             tags$h4("Trends"),
                             tags$img(src="trendsicons.png")),
                         tags$p("See responses to the SCJS over time. Trends can be disaggregated by division")
                     )
          ),
          actionLink("link_tables",
                     div(class="home-button", 
                         div(class="button-head",
                             tags$h4("Tables"),
                             tags$img(src="tablesicons.png")),
                         tags$p("Just want numbers? Download tables of percentages and sample sizes for all variables included here")
                     )
          )
      )
  ),
  
  div(id="map",
      selectInput("map_var",label=NULL,choices=all_vars[[1]],selected=all_vars[[1]][1],multiple=F),
      leafletOutput("pdiv_map",height="600px")
  )
  
  
)


