#packages needed
require(tidyr)
require(dplyr)
require(ggplot2)
require(magrittr)
require(plotly)

#load in functions
source("setup/extract_name_data.R")
source("setup/rowSums_na.R")
source("setup/rowsum_partialstringmatch_variables.R")

#####
#DATA, YEARS, DESIGN - CHANGE FOR UPDATING
#####

#these are all the years of the survey
years<-c("2008/09","2009/10","2010/11","2012/13","2014/15")
#these are all the design factors
design_factors = c(1.5, 1.5, 1.5, 1.3, 1.2)

data_files <- dir(path = "data/", pattern='SCJS*', recursive = T,full.names = T)

# READ IN DATA. 
# if you want more variables, you need to add in the string (lowercase) to identify those questions.
all_data <- bind_rows(lapply(data_files, function(x) extract_name_data(x,"serial|age|laa|hba|cjaa|gen|urb|tenure|soc|nssec|simd|wgtg|prev|qpolconf|qs2area|qsfdark|qsfnigh|qratpol|polop|compol|polpres|qworr|numcar|nummot|qaco_|lcpeop|qhworr|qswem|dconf")), .id = "year")

#check that years are in the correct order.
with(all_data, table(year,sourcefile))

#set the year variable
all_data$year<-factor(all_data$year)
levels(all_data$year)<-years

#some variables were named differently in the first year (e.g. qpolconf_01 was qpolconf_1). this will look for names which match when replacing _ with _0, and combines them.
rowsum_partialstringmatch_variables(all_data,"_","_0") -> all_data

#this tidies up all the all_dataic breaks (age, gender, police division etc)
all_data %>% mutate(
  gender = factor(qdgen,labels=c("Male","Female")),
  age = factor(ifelse(is.na(qdage),NA,
                      ifelse(qdage<16,"0-15",
                             ifelse(qdage<25,"16-24",
                                    ifelse(qdage<45,"25-44",
                                           ifelse(qdage<60,"45-60","60+")))))),	
  
  hba = factor(hba, labels=c("Ayrshire_Arran","Borders","Dumfries_Galloway","Fife","Forth_Valley","Grampian","Greater_Glasgow_Clyde","Highland","Lanarkshire","Lothian","Orkney","Shetland","Tayside","Eilean_Siar")),
  hba2pdiv = recode(hba, Ayrshire_Arran="Ayrshire (U Division)",
                    Borders="Lothians & Scottish Borders (J Division)",
                    Dumfries_Galloway="Dumfries & Galloway (V Division)",
                    Fife="Fife (P Division)",
                    Forth_Valley="Forth Valley (C Division)",
                    Grampian="North East (A Division)",
                    Greater_Glasgow_Clyde="Greater Glasgow (G Division)",
                    Highland="Highlands & Islands (N Division)",
                    Lanarkshire="Lanarkshire (Q Division)",
                    Lothian="Lothians & Scottish Borders (J Division)",
                    Orkney="Highlands & Islands (N Division)",
                    Shetland="Highlands & Islands (N Division)",
                    Tayside="Tayside (D Division)",
                    Eilean_Siar="Highlands & Islands (N Division)"
  ),
  
  police_div = factor(ifelse(laa==5|laa==14|laa==30,"Forth Valley (C Division)", ifelse(
    laa==15,"Fife (P Division)", ifelse(
      laa==9|laa==11|laa==16,"Greater Glasgow (G Division)", ifelse(
        laa==18|laa==25,"Renfrewshire & Inverclyde (K Division)", ifelse(
          laa==4|laa==31,"Argyll & West Dunbartonshire (L Division)", ifelse(
            laa==22|laa==29,"Lanarkshire (Q Division)", ifelse(
              laa==8|laa==21|laa==28,"Ayrshire (U Division)", ifelse(
                laa==12,"Edinburgh City (E Division)", ifelse(
                  laa==10|laa==19|laa==26|laa==32,"Lothians & Scottish Borders (J Division)", ifelse(
                    laa==6,"Dumfries & Galloway (V Division)", ifelse(
                      laa==3|laa==7|laa==24,"Tayside (D Division)", ifelse(
                        laa==13|laa==17|laa==23|laa==27,"Highlands & Islands (N Division)", ifelse(
                          laa==1|laa==2|laa==20,"North East (A Division)",as.character(hba2pdiv))))))))))))))),
  
  
  cjaa = factor(cjaa, labels=c("Fife & Forth Valley","Glasgow","Lanarkshire","Edinburgh & Lothians","North Strathclyde","Northern","South-West Scotland","Tayside")),
  urbrur2 = factor(ifelse(urbrur<=5,"Urban","Rural")),
  tenure = factor(tenure),
  tabnssec = factor(tabnssec),
  simd_top = factor(ifelse(simd_top==1, "15% most deprived","Remainder"))
) -> all_data

#recode tenure
all_data %>% mutate_at(vars("tenure"), funs(recode(.,'1'="Owner Occupied",'2'="Social Rented",'3'="Private Rented",'4'="Other",.default=NA_character_))) -> all_data

#recode SES group
all_data %>% mutate_at(vars("tabnssec"), funs(recode(.,'1'="Management & Prof.",'2'="Intermediate",'3'="Routine & Man.",'4'="NW & LTUE",.default=NA_character_))) -> all_data

#save another version of current data (safety measure: avoids reading in again)
all_data2 <- all_data

