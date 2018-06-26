
#basic table data
table_data<-reactive({
  df %>% filter(police_div %in% input$table_pdiv & variable %in% input$table_var) %>%
    mutate(
      Police_Division=police_div,
      Percentage=percentage, 
      SampleSize=samplesize,
      Variable=variable
    ) %>% data.frame(.)
})

#data for downloading (no testing. )
table_downloaddata<-reactive({
  table_data() %>%
    select(year,Variable,Police_Division,Percentage,SampleSize) %>%
    mutate(
      Percentage=round(Percentage,digits=1)
    ) %>%
    reshape(timevar="year",idvar=c("Police_Division","Variable"),direction="wide") %>% 
    arrange(Variable)
})

#######
#Table of percentages with Stats Testing for latest vs. previous, and latest vs. first.
#######
output$table_p <- renderTable({
  table_data() %>% select(year,Variable,Police_Division,Percentage,SampleSize,ci) %>%
    reshape(timevar="year",idvar=c("Police_Division","Variable"),direction="wide") -> td
  
  td$diff_prev<-sapply(1:nrow(td), function(x) abs(td[x,paste0("Percentage.",currentyear)]-td[x,paste0("Percentage.",prevyear)])/100>sqrt((td[x,paste0("ci.",currentyear)]^2)+(td[x,paste0("ci.",prevyear)]^2)))
  
  td$diff_first<-sapply(1:nrow(td), function(x) abs(td[x,paste0("Percentage.",currentyear)]-td[x,paste0("Percentage.",firstyear)])/100>sqrt((td[x,paste0("ci.",currentyear)]^2)+(td[x,paste0("ci.",firstyear)]^2)))
  
  td$Change_from_Previous<-ifelse(td$diff_prev==TRUE,"Yes","No")
  td$Change_from_First<-ifelse(td$diff_first==TRUE,"Yes","No")
  
  td %>% select(-matches("ci|SampleSize|diff")) %>%
    rename_at(vars(starts_with("Percentage")), funs(gsub("Percentage.","",.))) %>%
    arrange(Police_Division)
},digits=1)



#######
#Table of sample sizes.
#######
output$table_ss <- renderTable({
  table_data() %>% select(year,Variable,Police_Division,SampleSize) %>%
    reshape(timevar="year",idvar=c("Police_Division","Variable"),direction="wide") %>% 
    rename_at(vars(starts_with("SampleSize")), funs(gsub("SampleSize.","",.))) %>% 
    arrange(Police_Division)
})


#######
#Table download output
#######
output$downloadData <- downloadHandler(
  filename = "scjs_download.csv",
  content = function(file){
    write.csv(table_downloaddata(), file, row.names = FALSE)
  }
)
