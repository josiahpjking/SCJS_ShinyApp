#packages needed
require(tidyr)
require(dplyr)
require(ggplot2)
require(magrittr)
require(plotly)
require(foreign)
#load in functions
source("functions/extract_name_data.R")
source("functions/load_scjs_data.R")
source("functions/rowSums_na.R")
source("functions/rowsum_partialstringmatch_variables.R")
source("functions/tidydemographics.R")
#####
#DATA, YEARS, DESIGN - CHANGE FOR UPDATING
#####

#these are all the years of the survey
years<-c("2008-09","2009-10","2010-11","2012-13","2014-15","2016-18*")
#these are all the design factors
design_factors = c(1.5, 1.5, 1.5, 1.3, 1.2, 1.28)

data_files <- dir(path = "../data/", pattern='SCJS*', recursive = T,full.names = T)
print(data_files)
# READ IN DATA. 
# if you want more variables, you need to add in the string (lowercase) to identify those questions.
all_data <- bind_rows(lapply(data_files[1:6], function(x) extract_name_data(x,"serial|age|laa|hba|cjaa|gen|urb|tenure|soc|nssec|simd|wgtg|prev|qpolconf|qs2area|qsfdark|qsfnigh|qratpol|polop|compol|polpres|qworr|numcar|nummot|qaco_|lcpeop|qhworr|qswem|dconf|polpatr|pcon")), .id = "year")

#check that years are in the correct order.
with(all_data, table(year,sourcefile))

#set the year variable
all_data$year<-factor(all_data$year, labels=years)

#some variables were named differently in the first year (e.g. qpolconf_01 was qpolconf_1). this will look for names which match when replacing _ with _0, and combines them.
rowsum_partialstringmatch_variables(all_data,"_","_0") -> all_data
rowsum_partialstringmatch_variables(all_data,"compol","compol2") -> all_data

#this tidies up all the all_dataic breaks (age, gender, police division etc)
tidydemographics(all_data) -> all_data

####################################
#RECODE QUESTIONS
#we need to recode the questions to binary 1 or 0. 

#all prev variables (prevsureycrime, prevviolent etc) need to be coded such that 2's become 0's.
all_data %>% mutate_at(vars(starts_with("prev")),funs(replace(.,.==2,0))) -> all_data
#same with the polpatr_0
all_data %>% mutate_at(vars(starts_with("polatr_0")),funs(replace(.,.==2,0))) -> all_data


#QS2AREA: Perceived change in crime rate in local area in last two years
#QS2AREAS: Perceived change in crime rate in Scotland in last two years
# 3,4,5 = same or less
# -2,-1,1,2 = rf, dk, or more
all_data %>% mutate_at(vars(c(matches("qs2area"))),funs(recode(.,'1'=0,'2'=0,'3'=1,'4'=1,'5'=1,'-2'=0,'-1'=0,.default=NA_real_))) -> all_data


#QPOLCONF_01...06 Confidence in ability of police in local area to: ...
#QDCONF_01...14 Confidence that the Scottish CJS: ...
# 1,2 = confident
# -2,-1,3,4 = rf, dk, not confident

#COMPOL: How important to you is it that there are local police officers who know and patrol in your local area?
# 1,2 = important
# -2,-1,3,4, = rf, dk, not important

#POLOPREL,POLOPRESP,POLOPFAIR,POLOPMAT,POLOPCON,POLOPCOM,POLOPOVER
#Agreement that: Police in this area....
#LCPEOP_01...07: Agreement that: People in my local area ...
# 1,2 = agree
# -2,-1,3,4,5 = dk, rf, neither, disagree

#QWORR_01...07 Extent of worry that: ...?
#QHWORR_01...07 How much, if at all, do you, personally, worry about being insulted, pestered or intimidated on the basis of ...
# 1,2 = worried
# -2,-1,3,4,5 = rf, dk, not worried, not appl.

#QACO_01...14 In local area how common is: ...
# 1,2 = common
# -2,-1,3,4 = rf, dk, not common

