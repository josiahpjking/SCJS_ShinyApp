
require(leaflet)
output$pdiv_map <- renderLeaflet({
  
  pal=colorNumeric(
    palette = "Reds",
    domain=pd_latlon@data$anycrime
  )
  
  leaflet(pd_latlon) %>% setView(lng = -4.183, lat = 56.817, zoom = 6) %>%
    #addProviderTiles("Stamen.TonerLite") %>% 
    addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.5,popup=~mytext,
                fillColor = ~pal(anycrime),
                highlightOptions = highlightOptions(color = "black", weight = 2,
                                                    bringToFront = TRUE)) %>%
    addLegend("topright",
              pal=pal,values=~anycrime,
              title="Percentage Crime <br> Victimisation (2014/15)",
              labFormat=labelFormat(suffix="%"))
  
  
})


