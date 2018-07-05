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