#QSFDARK: How safe respondent feels walking alone in local area after dark
#QSFNIGH: How safe respondent feels alone in home at night
# 1,2 = safe
# -1,3,4 = dk, unsafe

#these questions have responses 1,2 = 1, 3,4 = 0.
recode_questions="qpolconf|qdconf|compol|lcpeop|polop|qworr|qhworr|qaco|qsfdark|qsfnigh"
all_data %>% mutate_at(vars(c(matches(recode_questions))),funs(recode(.,'1'=1,'2'=1,'3'=0,'4'=0,'5'=0,'-2'=0,'-1'=0,.default=NA_real_))) -> all_data

#polpatrf is 1,2,3,4 = 1, 
all_data %>% mutate_at(vars(c(matches("polpatrf"))),funs(recode(.,'1'=1,'2'=1,'3'=1,'4'=1,'5'=0,'6'=0,'-2'=0,'-1'=0,.default=NA_real_))) -> all_data


#QPCONINT: How much interest did the police show in what you had to say (most recent contact in last year)?
# 1 = as much as you thought they should
# -2,-1,2 = rf, dk, less
#POLPRES: Police presence in local area is:
# 1 = not enough
# -2,-1,2,3 = rf, dk, about right, too much
#QDCRIME2: Excluding motoring offences, have you ever been convicted of a crime?
# 1 = yes
# -2,-1,2 = rf, dk, no
all_data %>% mutate_at(vars(matches("polpres|qdcrime|qpconint")),funs(recode(.,'1'=1,'2'=0,'3'=0,'-2'=0,'-1'=0,.default=NA_real_))) -> all_data

#QPCON: Have you PERSONALLY had any contact with the police service in the last year?
# 1 = yes
# -2,-1,2 = rf, dk, no
all_data %>% mutate_at(vars(qpcon),funs(recode(.,'1'=1,'2'=0,'3'=0,'-2'=0,'-1'=0,.default=NA_real_))) -> all_data

#QPCONPOL: How polite were they in dealing with you (most recent contact in last year)?
# 1,2 = very fairly polite
# -2,-1,3,4 = rf, dk, fairly very impolite
#QPCONFAIR: How fairly would you say the police treated you on this occasion (most recent contact in last year)?
# 1,2 = very quite fairly
# -2,-1,3,4 = rf, dk, quite very unfairly
all_data %>% mutate_at(vars(matches("qpconfair|qpconpol")),funs(recode(.,'1'=1,'2'=1,'3'=0,'4'=0,'-2'=0,'-1'=0,.default=NA_real_))) -> all_data

#QPCONSAT: Overall, were you satisfied or dissatisfied with the way the police handled the matter (most recent contact in last year)? 
# 1,2 = very quite satisfied
# -2,-1,3,4,5,7 = rf, dk, quite very disatisfied, neither, too early
all_data %>% mutate_at(vars(qpconsat),funs(recode(.,'1'=1,'2'=1,'3'=0,'4'=0,'-2'=0,'5'=0,'7'=0,'-1'=0,.default=NA_real_))) -> all_data


#QPCONVIEW: Did this incident change your view of the police at all (most recent contact in last year)?  Did you view them: 
# 1,3 = no change, more favourable
# -2,-1,2 = rf, dk, less favourably
all_data %>% mutate_at(vars(qpconview),funs(recode(.,'1'=1,'3'=1,'2'=0,'-2'=0,'-1'=0,.default=NA_real_))) -> all_data


#QRATPOL: Taking everything into account, how good a job do you think the police IN THIS AREA are doing?
# 1,2 = excellent or good
# -2,-1,3,4,5 = rf, dk, poor, fair
all_data %>% mutate_at(vars(matches("qratpol")),funs(recode(.,'1'=1,'2'=1,'3'=0, '4'=0,'5'=0,'-2'=0,'-1'=0,.default=NA_real_))) -> all_data


