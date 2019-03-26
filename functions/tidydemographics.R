tidydemographics<-function(df){
  df %>% mutate(
    gender = factor(qdgen,labels=c("Male","Female")),
    age = factor(ifelse(is.na(qdage),NA,
                        ifelse(qdage<0,NA,
                        ifelse(qdage<16,"0-15",
                               ifelse(qdage<25,"16-24",
                                      ifelse(qdage<45,"25-44",
                                             ifelse(qdage<60,"45-60","60+"))))))),	
    
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
    
    
    #cjaa = factor(cjaa, labels=c("Fife & Forth Valley","Glasgow","Lanarkshire","Edinburgh & Lothians","North Strathclyde","Northern","South-West Scotland","Tayside")),
    urbrur2 = factor(ifelse(urbrur<=5,"Urban","Rural")),
    tenure = factor(tenure),
    tabnssec = factor(tabnssec),
    simd_top = factor(ifelse(simd_top==1, "15% most deprived","Remainder"))
  )
}