
########
# NATIONAL INDICATOR GRAPHICS
########
# these are the divs which set up the indicator graphics. in loader.R script, it sets an object for each indicator which sets the image to source, and the text etc.
output$natind1<-renderUI({
  div(class="ind",
      tags$h5("Crime Victimisation Rate"),
      div(class="ni",
          tags$img(src=paste0(ni_crime_data[,4],".png")),
          tags$h6(paste0(round(ni_crime_data[,2],1),"%"))
      )
  )
})
  
output$natind2<-renderUI({
  div(class="ind",
      tags$h5("Confident in access to Justice"),
      div(class="ni",
          tags$img(src=paste0(ni_conf_data[,4],".png")),
          tags$h6(paste0(round(ni_conf_data[,2],1),"%"))
      )
  )
})

output$natind3<-renderUI({
  div(class="ind",
      tags$h5("Perceived Same or Less Local Crime"),
      div(class="ni",
          tags$img(src=paste0(ni_perc_data[,4],".png")),
          tags$h6(paste0(round(ni_perc_data[,2],1),"%"))
      )
  )
})


########
#HOME SCREEN BUTTONS
########
#These match with the actionLinks in ui_home.R and update the current tab when clicked. 
observeEvent(input$link_divisions,{
  newvalue <- "main_divisions"
  updateTabsetPanel(session, "main", newvalue)
})
observeEvent(input$link_trends,{
  newvalue <- "main_trends"
  updateTabsetPanel(session, "main", newvalue)
})
observeEvent(input$link_compare,{
  newvalue <- "main_compare"
  updateTabsetPanel(session, "main", newvalue)
})
observeEvent(input$link_tables,{
  newvalue <- "main_tables"
  updateTabsetPanel(session, "main", newvalue)
})



