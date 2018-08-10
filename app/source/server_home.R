
######## national indicator data #########
# this is just the data which is used to assess whether the national indicators have gone up or down since last survey year.
df %>% filter(police_div=="National Average", 
              year %in% c(currentyear,prevyear),
              variable %in% all_vars[[1]]) %>%
  group_by(variable) %>%
  summarise(
    current_percentage = percentage[which(year==currentyear)],
    prev_percentage = round(percentage[which(year==prevyear)],1),
    current_ci = ci[which(year==currentyear)],
    p_diff=abs(diff(p)),
    c=sqrt(sum(ci^2)),
    p_signif=p_diff>c,
    rev_coded=first(reverse_coded),
    thisyear = ifelse(p_signif==TRUE & year[which(p==min(p))]==currentyear, "down",
                      ifelse(p_signif==TRUE & year[which(p==min(p))]!=currentyear, "up",
                             "same")),
    thisyear_direction = factor(ifelse(rev_coded==1 & thisyear=="up","down",
                          ifelse(rev_coded==1 & thisyear=="down","up", thisyear))),
    text1 = as.character(fct_recode(thisyear_direction, "IMPROVING"="up","WORSENING"="down","MAINTAINING"="same")),
    text2 = paste0(round(current_percentage,1),"% ",text1)
  ) %>% select(variable, current_percentage, current_ci, thisyear, text1, text2) -> image_data

#filter to each NI
image_data %>% filter(grepl("Confident",variable)) -> ni_conf_data
image_data %>% filter(grepl("Victim",variable)) -> ni_crime_data
image_data %>% filter(grepl("Perceived",variable)) -> ni_perc_data



###this is a little extra bit. hover over the infograpics to see a plot :)
df %>% filter(police_div=="National Average", 
              variable %in% all_vars[[1]]) -> plot_ni_data

output$conf_plot<-renderPlot({
  ggplot(plot_ni_data %>% filter(grepl("Confident",variable)), aes(x=year,y=percentage, group=1))+
  geom_bar(stat="identity")+theme_void()
})
output$crime_plot<-renderPlot({
  ggplot(plot_ni_data %>% filter(grepl("Victim",variable)), aes(x=year,y=percentage, group=1))+
  geom_bar(stat="identity")+theme_void()
})
output$perc_plot<-renderPlot({
  ggplot(plot_ni_data %>% filter(grepl("Perceived",variable)), aes(x=year,y=percentage, group=1))+
  geom_bar(stat="identity")+theme_void()
})


########
# NATIONAL INDICATOR GRAPHICS
########
# these are the divs which set up the indicator graphics. It uses the above to set text, and background graphic (arrows etc.)
output$natind1<-renderUI({
  div(
      tags$h5("Crime Victimisation Rate"),
      div(class="ni",
          div(class="ni-icon",tags$img(src=paste0(ni_crime_data[,4],ni_crime_data[,5],".png"))),
          tags$h6(ni_crime_data[,6]),
          div(class="ni-plot",plotOutput("crime_plot",height="60px"))
      )
  )
})
  
output$natind2<-renderUI({
  div(
      tags$h5("Confident in Access to Justice"),
      div(class="ni",
          div(class="ni-icon",tags$img(src=paste0(ni_conf_data[,4],ni_conf_data[,5],".png"))),
          tags$h6(ni_conf_data[,6]),
          div(class="ni-plot",plotOutput("conf_plot",height="60px"))
      )
  )
})

output$natind3<-renderUI({
  div(
      tags$h5("Believed Local Crime Rate has Stayed the Same or Reduced"),
      div(class="ni",
          div(class="ni-icon",tags$img(src=paste0(ni_perc_data[,4],ni_perc_data[,5],".png"))),
          tags$h6(ni_perc_data[,6]),
          div(class="ni-plot",plotOutput("perc_plot",height="60px"))
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