##########
#Fixes across years
#the qworr_01,02,03 questions need to be set to NA when there is <1 motor vehicle in the househole
#(they were asked even to people who don't have cars)
#these were changed in wordings, and became 12,13,14. so we need to do it for them too.
all_data %>% mutate(
  anyvehicle = ifelse(numcar>0 | nummot>0, 1, 0),
  qworr_01 = ifelse(anyvehicle==1,qworr_01,NA),
  qworr_02 = ifelse(anyvehicle==1,qworr_02,NA),
  qworr_03 = ifelse(anyvehicle==1,qworr_03,NA),
  qworr_12 = ifelse(anyvehicle==1,qworr_12,NA),
  qworr_13 = ifelse(anyvehicle==1,qworr_13,NA),
  qworr_14 = ifelse(anyvehicle==1,qworr_14,NA)
) -> all_data

#so, qworr_01,2,3 and 12,13,14 are the same. (basically, the filtering of cars is now done post-hoc, rather than questions being asked conditionally upon car ownership)
#wording is the same, so we'll collapse them.
all_data %>% mutate(
  qworr_01 = ifelse(is.na(qworr_01) & !is.na(qworr_12), qworr_12, qworr_01),
  qworr_02 = ifelse(is.na(qworr_02) & !is.na(qworr_13), qworr_13, qworr_02),
  qworr_03 = ifelse(is.na(qworr_03) & !is.na(qworr_14), qworr_14, qworr_03)
) -> all_data





#okay, we're done with question recoding. let's get rid of some unnecessary variables which have been picked up along the way by accident
tidy_df<-all_data %>% select(-matches("qpconvf|qpconwh|qpconyr|_dk|_rf"))

#####################################################################################################
##check variables are present across years.
#######
tidy_df %>% group_by(year) %>% summarise_all(
  funs(sum(!is.na(.)))) %>%
  gather(., key="variable",value="number_obs",-year) -> year_counts

#this will show the number of non NA observations across years for variables matching the string
#year_counts %>% filter(grepl("qsfdark",variable))

#this summarises whether a variable has at least 1 non NA observation for each year.
year_counts %>% group_by(variable) %>% 
  summarise(
    no_na = !(any(number_obs==0))
  ) -> variable_across_years

######
#CREATE TABLES OF PROPORTIONS FOR USE IN SHINY APP

#first, this is an alteration because contractors gave us weights with different names for the combined years
tidy_df %>%
  mutate(
    wgtghhd = ifelse(year=="2016-18*",wgtghhd_comb, wgtghhd),
    wgtgindiv = ifelse(year=="2016-18*",wgtgindiv_comb, wgtgindiv),
    qdconf_08 = ifelse(year=="2016-18*",NA,qdconf_08),
    qdconf_15 = ifelse(year=="2016-18*",NA,qdconf_15)
  ) -> tidy_df
tidy_df %>% select(-qdconf_15) -> tidy_df


############### VARIABLE WEIGHTINGS #################
# these variables are the ones which are weighted by individual weighting
tidy_df %>% select(-matches("qpconvf|qpconwh|qpconyr|_dk|_rf")) %>%
  select(prevproperty, prevviolent, prevsurveycrime, polpres, qsfdark, matches("qpolconf|qs2area|qsfnigh|qratpol|polop|compol|qworr|qaco_|lcpeop|qhworr|dconf|qpcon|polpatr")) %>% 
  names() -> indiv_vars

# are there any variables which are weighted by household weighting?
tidy_df %>% 
  select() %>%
  names() -> hhd_vars


########################################################
#calculate weighted proportions (individual weightings)
tidy_df %>% 
  group_by(police_div, year) %>% 
  summarise_at(vars(one_of(indiv_vars)),
               funs(p=prop.table(xtabs(wgtgindiv ~ .))[2],
                    ss=sum(!is.na(.)),
                    wss=sum(wgtgindiv[!is.na(.)])
               )) -> df_wide
