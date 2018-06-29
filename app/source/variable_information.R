variable_info_list <- list(
  "National Indicators" = div(id=NULL,
                              tags$h5("National Indicators"),
                              tags$p("The SCJS measures 3 National Indicators:",
                                 tags$li("Rate of any crime victimisation"),
                                 tags$li("Perceptions of local crime rates: belief that it is the same or less than 2 years previous"),
                                 tags$li("Confidence in access to the Criminal Justic System")
                              )
  ),
  
  "Rates of Crime Victimisation" = div(id=NULL,
                                       tags$h5("Rates of Crime Victimisation"),
                                       tags$p("The SCJS measures the rates of victimisation of many different crime types. The three main types are included here:",
                                          tags$li("Victims of any crime"),
                                          tags$li("Victims of violent crime"),
                                          tags$li("Victims of property crime")
                                       )
  ),
  
  "Confidence in the Police" = div(id=NULL,
                                   tags$h5("Confidence in the Police"),
                                   tags$p("The SCJS asks respondents how confident they are in the ability of the police in their local area to undertake six particular components of work:",
                                      tags$li("Prevent crime"),
                                      tags$li("Respond quickly and appropriately"),
                                      tags$li("Deal with incidents as they occur"),
                                      tags$li("Investigate incidents after they occur"),
                                      tags$li("Solve crimes"),
                                      tags$li("Catch criminals")
                                   )
  ),
  
  "Attitudes to the Police" = div(id=NULL,
                                  tags$h5("Attitudes to the Police"),
                                  tags$p("The SCJS monitors the population's perceptions of the way the police take forward their work and engage with individuals and communities in Scotland. Respondents are asked whether they agreed or disagreed that the police in their area:",
                                     tags$li("Can be relied on to be there"),
                                     tags$li("Would treat you with respect"),
                                     tags$li("Treat everyone fairly"),
                                     tags$li("Listen to the concerns of local people"),
                                     tags$li("Are not dealing with the things that matter to the community"),
                                     tags$li("Have poor relations with the community")
                                  ),
                                  tags$p("In addition to these questions, the SCJS also measures the importance of police presence to the public, along with perceptions of current levels of police presence. Respondents are asked:",
                                     tags$li("How important it is to them that there are local police officers who know and patrol the local area"),
                                     tags$li("If police presence in the local area is not enough/about right/too much"),
                                     tags$li("If the police in the local area are doing a fair or good job")
                                  ),
                                  tags$p("The selection of specific questions asked can change in each iteration of the survey. Some questions might not be present in all years")
  ),
                                     
  "Confidence in Scottish Criminal Justice System" = div(id=NULL,
                                                         tags$h5("Confidence in Scottish Criminal Justice System"),
                                                          tags$p("The SCJS measures the public's confidence in the criminal justice system as a whole, through a range of statements about the operation and performance of the system. Respondents are asked how confident they are that the criminal justice system:",
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
                                                         tags$p("The selection of specific questions asked can change in each iteration of the survey. Some questions might not be present in all years")
  ),
  
  "Perceptions of Crime and Safety" = div(id=NULL,
                                          tags$h5("Perceptions of Crime Rates and Safety"),
                                          tags$p("The SCJS asks respondents about their perception of crime rates over the last 2 years, both in their local area and on a national level. We then look at the percentages of respondents who believe that:",
                                                 tags$li("The crime rate in their local are has stayed the same/reduced"),
                                                 tags$li("The crime rate in Scotland has stayed the same/reduced")
                                          ),
                                          tags$p("Respondents are also asked about how safe they feel when:",
                                                 tags$li("Alone in home at night"),
                                                 tags$li("Walking along in local area after dark")
                                          )
  ),
  
  "Worries of Crime" = div(id=NULL,
                           tags$h5("Worries of Crime"),
                           tags$p("As well as measuring both crime rates and perceptions of crime rates, the SCJS also captures data on how worried the public are about specific types of crime. Respondents are asked how worried they are that:",
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
                           tags$p("The selection of specific questions asked can change in each iteration of the survey. Some questions might not be present in all years")
  ),
  
  "Worries of Being Harassed" = div(id=NULL,
                                    tags$h5("Worries of Being Harassed"),
                                    tags$p("The SCJS asks respondents whether they are worried about being insulted, pestered or intimidated on the basis of:",
                                           tags$li("Ethnic origin or race"),
                                           tags$li("Religion"),
                                           tags$li("Sectarianism"),
                                           tags$li("Sexual orientation"),
                                           tags$li("Gender / gender identity or perception of this"),
                                           tags$li("A disability / condition"),
                                           tags$li("Age")
                                    ),
                                    tags$p("The selection of specific questions asked can change in each iteration of the survey. Some questions might not be present in all years")
  ),                                
                                    
  "Perceptions of Local Crime" = div(id=NULL,
                                     tags$h5("Perceptions of Local Crime"),
                                     tags$p("As well as capturing data on public perceptions of crime rates, the SCJS also measures the public perception of how common specific crimes are in their local area. These include:",
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
                                     tags$p("The selection of specific questions asked can change in each iteration of the survey. Some questions might not be present in all years")
  ),
  
  "Perceptions of Local People" = div(id=NULL,
                                      tags$h5("Perceptions of Local People"),
                                      tags$p("The SCJS measures respondents perceptions of people in their local area. Respondents are asked whether they agreed or disagreed that people in their local area:",
                                             tags$li("Cannot be trusted"),
                                             tags$li("Could be counted on to keep an eye on my home if it was empty"),
                                             tags$li("Can be relied upon to call the police if someone is acting suspiciously"),
                                             tags$li("Can be turned to for advice and support"),
                                             tags$li("Pull together to prevent crime")
                                             ),
                                      tags$p("The selection of specific questions asked can change in each iteration of the survey. Some questions might not be present in all years")
  )
                                    

)
