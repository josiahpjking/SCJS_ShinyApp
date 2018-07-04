
require(leaflet)
output$pdiv_map <- renderLeaflet({
  
  df %>% filter(year==currentyear) %>% filter(grepl(input$map_var,variable)) %>%
    group_by(police_div) %>% 
    summarise(
      percentage = first(percentage),
      wrapped_name = first(wrapped_name)
    ) %>% mutate(
      PDivName = police_div,
      mytext = paste0("<b>",PDivName,"</b><br>",wrapped_name,"<br>",signif(percentage,3),"%"),
      mytitle = paste0(wrapped_name,"<br>(2014/15)")
    ) %>% left_join(pd_latlon@data, .) -> pd_latlon@data
  
  maptitle=pd_latlon@data$mytitle[1]
  indx=which(all_vars[[1]]==input$map_var)
  pal=colorNumeric(
    palette = c("Reds","Blues","Greens")[indx],
    domain=pd_latlon@data$percentage
  )
  
  leaflet(pd_latlon) %>% setView(lng = -4.183, lat = 56.817, zoom = 6) %>%
    #addProviderTiles("Stamen.TonerLite") %>% 
    addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.5,popup=~mytext,
                fillColor = ~pal(percentage),
                highlightOptions = highlightOptions(color = "black", weight = 2,
                                                    bringToFront = TRUE)) %>%
    addLegend("topright",
              pal=pal,values=~percentage,
              title=maptitle,
              labFormat=labelFormat(suffix="%"))
  
  
})


