setwd("\\\\scotland.gov.uk/dc2/fs4_home/Z613379/pdiv_shiny/v9")
################
#sort out data.
################

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
                "Better"="#95fb71",
                "Worse"="#fb7171")

#modebar icons to remove
modebar_remove <- c('hoverClosestCartesian','hoverCompareCartesian','zoom2d','pan2d','toggleSpikelines','select2d','lasso2d','zoomIn2d','zoomOut2d')

#####
#DATA, input choices
#####
#proportion data
df<-readRDS("data/pdiv9.5.test.rds")


#df$wrapped_name <- sapply(df$name_trunc, FUN = function(x) {paste(strwrap(x, width = 20), collapse = "<br>")})
#df$wrappedv <- sapply(df$label, FUN = function(x) {paste(strwrap(x, width = 25), collapse = "<br>")})


des_factors <- df %>% group_by(year) %>% summarise(des_f=first(des_effect)) #design factors
pdivis<-levels(factor(df$police_div)) #police divisions
years=levels(df$year) #years
currentyear=years[length(years)] #latest survey year
prevyear=years[length(years)-1] #previous survey year
firstyear=years[1] #first survey year
yn<-c("Yes","No") #yes no choices


getnames<-function(string){
  df %>%
    filter(grepl(string,variable)) %>%
    pull(name_trunc) %>%
    unique() %>%
    as.character()
}
#variables/variable groupings
all_vars<-list('National Indicators'= getnames("PREVSURVEY|QS2AREA:|DCONF_03"),
               'Rates of Crime Victimisation'=getnames("PREV"),
               'Confidence in the Police'=getnames("POLCONF"),
               'Attitudes to the Police'=getnames("POLOP|COMPOL|POLPRES|RATPOL"),
               'Confidence in Scottish Crime and Justice System'=getnames("DCONF"),
               'Perceptions of Crime and Safety'=getnames("QS"),
               'Worries of Victimisation'=getnames("QWORR"),
               'Worries of Being Harassed'=getnames("HWORR"),
               'Perceptions of Local Crime'=getnames("QACO"),
               'Perceptions of Local People'=getnames("LCPEOP")
               )
df$variable<-df$name_trunc



save.image(file = "./app/data/app_preamble.RData")