#####################################################################################################
#RECODE QUESTIONS
#######
#we need to recode the questions to binary 1 or 0. 

#all prev variables (prevsureycrime, prevviolent etc) need to be coded such that 2's become 0's.
all_data %>% mutate_at(vars(starts_with("prev")),funs(replace(.,.==2,0))) -> all_data


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


###########
#the qworr_01,02,03 questions need to be set to NA when there is <1 motor vehicle in the househole
#(they were asked even to people who don't have cars)
all_data %>% mutate(
  anyvehicle = ifelse(numcar>0 | nummot>0, 1, 0),
  qworr_01 = ifelse(anyvehicle==1,qworr_01,NA),
  qworr_02 = ifelse(anyvehicle==1,qworr_02,NA),
  qworr_03 = ifelse(anyvehicle==1,qworr_03,NA)
) -> all_data
############



#POLPRES: Police presence in local area is:
# 1 = not enough
# -2,-1,2,3 = rf, dk, about right, too much
#QDCRIME2: Excluding motoring offences, have you ever been convicted of a crime?
# 1 = yes
# -2,-1,2 = rf, dk, no
all_data %>% mutate_at(vars(matches("polpres|qdcrime")),funs(recode(.,'1'=1,'2'=0,'3'=0,'-2'=0,'-1'=0,.default=NA_real_))) -> all_data


#QRATPOL: Taking everything into account, how good a job do you think the police IN THIS AREA are doing?
# 1,2,3 = fair or good
# -2,-1,4,5 = rf, dk, poor
all_data %>% mutate_at(vars(matches("qratpol")),funs(recode(.,'1'=1,'2'=1,'3'=1, '4'=0,'5'=0,'-2'=0,'-1'=0,.default=NA_real_))) -> all_data


tidy_df<-all_data

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





#####################################################################################################
#CREATE TABLES OF PROPORTIONS FOR USE IN SHINY APP
######

############### Choose variables #################

# these variables are the ones which are weighted by individual weighting
tidy_df %>% 
  select(prevviolent, prevsurveycrime, polpres, qsfdark, matches("qpolconf|qs2area|qsfnigh|qratpol|polop|compol|qworr|qaco_|lcpeop|qhworr|dconf")) %>% 
  names() -> indiv_vars

# these variables are the ones which are weighted by household weighting
tidy_df %>% 
  select(prevproperty) %>%
  names() -> hhd_vars


############### Calculate Proportions, get samplesizes, get weighted samplesizes #################

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

#calculate weighted proportions (household weightings)
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
#comment out line if looking at more than one.
names(df_wide_hhd)[3:5]<-paste0("prevproperty_",names(df_wide_hhd)[3:5])

#join the household weighted and individual weighted data
df_wide <- left_join(df_wide,df_wide_hhd)


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

#tidyup
rm(all_data2, all_data, prop_data,ss_data,wss_data,data_files,df_wide,df_wide_hhd,design_factors,hhd_vars,indiv_vars,recode_questions)


##################################################################################################################
#MAKE DATA APP-READY
#################
#this will be the data for the app.
df <- pdtable

#read in the information on each variable (shorter versions etc)
variable_info<-read.csv("data/variable_information.csv")
variable_info$variable<-tolower(variable_info$variable)
#join to proportion tables
df<-left_join(df,variable_info)

#make some wrapped variables (this is for plotting - it means variables are written on two lines rather than one.)
df %>% mutate(
  wrappedv = sapply(label, FUN = function(x) {paste(strwrap(x, width = 25), collapse = "<br>")}),
  wrapped_name = sapply(name_trunc, FUN = function(x) {paste(strwrap(x, width = 25), collapse = "<br>")})
) -> df

#set variable 
df$variable<-factor(df$label)

#set year
df$year <- factor(df$year)
levels(df$year)<-years

#save the data (just in case)
saveRDS(df,"data/pdiv9.6.test.rds")

df<-readRDS("data/pdiv9.6.test.rds")

#police division colours
pdivcols=c("Argyll & West Dunbartonshire (L Division)"='#E41A1C',
           "Ayrshire (U Division)"='#377EB8',
           "Dumfries & Galloway (V Division)"='#4DAF4A',
           "Edinburgh City (E Division)"='#984EA3',
           "Fife (P Division)"='#FF7F00',
           "Forth Valley (C Division)"='#FFFF33',
           "Greater Glasgow (G Division)"='#A65628',
           "Highlands & Islands (N Division)"='#F781BF',
           "Lanarkshire (Q Division)"='#1B9E77',
           "Lothians & Scottish Borders (J Division)"='#D95F02',
           "North East (A Division)"='#7570B3',
           "Renfrewshire & Inverclyde (K Division)"='#66A61E',
           "Tayside (D Division)"='#E6AB02',
           "National Average"='#000000')

#colours for overview page (national avg = black, and better/worse/none is included)
overview_cols=c(pdivcols,
                "No difference"="#BDBDBD",
                "More Positive"="#95fb71",
                "Less Positive"="#fb7171")

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

######## map data ##########
pd_latlon <- readRDS("data/pd_mapdata.RDS")

######## national indicator data #########
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

rm(image_data,getnames)
############ save Rdata to the app directory ############



ungroup(df) -> df

#update the app data.
save.image(file = "./app/.RData")

####################### RUN THE APP ############################
#load("app/.RData")
shiny::runApp(appDir="./app/")


