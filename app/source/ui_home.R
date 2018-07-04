div(id="home",
  div(id="home-toptext",
          tags$p("The Scottish Crime and Justice Survey (SCJS) is a large-scale social survey which asks people about their experiences and perceptions of crime. The survey is important because it provides a picture of crime in Scotland, including crimes that haven't been reported to/recorded by the police and captured in police recorded crime statistics."),
      tags$p("Here you can find various sections of the survey, with the option to break these down by Police Divisions. Along with the three National Indicators measured by the survey, you can explore rate of crime victimisation, confidence in - and attitudes towards - the police, confidence in the criminal justice system, worries of crime victimisation, and perceptions of crime rates, local crime, and local people"),
      tags$p("For the areas of the SCJS included here, you can investigate"),
          div(id="questions",
              tags$p("Which police divisions in Scotland are performing above and below the National Average, and have divisions been consistent in this respect over time?"),
              tags$p("How is Scotland as a whole changing over time?")
          ),
          tags$p("There are a number of different tools designed to meet these needs, which are detailed below. For information about the in-built statistical testing in these tools, and links to other SCJS publications, see the Help & Information tab.")
      ),
  div(id="map",
      selectInput("map_var",label=NULL,choices=all_vars[[1]],selected=all_vars[[1]][1],multiple=F),
      leafletOutput("pdiv_map")
  ),
  
  div(class="home_allbuttons",
      actionLink("link_divisions",
                 div(class="home-button", 
                     div(class="button-head",
                     tags$img(src="overview.png"),
                     tags$h1("Division Breakdowns")),
                     tags$p("Use the Division breakdown tab to see how police divisions have been performing relative to the National Average. Choose between any of the Survey's 3 National Indicators or whole sections of the survey.")
                 )
      ),
      actionLink("link_compare",
                 div(class="home-button", 
                     div(class="button-head",
                         tags$img(src="comparison.png"),
                         tags$h1("Comparison Tool")),
                     tags$p("Use the comparison tool to look at the data in more depth: Pick and choose specific years and/or specific police divisions, and compare the results of the survey.")
                 )
      ),
      actionLink("link_trends",
                 div(class="home-button",
                     div(class="button-head",
                         tags$img(src="trends.png"),
                         tags$h1("Trends Over Time")),
                     tags$p("Use the Trends tab to look at how specific questions in the SCJS have changed over time. These trends can also be disaggregated by division.")
                 )
      ),
      actionLink("link_tables",
                 div(class="home-button", 
                     div(class="button-head",
                         tags$img(src="tables.png"),
                         tags$h1("Tables")),
                     tags$p("If you don't like all the visual stuff and just want some numbers, then head to the Tables section. You can download tables of percentages and sample sizes for all variables included in this app.")
                 )
      )
  )
)


