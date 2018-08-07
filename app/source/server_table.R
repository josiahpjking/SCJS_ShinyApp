#####
#DATA - basic table data. filter by police division and variable selection. set as class(data.frame) for reshaping
#####
table_data<-reactive({
  df %>% filter(police_div %in% input$table_pdiv & variable %in% unlist(all_vars[input$table_var])) %>%
    mutate(
      Police_Division=police_div,
      Percentage=percentage, 
      SampleSize=samplesize,
      Variable=variable
    ) %>% data.frame(.)
})

#####
#DOWNLOAD DATA - no testing, both percentages and samplesizes
#####
table_downloaddata<-reactive({
  table_data() %>%
    select(year,Variable,Police_Division,Percentage,SampleSize) %>%
    mutate(
      Percentage=round(Percentage,digits=1)
    ) %>%
    reshape(timevar="year",idvar=c("Police_Division","Variable"),direction="wide") %>% 
    arrange(Variable)
})


#####
#PERCENTAGE TABLE - with stats testing between selected years.
#####
output$table_p <- renderTable({
  #this is the data, reshaped.
  table_data() %>% select(year,Variable,Police_Division,Percentage,SampleSize,ci) %>%
    reshape(timevar="year",idvar=c("Police_Division","Variable"),direction="wide") -> td
  
  #this tests difference between years (it looks messy because i condensed it all into a sapply :/ )
  td$diff<-sapply(1:nrow(td), function(x) abs(td[x,paste0("Percentage.",input$table_year[1])]-td[x,paste0("Percentage.",input$table_year[2])])/100>sqrt((td[x,paste0("ci.",input$table_year[1])]^2)+(td[x,paste0("ci.",input$table_year[2])]^2)))
  #change column = if signif YES, otherwise NO
  td$change<-ifelse(td$diff==TRUE,"Yes","No")
  #rename change column to indicate which years
  names(td)[grepl("change",names(td))]=paste0(input$table_year[1]," change from ",input$table_year[2])
  
  #rename, arrange
  td %>% select(-matches("ci|SampleSize|diff")) %>%
    rename_at(vars(starts_with("Percentage")), funs(gsub("Percentage.","",.))) %>%
    arrange(Police_Division)
  },
digits=1)


#####
#SAMPLESIZE TABLE
#####
output$table_ss <- renderTable({
  table_data() %>% select(year,Variable,Police_Division,SampleSize) %>%
    reshape(timevar="year",idvar=c("Police_Division","Variable"),direction="wide") %>% 
    rename_at(vars(starts_with("SampleSize")), funs(gsub("SampleSize.","",.))) %>% 
    arrange(Police_Division)
})


#######
#Table download button
#######
output$downloadData <- downloadHandler(
  filename = "scjs_download.csv",
  content = function(file){
    write.csv(table_downloaddata(), file, row.names = FALSE)
  }
)

#####
#RESET TABLE BUTTON
#####
observeEvent(input$reset_tables, {
  updateSelectizeInput(session, "table_pdiv", selected = "National Average")
  updateSelectizeInput(session, "table_var", selected = names(all_vars)[1])
})

#####
#SELECT ALL in table - both for division and variable. 
#####
observe({
  if("Select All" %in% input$table_pdiv){
    updateSelectizeInput(session, "table_pdiv", selected = pdivis)
  }
  if("Select All" %in% input$table_var){
    updateSelectizeInput(session, "table_var", selected = names(all_vars)[1])
  }
})


