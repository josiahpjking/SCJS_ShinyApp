variable_info_list <- list(

######################################################################################

  "Victim of any crime within the scope of the survey" = 
  div(id=NULL,
      tags$h5("Crime Victimisation"),
      tags$p("The percentage of respondents to the SCJS who report victimisation of any crime which is within the scope of the survey offers a picture of crime in Scotland which includes crimes that haven't been reported to/recorded by the police and captured in police recorded crime statistics."),
      tags$a(target="_blank",tags$ins("Click here for more information on the National Performance Framework."),href="http://nationalperformance.gov.scot")
  ),
######################################################################################

  "Perceived same or less crime in local area in last two years" = 
  div(id=NULL,
      tags$h5("Perceptions of Local Crime Rates"),
      tags$p("The SCJS asks respondents how much they would say the crime rate in their local area has changed since two years ago."),
      tags$p("The percentage of responses indicating a perception of",tags$b("the same or less"),"crime since two years ago is taken as an indicator of progress towards a safer Scotland."),
      tags$a(target="_blank",tags$ins("Click here for more information on the National Performance Framework."),href="http://nationalperformance.gov.scot")
  ),
######################################################################################

  "Confident that Scottish Criminal Justice System makes sure everyone has access to the justice system if they need it" =
  div(id=NULL,
      tags$h5("Access to Justice"),
      tags$p("The SCJS measures the public's confidence in various operational aspects of the criminal justice system. One of these specifically is a key indicator, which measures confidence in the provision of access to the justice system for everyone should they require it."),
      tags$a(target="_blank",tags$ins("Click here for more information on the National Performance Framework."),href="http://nationalperformance.gov.scot")
  ),
######################################################################################  
  
  "National Indicators" = 
  div(id=NULL,
      tags$h5("National Indicators"),
      tags$p("The SCJS captures data on 3 National Indicators. National Indicators enable the measurement of progress towards acheiving of a more successful and prosperous Scotland. The three indicators measured in the SCJS are:",
             tags$li(tags$u("Rate of any crime victimisation")),
             tags$li("Perceived local crime rate to be the same or less than 2 years ago"),
             tags$li("Confident in access to the Criminal Justic System for all")
      ),
      tags$p("For underlined variables, lower percentages are better."),
      tags$a(target="_blank",tags$ins("Click here for more information on the National Performance Framework."),href="http://nationalperformance.gov.scot")
  ),
######################################################################################
  
  "Rates of Crime Victimisation" = 
  div(id=NULL,
      tags$h5("Rates of Crime Victimisation"),
      tags$p("The SCJS measures the rates of victimisation of many different crime types. The three main types are included here:",
             tags$li("Victims of any crime"),
             tags$li("Victims of violent crime"),
             tags$li("Victims of property crime")
      ),
      tags$p("For these variables, lower percentages are better as they represent less crime victimisation.")
  ),
######################################################################################
  
  "Confidence in the Police" = 
  div(id=NULL,
      tags$h5("Confidence in the Police"),
      tags$p("The SCJS measures the public's confidence in the ability of the local police to undertake six particular components of work. Results represent the percentage of respondents who are (fairly or very) confident in the local police to:",
             tags$li("Prevent crime"),
             tags$li("Respond quickly and appropriately"),
             tags$li("Deal with incidents as they occur"),
             tags$li("Investigate incidents after they occur"),
             tags$li("Solve crimes"),
             tags$li("Catch criminals")
      ),
      tags$p("All these variables measure the public confidence in the local police; higher percentages are better, indicating more confidence.")
  ),
######################################################################################
  
  "Attitudes to the Police" = 
  div(id=NULL,
      tags$h5("Attitudes to the Police"),
      tags$p("The SCJS monitors the population's perceptions of the way the police take forward their work and engage with individuals and communities in Scotland. Results represent the percentages of respondents who (tend to/strongly) agreed with the statements that the police in their area:",
             tags$li("Can be relied on to be there"),
             tags$li("Would treat you with respect"),
             tags$li("Treat everyone fairly"),
             tags$li("Listen to the concerns of local people"),
             tags$li(tags$u("Are not dealing with the things that matter to the community")),
             tags$li(tags$u("Have poor relations with the community"))
      ),
      tags$p("In addition, the SCJS also measures the percentage of respondents who believe that:",
             tags$li(tags$u("There is not enough police presence in the local area")),
             tags$li("The police in the local area are doing a fair or good job")
      ),
      tags$p("Some of these variables (underlined) are not positive measures. For these variables, lower percentages are better. For others, higher percentages are better, indicating agreement with positive statements about the local police."),
      tags$p(tags$i("Due to changes in the survey, some questions might not be present in all years."))
  ),
######################################################################################
                                     
  "Confidence in Scottish Criminal Justice System" = 
  div(id=NULL,
      tags$h5("Confidence in Scottish Criminal Justice System"),
      tags$p("The SCJS measures the public's confidence in the criminal justice system as a whole, through a range of statements about the operation and performance of the system. Results represent the percentage of respondents who are (fairly or very) confident that the criminal justice system:",
             tags$li("Provides a good standard of service for victims of crime"),
             tags$li("Provides a good standard of service for witnesses"),
             tags$li("Makes fair, impartial decisions based on the evidence available"),
             tags$li("Gives punishments which fit the crime"),
             tags$li("Adequately takes into account the circumstances surrounding a crime when it hands out sentences"),
             tags$li("Allows all victims of crime to seek justice regardless of who they are"),
             tags$li("Allows all those accused of crimes to get a fair trial regardless of who they are"),
             tags$li("Provides victims of crime with the services and support they need"),
             tags$li("Provides witnesses with the services and support they need"),
             tags$li("Treats those accused of crime as innocent until proven guilty")
      ),
      tags$p("All the above variables measure confidence in the criminal justice system, so higher percentages are better."),
      tags$p(tags$i("Due to changes in the survey, some questions might not be present in all years."))
  ),
######################################################################################
  
  "Perceptions of Crime Rates and Safety" = 
  div(id=NULL,
      tags$h5("Perceptions of Crime Rates and Safety"),
      tags$p("The SCJS asks respondents about their perception of crime rates over the last 2 years, both in their local area and on a national level. Results represent the percentages of respondents who believe that:",
             tags$li("The crime rate in their local are has stayed the same or reduced"),
             tags$li("The crime rate in Scotland has stayed the same or reduced")
      ),
      tags$p("Data is also captured on how safe the Scottish population feel, via measuring the percentage of respondents who indicate that they feel (either fairly or very) safe when:",
             tags$li("Alone in home at night"),
             tags$li("Walking along in local area after dark")
      ),
      tags$p("For all these variables, higher results are better; indicating more people feeling safe/perceiving reducing crime rates.")
  ),
######################################################################################
  
  "Perceptions of Local Crime" = 
  div(id=NULL,
      tags$h5("Perceptions of Local Crime"),
      tags$p("Along with measuring public perceptions of crime rates in general, the SCJS also measures the public perception of how common specific crimes are in their local area. Percentages of respondents who think it (either fairly or very) common for the following crimes are reported:",
             tags$li("Cars or other vehicles stolen"),
             tags$li("Things stolen from cars or other vehicles"),
             tags$li("Deliberate damage to property or vehicles"),
             tags$li("People's homes being broken into"),
             tags$li("People being mugged or robbed"),
             tags$li("People being physically assaulted or attacked in the street or other public places"),
             tags$li("People being physically attacked because of their skin colour etc"),
             tags$li("People being sexually assaulted"),
             tags$li("Drug dealing and drug abuse"),
             tags$li("People behaving in an anti-social manner in public"),
             tags$li("Violence between groups of individuals or gangs"),
             tags$li("People carrying knives"),
             tags$li("Deliberate damage to cars or other vehicles"),
             tags$li("Deliberate damage to people's homes by vandals")
      ),
      tags$p("These variables all represent perceived frequences of local crime; lower percentages are better."),
      tags$p(tags$i("Due to changes in the survey, some questions might not be present in all years."))
  ),
######################################################################################
  
  "Perceptions of Local People" = 
  div(id=NULL,
      tags$h5("Perceptions of Local People"),
      tags$p("The SCJS also asks the Scottish public a number of questions about their feelings towards people in their local area. Results represent the percentages of respondents who (either slightly or strongly) agreed with the statements people in the local area:",
             tags$li(tags$u("Cannot be trusted")),
             tags$li("Could be counted on to keep an eye on my home if it was empty"),
             tags$li("Can be relied upon to call the police if someone is acting suspiciously"),
             tags$li("Can be turned to for advice and support"),
             tags$li("Pull together to prevent crime")
      ),
      tags$p("Some of these statements (underlined) are not positive. For these variables, lower percentages are better. For others, higher percentages are better, indicating agreement with positive statements about local people."),
      tags$p(tags$i("Due to changes in the survey, some questions might not be present in all years."))
  ),
#######################################################################################

  "Worries of Crime" = 
  div(id=NULL,
      tags$h5("Worries of Crime"),
      tags$p("Complimentary to measuring both crime vicitimsation rates and public perceptions of crime rates, the SCJS asks a set of questions aimed to measure how worried the public are about specific types of crime. Results represent the percentage of respondents who are (either fairly or very) worried about the following events:",
             tags$li("Their identity will be stolen"),
             tags$li("Someone will use their credit or bank details to obtain money, goods or services"),
             tags$li("Their car or other vehicle will be stolen"),
             tags$li("Things will be stolen from their car or other vehicle"),
             tags$li("Their car or other vehicle will be damaged by vandals"),
             tags$li("Their home will be damaged by vandals"),
             tags$li("Their home will be broken into"),
             tags$li("They will be mugged or robbed"),
             tags$li("They will be physically assaulted or attacked in the street or other public place"),
             tags$li("They will be involved or caught up in violence between groups of individuals or gangs"),
             tags$li("They will be sexually assaulted")
      ),
      tags$p("These variables all represent the amount of worry the public has for different crimes. Lower percentages are better, indicating less worry."),
      tags$p(tags$i("Due to changes in the survey, some questions might not be present in all years."))
  ),
######################################################################################

  "Worries of Being Harassed" = 
  div(id=NULL,
      tags$h5("Worries of Being Harassed"),
      tags$p("From 2012/13, the SCJS has measured how worried the population are about being harassed. The percentages represent how many respondents are (either fairly or very) worried about being insulted, pestered or intimidated on the basis of:",
             tags$li("Ethnic origin or race"),
             tags$li("Religion"),
             tags$li("Sectarianism"),
             tags$li("Sexual orientation"),
             tags$li("Gender / gender identity or perception of this"),
             tags$li("A disability / condition"),
             tags$li("Age")
      ),
      tags$p("These variables all represent the amount of worry the public has for different crimes. Lower percentages are better, indicating less worry."),
      tags$p(tags$i("Due to changes in the survey, some questions might not be present in all years."))
  )                    
######################################################################################

)
