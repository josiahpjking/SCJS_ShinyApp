tab_home<-tabPanel("Home",icon = icon('home',lib="glyphicon"),
           tags$h4("Scottish Crime and Justice Survey (SCJS)"),
           tags$p("The SCJS is a large-scale social survey which asks people about their experiences and perceptions of crime. The survey is important because it provides a picture of crime in Scotland, including crimes that haven't been reported to/recorded by the police and captured in police recorded crime statistics."),
           tags$h4("What can you do here?"),
           tags$p("This ShinyApp gives a breakdown of different elements of the SCJS by Police Divisions. The App features a number of different tools to display the data in ways which meet a variety of needs"),
           
           div(class="home_buttons",
             actionLink("link_overview",img(src="overview.png")),
             tags$p("use this to blah blah"),
             actionLink("link_trends",img(src="trends.png")),
             actionLink("link_compare",img(src="comparison.png")),
             actionLink("link_tables",img(src="tables.png"))
             )
         
)