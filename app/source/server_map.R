output$pdiv_map <- renderLeaflet({
  pal=colorNumeric(
    palette = c("YlOrRd","Blues","Greens")[which(all_vars[[1]]==input$map_var)],
    domain=pd_latlon@data[,input$map_var]
  )
  #render map
  leaflet(pd_latlon, options = leafletOptions(minZoom=6,maxZoom=9)) %>% 
    setView(lng = -3.5, lat = 57.817, zoom = 6) %>%
    setMaxBounds(lng1 = -8, lng2=0, lat1=54, lat2=62) %>%
    addProviderTiles(providers$Stamen.TonerLines) %>%
    addProviderTiles(providers$Stamen.TonerLabels) %>%
    addPolygons(fillColor = ~pal(pd_latlon@data[,input$map_var]),
                color = "#444444", weight = 1, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.8, 
                popup = ~paste0("<b>",pd_latlon@data$PDivName,"</b><br>", paste(strwrap(input$map_var, width = 25), collapse = "<br>"),"<br>",signif(pd_latlon@data[,input$map_var],3),"%"),
                #popup=~mapdata$mytext[mapdata$variable %in% input$map_var],
                highlightOptions = highlightOptions(color = "black", weight = 2,
                                                    bringToFront = TRUE)) %>%
    addLegend("topright",
              pal=pal,values=~pd_latlon@data[,input$map_var],
              title=paste(strwrap(input$map_var, width = 25), collapse = "<br>"),
              labFormat=labelFormat(suffix="%"))
})