#join the national averages
tidy_df %>% 
  group_by(year) %>% 
  summarise_at(vars(one_of(indiv_vars)),
               funs(p=prop.table(xtabs(wgtgindiv ~ .))[2],
                    ss=sum(!is.na(.)),
                    wss=sum(wgtgindiv[!is.na(.)])
               )) %>% 
  mutate(police_div="National Average") %>%
  bind_rows(df_wide,.) -> df_wide


########################################################
#calculate weighted proportions (household weightings)
if(length(hhd_vars)>0){
  tidy_df %>% 
    group_by(police_div, year) %>% 
    summarise_at(vars(one_of(hhd_vars)),
                 funs(
                   p=prop.table(xtabs(wgtghhd ~ .))[2],
                   ss=sum(!is.na(.)),
                   wss=sum(wgtghhd[!is.na(.)])
                 )) -> df_wide_hhd
  #join the national averages
  tidy_df %>% 
    group_by(year) %>% 
    summarise_at(vars(one_of(hhd_vars)),
                 funs(
                   p=prop.table(xtabs(wgtghhd ~ .))[2],
                   ss=sum(!is.na(.)),
                   wss=sum(wgtghhd[!is.na(.)])
                 )) %>% 
    mutate(police_div="National Average") %>%
    bind_rows(df_wide_hhd,.) -> df_wide_hhd
  
  #this is because we're only looking at one household weighted variable.
  if(length(hhd_vars)==1){
    names(df_wide_hhd)[3:5]<-paste0(hhd_vars[1],"_",names(df_wide_hhd)[3:5])
  }
  #join the household weighted and individual weighted data
  df_wide <- left_join(df_wide,df_wide_hhd)
}

############### RESHAPE DATA #################  

#gather proportions into long format
df_wide %>% 
  select(-matches("_wss|_ss")) %>% 
  gather(key=variable, value=p, contains("_p")) %>%
  mutate(
    variable=gsub("_p","",variable)
  ) -> prop_data

#gather samplesizes into long format
df_wide %>% 
  select(-matches("_p|_wss")) %>% 
  gather(key=variable, value=samplesize, contains("_ss")) %>%
  mutate(
    variable=gsub("_ss","",variable)
  ) -> ss_data

#gather weighted samplesizes into long format
df_wide %>% 
  select(-matches("_p|_ss")) %>% 
  gather(key=variable, value=samplesize_w, contains("_wss")) %>%
  mutate(
    variable=gsub("_wss","",variable)
  ) -> wss_data

#join all together
left_join(prop_data, ss_data) %>% left_join(.,wss_data) -> pdtable


############### CONFIDENCE INTERVALS #################

#join the design factors
desfacts <- data.frame(year=years,des_fact=design_factors)

#calculate confidence intervals.
left_join(pdtable, desfacts) %>%
  mutate(
    percentage=p*100,
    count=p*samplesize,
    ci = (sqrt((p*(1-p))/samplesize))*1.96*des_fact,
    low = percentage-(ci*100),
    high = percentage+(ci*100)
  ) -> pdtable


##################################################################################################################
#MAKE DATA APP-READY
#################
#this will be the data for the app.
#read in the information on each variable (shorter versions etc)
variable_info<-read.csv("data/variable_information.csv")
variable_info$variable<-tolower(variable_info$variable)
#join to proportion tables
pdtable<-left_join(pdtable,variable_info)



#make some wrapped variables (this is for plotting - it means variables are written on two lines rather than one.)
pdtable %>% mutate(
  wrappedv = sapply(label, FUN = function(x) {paste(strwrap(x, width = 25), collapse = "<br>")}),
  wrapped_name = sapply(name_trunc, FUN = function(x) {paste(strwrap(x, width = 25), collapse = "<br>")}),
  my_text_trend = paste0("<b>",police_div,"</b><br>",year,"<br>",wrapped_name,"<br><b>",round(percentage, digits=1),"</b>% +/-",round(ci*100, digits=1),", N = ",samplesize)
) -> pdtable

