div(id="helpinfo",
    div(class="helptext",id="hi1",
        tags$h5("SCJS Questions"),
        tags$p("To calculate percentages of, for example, survey respondents expressing confidence in the local police, categories of responses to survey questions have been combined (e.g. Confidence includes those responding 'Fairly Confident' and 'Very Confident'). For the few exceptional questions (such as perceiving the 'same or less' crime), care has been taken in the labels and information-on-hover to reflect this. More information and the entire questionnaire can be found on ",tags$a(target="_blank",tags$ins("the SCJS publication page."),href="http://www.gov.scot/Topics/Statistics/Browse/Crime-Justice/crime-and-justice-survey/publications"))
    ),
    
    div(class="helptext",id="hi2",
        tags$h5("Statistical Testing tool"),
        tags$p("This tool replicates the excel workbook found on",
               tags$a(target="_blank",tags$ins("the SCJS website."),href="http://www.gov.scot/Topics/Statistics/Browse/Crime-Justice/Datasets/SCJS/SCJS201617StatsTestingTool")),
        tags$p("SCJS estimates are based on a representative sample of the population of Scotland aged 16 or over living in private households. A sample, as used in the SCJS, is a small-scale representation of the population from which it is drawn. Any sample survey may produce estimates that differ from the values that would have been obtained if the whole population had been interviewed. The magnitude of these differences is related to the size and variability of the estimate, and the design of the survey, including sample size. It is however possible to calculate the range of values between which the population figures are estimated to lie; known as the confidence interval (also referred to as margin of error). At the 95 per cent confidence level, when assessing the results of a single survey it is assumed that there is a one in 20 chance that the true population value will fall outside the 95 per cent confidence interval range calculated for the survey estimate. Similarly, over many repeats of a survey under the same conditions, one would expect that the confidence interval would contain the true population value 95 times out of 100. Because of sampling variation, changes in reported estimates between survey years or between population subgroups may occur by chance. In other words, the change may simply be due to which respondents were randomly selected for interview. Whether this is likely to be the case can be assessed using standard statistical tests. These tests indicate whether differences are likely to be due to chance or represent a real difference. In general, only differences that are statistically significant at the five per cent level (and are therefore likely to be real as opposed to occurring by chance) are reported."),
        
        
        fluidRow(
          column(width=6,align="center",textInput("stt_p1", "Percentage", value = "")),
          column(width=6,align="center",textInput("stt_p2", "Percentage", value = ""))
        ),
        fluidRow(
          column(width=6,align="center",textInput("stt_ss1", "Sample Size", value = "")),
          column(width=6,align="center",textInput("stt_ss2", "Sample Size", value = ""))
        ),
        fluidRow(
          column(width=6,align="center",selectizeInput("stt_y1","Year",choices=years, multiple = F)),
          column(width=6,align="center",selectizeInput("stt_y2","Year",choices=years, multiple = F))
        ),
        fluidRow(
          column(width=12,align="center",div(htmlOutput("stt_results"), style = "text-align: center"))
        )
    ),
    div(class="helptext",id="hi3",
        tags$h5("Rounding"),
        tags$p("All proportions/percentages and confidence intervals presented here are rounded to 1dp. The in-built proportion testing in the app (which colours visual elements red/green/grey accordingly) uses unrounded proportions. Using the stats-testing tool on rounded proportions may yield slightly different results to those displayed in the rest of the app.")
    )
)