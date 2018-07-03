#require(tidyr)
#require(dplyr)
#require(ggplot2)
#require(magrittr)
#require(plotly)

#source("extract_name_data.R")
#source("rowSums_na.R")
#source("rowsum_partialstringmatch_variables.R")

#get working dir, list data files. 
#data_files <- dir(path = "data/", pattern='SCJS*', recursive = T,full.names = T)

create_pdiv_data<-function(data_files){
  #load in demographic variables for each year.
  demograph<-bind_rows(lapply(data_files, function(x) 
    extract_name_data(x,"serial|age|laa|cjaa|gen|urb|tenure|soc|nssec|simd|wgtg|prev|qpolconf|qs2area|qsfdark|qsfnigh|qratpol|polop|compol|polpres|qworr|qaco_|lcpeop|qhworr|qswem|dconf")), .id = "year")
  
  #some variables were named differently in the first year (e.g. qpolconf_01 was qpolconf_1). this will look for names which match when replacing _ with _0, and combines them.
  rowsum_partialstringmatch_variables(demograph,"_","_0") -> demograph
  
  #this tidies up all the demographic breaks (age, gender, police division etc)
  demograph %>% mutate(
    gender = factor(qdgen,labels=c("Male","Female")),
    age = factor(ifelse(is.na(qdage),NA,
                        ifelse(qdage<16,"0-15",
                               ifelse(qdage<25,"16-24",
                                      ifelse(qdage<45,"25-44",
                                             ifelse(qdage<60,"45-60","60+")))))),	
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
                            laa==1|laa==2|laa==20,"North East (A Division)","NA")))))))))))))),
    cjaa = factor(cjaa, labels=c("Fife & Forth Valley","Glasgow","Lanarkshire","Edinburgh & Lothians","North Strathclyde","Northern","South-West Scotland","Tayside")),
    urbrur2 = factor(ifelse(urbrur<=5,"Urban","Rural")),
    tenure = factor(tenure),
    tabnssec = factor(tabnssec),
    simd_top = factor(ifelse(simd_top==1, "15% most deprived","Remainder"))
  ) -> demograph
  
  #recode tenure
  demograph %>% mutate_at(vars("tenure"), funs(recode(.,'1'="Owner Occupied",'2'="Social Rented",'3'="Private Rented",'4'="Other",.default=NA_character_))) -> demograph
  
  #recode SES group
  demograph %>% mutate_at(vars("tabnssec"), funs(recode(.,'1'="Management & Prof.",'2'="Intermediate",'3'="Routine & Man.",'4'="NW & LTUE",.default=NA_character_))) -> demograph
  #save another version of current data (avoids reading in again)
  demograph2 <- demograph
  
  #######
  #RECODE QUESTIONS
  #######
  #we need to recode the questions to binary 1 or 0. 
  
  #all prev variables (prevsureycrime, prevviolent etc) need to be coded such that 2's become 0's.
  demograph %>% mutate_at(vars(starts_with("prev")),funs(replace(.,.==2,0))) -> demograph
  
  
  #QS2AREA: Perceived change in crime rate in local area in last two years
  #QS2AREAS: Perceived change in crime rate in Scotland in last two years
  # 3,4,5 = same or less
  # -2,-1,1,2 = rf, dk, or more
  demograph %>% mutate_at(vars(c(matches("qs2area"))),funs(recode(.,'1'=0,'2'=0,'3'=1,'4'=1,'5'=1,'-2'=0,'-1'=0,.default=NA_real_))) -> demograph
  
  
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
  demograph %>% mutate_at(vars(c(matches(recode_questions))),funs(recode(.,'1'=1,'2'=1,'3'=0,'4'=0,'5'=0,'-2'=0,'-1'=0,.default=NA_real_))) -> demograph
  
  
  #POLPRES: Police presence in local area is:
  # 1 = not enough
  # -2,-1,2,3 = rf, dk, about right, too much
  #QDCRIME2: Excluding motoring offences, have you ever been convicted of a crime?
  # 1 = yes
  # -2,-1,2 = rf, dk, no
  demograph %>% mutate_at(vars(matches("polpres|qdcrime")),funs(recode(.,'1'=1,'2'=0,'3'=0,'-2'=0,'-1'=0,.default=NA_real_))) -> demograph
  
  
  #QRATPOL: Taking everything into account, how good a job do you think the police IN THIS AREA are doing?
  # 1,2,3 = fair or good
  # -2,-1,4,5 = rf, dk, poor
  demograph %>% mutate_at(vars(matches("qratpol")),funs(recode(.,'1'=1,'2'=1,'3'=1, '4'=0,'5'=0,'-2'=0,'-1'=0,.default=NA_real_))) -> demograph
  
  
  tidy_df<-demograph
  
  
  
  #######
  ##check variables are present across years.
  #######
  tidy_df %>% group_by(year) %>% summarise_all(
    funs(sum(!is.na(.)))) %>%
    gather(., key="variable",value="number_obs",-year) -> year_counts
  
  #this will show the number of non NA observations across years for variables matching the string
  year_counts %>% filter(grepl("qsfdark",variable))
  
  #this summarises whether a variable has at least 1 non NA observation for each year.
  year_counts %>% group_by(variable) %>% 
    summarise(
      no_na = !(any(number_obs==0))
    ) -> variable_across_years
  
  
  
  
  
  ##########
  ######
  #CREATE TABLES OF PROPORTIONS FOR USE IN SHINY APP
  ######
  ##########
  
  
  ######
  #select variables
  ######
  # these variables are the ones which are weighted by individual
  tidy_df %>% 
    select(prevviolent, prevsurveycrime, polpres, qsfdark, matches("qpolconf|qs2area|qsfnigh|qratpol|polop|compol|qworr|qaco_|lcpeop|qhworr|dconf")) %>% 
    names() -> indiv_vars
  
  # these variables are the ones which are weighted by household
  tidy_df %>% 
    select(prevproperty) %>%
    names() -> hhd_vars
  
  
  ######
  #calculate proportions
  ######
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
  
  #join the household and individual data
  df_wide <- left_join(df_wide,df_wide_hhd)
  
  
  ######
  #RESHAPE
  ######
  
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
  
  
  ######
  #CONFIDENCE INTERVALS etc.
  ######
  
  #add design effects, and calculate CIs
  design_effects <- data.frame(year=as.character(c(1,2,3,4,5,6)),des_effect=c(1.5,1.5,1.5,1.3,1.2,1.34))
  
  left_join(pdtable, design_effects) %>%
    mutate(
      percentage=p*100,
      count=p*samplesize,
      ci = (sqrt((p*(1-p))/samplesize))*1.96*des_effect,
      low = percentage-(ci*100),
      high = percentage+(ci*100)
    ) -> pdiv_tables
  
  #tidyup
  rm(demograph2, demograph, prop_data,ss_data,wss_data, df_wide,df_wide_hhd,pdtable,design_effects,hhd_vars,indiv_vars,recode_questions)
  
  
  
  #set police_div
  return(pdiv_tables)
}