#set variable 
pdtable$variable<-factor(pdtable$label)

#save the data (just in case)
saveRDS(pdtable,"data/pdiv_v2.4.rds")

###############
#tidyup
###############
rm(list=ls())

df<-readRDS("data/pdiv_v2.4.rds")

#police division colours
pdivcols=c("Argyll & West Dunbartonshire (L Division)"='#a6cee3',
           "Ayrshire (U Division)"='#1f78b4',
           "Dumfries & Galloway (V Division)"='#b2df8a',
           "Edinburgh City (E Division)"='#33a02c',
           "Fife (P Division)"='#fb9a99',
           "Forth Valley (C Division)"='#e31a1c',
           "Greater Glasgow (G Division)"='#fdbf6f',
           "Highlands & Islands (N Division)"='#ff7f00',
           "Lanarkshire (Q Division)"='#cab2d6',
           "Lothians & Scottish Borders (J Division)"='#6a3d9a',
           "North East (A Division)"='#d9d989',
           "Renfrewshire & Inverclyde (K Division)"='#b15928',
           "Tayside (D Division)"='#e627ac',
           "National Average"='#000000')

#colours for overview page (national avg = black, and better/worse/none is included)
overview_cols=c(pdivcols,
                "No difference"="#BDBDBD",
                "More Positive"="#95fb71",
                "Less Positive"="#fb7171")

overview_cols=c(pdivcols,
                "No difference"="#BDBDBD",
                "More Positive"="#6baed6",
                "Less Positive"="#045a8d")


#modebar icons to remove (these are the little buttons on the plots.)
modebar_remove <- c('hoverClosestCartesian','hoverCompareCartesian','zoom2d','pan2d','toggleSpikelines','select2d','lasso2d','zoomIn2d','zoomOut2d')

#app-user inputs. (these are the choices users will get to select from)

des_factor <- df %>% group_by(year) %>% summarise(des_f=first(des_fact)) #design factors
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
               'Confidence in the Police'=getnames("POLCONF|RATPOL"),
               'Attitudes to the Police'=getnames("POLOP"),
               'Police Presence'=getnames("COMPOL|POLPATR|POLPRES"),
               'Police Contact'=getnames("QPCON"),
               'Confidence in Scottish Criminal Justice System'=getnames("DCONF"),
               'Perceptions of Crime Rates and Fear of Crime'=getnames("QS"),
               'Perceptions of Local Crime'=getnames("QACO"),
               'Perceptions of Local Community'=getnames("LCPEOP"),
               'Worries of Crime Victimisation'=getnames("QWORR"),
               'Worries of Being Harassed'=getnames("HWORR")
)

df %>% separate(variable,c("varcode","vars"),sep=":") %>%
  select(police_div,wrappedv,year,varcode) %>%
    left_join(df,.) -> df
#now overwrite variable with more user-friendly input
df$variable<-df$name_trunc

######## map data ##########
pd_latlon <- readRDS("data/pd_mapdata.RDS")

df %>% filter(year==currentyear) %>% filter(variable %in% all_vars[[1]]) %>%
  group_by(police_div, variable) %>% 
  summarise(
    percentage = first(percentage),
    wrapped_name = first(wrapped_name)
  ) %>% mutate(
    PDivName = police_div
  ) %>% ungroup %>% select(PDivName, variable, percentage) %>%
  spread(., key=variable, value=percentage) %>%
  left_join(pd_latlon@data, .) -> pd_latlon@data

############ save Rdata to the app directory ############
ungroup(df) -> df


#any thing with sample size of less than 50, remove.
df %>% mutate_at(vars(p,percentage,ci,low,high),funs(ifelse(samplesize<=50,NA,.))) -> df
source("data/overviewpage_data.R")

#update the app data.
save.image(file = "./app/.RData")

####################### RUN THE APP ############################
load("app/.RData")
shiny::runApp(appDir="./app/")


