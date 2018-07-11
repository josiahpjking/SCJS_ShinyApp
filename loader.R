#####
#DATA, input choices
#####
require(tidyr)
require(dplyr)
require(ggplot2)
require(magrittr)
require(plotly)
#load in current set of functions

source("setup/extract_name_data.R")
source("setup/rowSums_na.R")
source("setup/rowsum_partialstringmatch_variables.R")
source("setup/create_pdiv_data.R")

###########
#FOR UPDATING
###########
#these are all the years of the survey
years<-c("2008/09","2009/10","2010/11","2012/13","2014/15")
#these are all the design effects
d_effects = c(1.5, 1.5, 1.5, 1.3, 1.2)

#this is the new year of the survey
new_year <- c("2016/17")
#this is the new design effect
new_deffect <- 1.34
#list data files which match "SCJS" in the following directory
new_data_path <- dir(path = "\\\\scotland.gov.uk/dc2/fs4_home/Z613379/data/", pattern='SCJS_2016_17_MAIN8*', recursive = T,full.names = T)

#################
#MAKE PROPORTION TABLES FROM NEW DATASETS
#################


#make tables of proportions
#this requires the new data set(s), the year(s), and the design effects.
# previous years 
df <- create_pdiv_data(new_data_path,years=new_year,design_effects=new_deffect) 

#read info on variables
variable_info<-read.csv("data/variables_full.csv")
variable_info$variable<-tolower(variable_info$variable)
#join to proportion tables
df<-left_join(df,variable_info)

#make some wrapped variables (this is for plotting.)
df %>% mutate(
  wrappedv = sapply(label, FUN = function(x) {paste(strwrap(x, width = 25), collapse = "<br>")}),
  wrapped_name = sapply(name_trunc, FUN = function(x) {paste(strwrap(x, width = 25), collapse = "<br>")})
) -> df

#set variable
df$variable<-factor(df$label)



#################
#JOIN TO OLD DATA SET
#################


df<-bind_rows(readRDS("data/pdiv9.5.test.rds"), df)
#set year
df$year <- factor(df$year)
levels(df$year)<-years


#################
#APP DETAILS/PLOTTING OPTIONS ETC
#################

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
           "National Average"='#000000')

#colours for overview page (national avg = black, and up/down/none is included)
overview_cols=c(pdivcols,
                "No difference"="#BDBDBD",
                "More Positive"="#95fb71",
                "Less Positive"="#fb7171")

#modebar icons to remove
modebar_remove <- c('hoverClosestCartesian','hoverCompareCartesian','zoom2d','pan2d','toggleSpikelines','select2d','lasso2d','zoomIn2d','zoomOut2d')


# USER INPUTS
des_factors <- df %>% group_by(year) %>% summarise(des_f=first(des_effect)) #design factors
pdivis<-levels(factor(df$police_div)) #police divisions
years=levels(df$year) #years
currentyear=years[length(years)] #latest survey year
prevyear=years[length(years)-1] #previous survey year
firstyear=years[1] #first survey year
yn<-c("Yes","No") #yes no choices


# VARIABLE LISTS

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
               'Confidence in the Police'=getnames("POLCONF|RATPOL"),
               'Attitudes to the Police'=getnames("POLOP|POLPRES"),
               'Confidence in Scottish Criminal Justice System'=getnames("DCONF"),
               'Perceptions of Crime Rates and Safety'=getnames("QS"),
               'Perceptions of Local Crime'=getnames("QACO"),
               'Perceptions of Local People'=getnames("LCPEOP"),
               'Worries of Crime Victimisation'=getnames("QWORR"),
               'Worries of Being Harassed'=getnames("HWORR")
               )
#now overwrite variable with more user-friendly input
df$variable<-df$name_trunc

#### map data
pd_latlon <- readRDS("data/pd_mapdata.RDS")


df %>% filter(police_div=="National Average", 
              year %in% c(currentyear,prevyear),
              variable %in% all_vars[[1]]) %>%
  group_by(variable) %>%
  summarise(
    current_percentage = percentage[which(year==currentyear)],
    current_ci = ci[which(year==currentyear)],
    p_diff=abs(diff(p)),
    c=sqrt(sum(ci^2)),
    p_signif=p_diff>c,
    rev_coded=first(reverse_coded),
    thisyear = ifelse(p_signif==TRUE & year[which(p==min(p))]==currentyear, "lower",
                      ifelse(p_signif==TRUE & year[which(p==min(p))]!=currentyear, "higher",
                             "same")),
    thisyear_imp = ifelse(rev_coded==1 & thisyear=="higher","lower",
                          ifelse(rev_coded==1 & thisyear=="lower","higher", thisyear)),
    thisyear_col = ifelse(thisyear_imp=="higher","#95fb71",
                          ifelse(thisyear_imp=="lower","#fb7171","#BDBDBD"))
  ) %>% select(variable, current_percentage, current_ci, thisyear_imp, thisyear_col) -> image_data

image_data %>% filter(grepl("Confident",variable)) -> ni_conf_data
image_data %>% filter(grepl("Victim",variable)) -> ni_crime_data
image_data %>% filter(grepl("Perceived",variable)) -> ni_perc_data


############
#FINALLY, save Rdata to the app directory
############
ungroup(df) -> df

#update the app data.
save.image(file = "./app/.RData")

shiny::runApp(appDir="./app/")




