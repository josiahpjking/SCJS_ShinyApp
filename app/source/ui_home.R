div(id="home",
  div(class="toptext", 
      tags$p("The Scottish Crime and Justice Survey (SCJS) is a large-scale social survey which asks people about their experiences and perceptions of crime. The survey is important because it provides a picture of crime in Scotland, including crimes that haven't been reported to/recorded by the police and captured in police recorded crime statistics. This ShinyApp gives a breakdown of different elements of the SCJS by Police Divisions. When designing this app, we had in mind two main questions that users might have about responses to the survey:"),
      div(class="questions",
          tags$p("Which police divisions in Scotland are performing above and below the National Average, and have divisions been consistent in this respect over time?")),
      div(class="questions",
          tags$p("How is Scotland as a whole changing over time?")),
      
      tags$p("The App features a number of different tools to meet these needs, which are detailed below. For information about the in-built statistical testing in these tools, and links to other SCJS publications, see the Help & Information tab.")
  ),
  
  div(class="home_buttons",
      actionLink("link_overview",
                 div(class="button-text", 
                     tags$img(src="overview.png"),
                     tags$p("Use the Division Overview tab to see how police divisions have been performing relative to the National Average. Choose between any of the Survey's 3 National Indicators or whole sections of the survey.")
                 )
      ),
      actionLink("link_compare",
                 div(class="button-text", 
                     tags$img(src="comparison.png"),
                     tags$p("Use the comparison tool to look at the data in more depth: Pick and choose specific years and/or specific police divisions, and compare the results of the survey.")
                 )
      ),
      actionLink("link_trends",
                 div(class="button-text",
                     tags$img(src="trends.png"),
                     tags$p("Use the Trends tab to look at how specific questions in the SCJS have changed over time. These trends can also be disaggregated by division.")
                 )
      ),
      actionLink("link_tables",
                 div(class="button-text", 
                     tags$img(src="tables.png"),
                     tags$p("If you don't like all the visual stuff and just want some numbers, then head to the Tables section. You can download tables of percentages and sample sizes for all variables included in this app.")
                 )
      )
  )
)


