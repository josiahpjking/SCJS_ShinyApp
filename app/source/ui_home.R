home_page <- 
  div(id="home",
    # text summary of SCJS.
    tags$p(style="text-align: center; ","The Scottish Crime and Justice Survey (SCJS) is a large-scale social survey which asks people about their experiences and perceptions of crime. The survey is important because it provides a picture of crime in Scotland, including crimes that haven't been reported to/recorded by the police and captured in police recorded crime statistics. This site currently presents SCJS data from 2008/09 to ",currentyear,". The site will be updated in early 2019 with new police division data for 2016/17 and 2017/18. More information and the entire questionnaire can be found on ",tags$a(target="_blank",tags$ins("the SCJS publication page."),href="http://www.gov.scot/Topics/Statistics/Browse/Crime-Justice/crime-and-justice-survey/publications")),
    
    div(id="home-toptext",
        
        # National indicators info.
        tags$h3("National Performance "),
        tags$p("The SCJS captures data on 3 National Indicators, which support the measurement of progress towards acheiving of a safer, more successful and prosperous Scotland. The graphics below present the progress of these indicators following the ",currentyear," SCJS data, reflecting whether they have changed from or stayed the same as the previous survey year (",prevyear,"). Data for 2016/17 and 2017/18 will be added in early 2019 alongside new police division data. For more information, visit the",tags$a(target="_blank",tags$ins("National Performance Framework website."),href="http://nationalperformance.gov.scot")),
        # National indicator graphics (see server_home.R)
        div(id="indicators",
            uiOutput("natind1"),
            uiOutput("natind3"),
            uiOutput("natind2")
        ),
        #Button links to other tabs. (see server_home.R)
        tags$h3("Explore the SCJS data"),
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
                           tags$p("Compare results between divisions and across survey years according to the SCJS method for testing statistical significance.")
                       )
            )
        ),
        div(class="home_allbuttons",
            actionLink("link_trends",
                       div(class="home-button",
                           div(class="button-head",
                               tags$h4("Trends"),
                               tags$img(src="trendsicons.png")),
                           tags$p("See results of the SCJS over time.")
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
        ),
        tags$p("Using the tools above, you can view results for various sections of the SCJS, including rates of crime victimisation, confidence in/attitudes to the police, and perceptions of crime. Different visualisations highlight different aspects of the data, from viewing trends over time to breakdowns of police divisions relative to the national average."),
        tags$p("Although these visualisations are helpful for highlighting how experiences and attitudes differ across Scotland, they do not necessarily explain the reasons for such differences or indicate that one area is better than another."),
        tags$p("Additionally, it is important to consider the absolute results as well as any relative differences or changes. For example, the vast majority of people may hold a positive view, even if this has fallen a little over time or is lower in one area than another. This is an important point to note when interpreting and summarising findings.")
    ),
#leaflet map - see server_map.R
    div(id="map",
        selectInput("map_var",label=NULL,choices=all_vars[[1]],selected=all_vars[[1]][1],multiple=F),
        leafletOutput("pdiv_map",height="600px")
    )
)

