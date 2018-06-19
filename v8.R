library(shiny)
library(plotly)
require(tidyr)
require(dplyr)
require(magrittr)
library(shinydashboard)
rm(list=ls())

#####
#plotting constants
#####
#police division colours
pdivcols=c("Argyll & West Dunbartonshire (L Division)"='#66C2A5',
           "Ayrshire (U Division)"='#FC8D62',
           "Dumfries & Galloway (V Division)"='#8DA0CB',
           "Edinburgh City (E Division)"='#E78AC3',
           "Fife (P Division)"='#A6D854',
           "Forth Valley (C Division)"='#FFD92F',
           "Greater Glasgow (G Division)"='#E5C494',
           "Highlands & Islands (N Division)"='#8DD3C7',
           "Lanarkshire (Q Division)"='#FB8072',
           "Lothians & Scottish Borders (J Division)"='#BEBADA',
           "NA"='#FFFFB3',
           "North East (A Division)"='#80B1D3',
           "Renfrewshire & Inverclyde (K Division)"='#FDB462',
           "Tayside (D Division)"='#B3DE69',
           "National Average"='#B3B3B3')
#colours for overview page (national avg = black, and up/down/none is included)
overview_cols=c(pdivcols[-length(pdivcols)],
                "National Average"='#000000',
                "Same"="#BDBDBD",
                "Better"="#82FA58",
                "Worse"="#FA5858")
#modebar icons to remove
modebar_remove <- c('hoverClosestCartesian','hoverCompareCartesian','zoom2d','pan2d','toggleSpikelines','select2d','lasso2d','zoomIn2d','zoomOut2d')

#####
#DATA, input choices
#####
#proportion data
df<-readRDS("pdiv8.0_full.rds")

#df$wrapped_name <- sapply(df$name_trunc, FUN = function(x) {paste(strwrap(x, width = 20), collapse = "<br>")})
#df$wrappedv <- sapply(df$label, FUN = function(x) {paste(strwrap(x, width = 25), collapse = "<br>")})


des_factors <- df %>% group_by(year) %>% summarise(des_f=first(des_effect)) #design factors
pdivis<-levels(factor(df$breaks)) #police divisions
years=levels(df$year) #years
currentyear=years[length(years)] #latest survey year
prevyear=years[length(years)-1] #previous survey year
firstyear=years[1] #first survey year
yn<-c("Yes","No") #yes no choices


#variables/variable groupings
all_vars<-list('National Indicators'=levels(df$variable)[grepl("PREVSURVEY|QS2AREA:|DCONF_03",levels(df$variable))],
               'Rates of Crime Victimisation'=levels(df$variable)[grepl("PREV",levels(df$variable))],
               'Confidence in the Police'=levels(df$variable)[grepl("POLCONF",levels(df$variable))],
               'Perceptions of Crime and Safety'=levels(df$variable)[grepl("QS",levels(df$variable))],
               'Worries of Victimisation'=levels(df$variable)[grepl("QWORR",levels(df$variable))],
               'Perceptions of Crime'=levels(df$variable)[grepl("QACO",levels(df$variable))],
               'Perceptions of the Police'=levels(df$variable)[grepl("POLOP|COMPOL|POLPRES|RATPOL",levels(df$variable))],
               'Perceptions of Local People'=levels(df$variable)[grepl("LCPEOP",levels(df$variable))],
               'Confidence in Scottish CJS'=levels(df$variable)[grepl("DCONF",levels(df$variable))],
               'Worries of Harassment'=levels(df$variable)[grepl("HWORR",levels(df$variable))]
               )


source("ui2.R")

selected_pclick <- 0 #declare outside the server function

source("server.R")


shinyApp(ui = ui, server = server)    

  

