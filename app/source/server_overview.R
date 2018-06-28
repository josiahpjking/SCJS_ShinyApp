overview_data <- reactive({
  df %>% filter(police_div=="National Average") %>% mutate(
    nat_avgp = percentage,
    nat_avgci = ci
  ) %>% select(variable,year,nat_avgp,nat_avgci) -> nat_avg
  
  left_join(df, nat_avg) %>% 
    mutate(
      p_diff=percentage-nat_avgp,
      p_diff2=ifelse(reverse_coded==1,0-p_diff,p_diff),
      p_direction=ifelse(p_diff2==0,"No difference",
                         ifelse(p_diff2>0,"Above","Below")),
      c=sqrt((ci^2)+(nat_avgci^2)),
      change=ifelse(((abs(p_diff)/100)>c)==TRUE & p_direction=="Above","Above",
                    ifelse(((abs(p_diff)/100)>c)==TRUE & p_direction=="Below","Below","No difference")),
      wrapped_name = sapply(name_trunc, FUN = function(x) {paste(strwrap(x, width = 35), collapse = "<br>")}),
      my_text = paste0("<b>",police_div,"</b><br>",year,"<br>",wrapped_name,"<br><b>",round(percentage, digits=1),"</b>% +/-",round(ci*100, digits=1),", N = ",samplesize,"<br><i><b>Click to see this division relative<br>to the national average over time.<i></b>"),
      my_text2 = paste0("<b>",year,"</b><br>",police_div,"<br>",wrapped_name,"<br><b>",round(percentage, digits=1),"</b>% +/-",round(ci*100, digits=1),", N = ",samplesize,"<br><i><b>Click to see this year<br>for all divisions.<i></b>"),
      my_text3 = paste0(wrapped_name,"<br><b>",round(percentage, digits=1),"</b>% +/-",round(ci*100, digits=1),", N = ",samplesize)
      ) %>% select(-c(p_direction,c))
  })
 

output$ov_currentplot <- renderPlotly({
  if(!(input$ov_var %in% names(all_vars))){
    overview_data() %>% filter(variable %in% input$ov_var) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div!="National Average") %>%
      mutate(
        wrappedpolice_div=sapply(gsub(" Division","",police_div), FUN = function(x) {paste(strwrap(x, width = 15), collapse = "<br>")})
      ) %>%
      plot_ly(.,
              x=~wrappedpolice_div,
              y=~p_diff,
              color=~change,
              text=~my_text,
              hoverinfo="text",
              colors=overview_cols,
              type="bar") %>% layout(margin = list(b = 100),
                                     showlegend=input$showleg,
                                     height = input$plotHeight, 
                                     autosize=TRUE,
                                     yaxis=list(title="Percentage difference from<br>National Average",ticksuffix = "%"),
                                     xaxis=list(title="",
                                                tickangle=90,
                                                categoryarray=~wrappedpolice_div[order(p_diff)], 
                                                categoryorder="array")
              ) %>% config(modeBarButtonsToRemove = modebar_remove)
  } else if(input$ov_var %in% names(all_vars)){
    overview_data() %>% filter(variable %in% all_vars[[input$ov_var]]) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div!="National Average") %>%
      mutate(
        wrappedpolice_div=sapply(gsub(" Division","",police_div), FUN = function(x) {paste(strwrap(x, width = 15), collapse = "<br>")})
      ) %>%
      group_by(wrappedpolice_div) %>%
      summarise(
        av=mean(p_diff2,na.rm=T)
      ) %>% arrange(av) %>% mutate(plotorder=seq(1:nrow(.))) -> orderwrap
    
    
    overview_data() %>% filter(variable %in% all_vars[[input$ov_var]]) %>% 
      filter(year %in% input$ov_year) %>% 
      filter(police_div!="National Average") %>%
      mutate(
        wrappedpolice_div=sapply(gsub(" Division","",police_div), FUN = function(x) {paste(strwrap(x, width = 15), collapse = "<br>")})
      ) %>% 
      plot_ly(.,
              x=~wrappedpolice_div,
              y=~p_diff,
              color=~change,
              text=~my_text,
              hoverinfo="text",
              colors=overview_cols,
              type="scatter",mode="markers",marker = list(symbol=24, size = 12)
              ) %>%
        layout(margin = list(b = 100),
               showlegend=input$showleg,
               height = input$plotHeight, 
               autosize=TRUE,
               yaxis=list(title="Percentage difference from<br>National Average",ticksuffix = "%"),
               xaxis=list(title="",
                          tickangle=90,
                          categoryarray=~orderwrap$wrappedpolice_div, 
                          categoryorder="array")
        ) %>% config(modeBarButtonsToRemove = modebar_remove)
  }
})

output$ov_trendplot <- renderPlotly({
  if(!(input$ov_var %in% names(all_vars))){
    overview_data() %>% filter(variable %in% input$ov_var) %>% 
      filter(police_div %in% input$ov_pdiv) -> bardata 
    overview_data() %>% filter(variable %in% input$ov_var) %>%
      filter(police_div %in% c("National Average")) -> linedata
    plot_ly(bardata,
            x=~year,
            y=~percentage,
            color=~change,
            colors=~overview_cols,
            text=~my_text2,
            hoverinfo="text",
            type="bar") %>%
    add_lines(data=linedata, color=~police_div, colors=overview_cols) %>%
      layout(showlegend=input$showleg,
             yaxis=list(ticksuffix = "%"),
             xaxis=list(title=""),
             height = input$plotHeight, 
             autosize=TRUE) %>% config(modeBarButtonsToRemove = modebar_remove)
  } else if(input$ov_var %in% names(all_vars)){
    
    if(input$var_select2 == "All"){
      overview_data() %>% filter(variable %in% all_vars[[input$ov_var]]) %>%
        filter(police_div %in% c("National Average",input$ov_pdiv)) %>% 
        group_by(variable) -> plotdat
      plotdat %>% filter(police_div %in% input$ov_pdiv) %>%
        plot_ly(.,
              x=~year,
              y=~p_diff,
              color=~change,
              text=~my_text2,
              hoverinfo="text",
              colors=overview_cols,
              type="scatter",mode="markers",marker = list(symbol=24, size = 12)
      ) %>%
        layout(showlegend=input$showleg, height = input$plotHeight, autosize=TRUE,
               yaxis=list(title="Percentage",ticksuffix = "%"),
               xaxis=list(title="",tickangle=90)) %>% 
        config(modeBarButtonsToRemove = modebar_remove)
      
    } else {
      pheight=(length(input$var_select2)*100)+100
      overview_data() %>% filter(variable %in% input$var_select2) %>%
        filter(police_div %in% c("National Average",input$ov_pdiv)) %>%
        mutate(
          perc1=ifelse(police_div=="National Average",percentage,NA),
          perc2=ifelse(police_div==input$ov_pdiv,percentage,NA)
        ) %>% group_by(variable) -> plotdat
      plots <- do(plotdat, 
                  p = plot_ly(., x = ~year, y=~perc1, 
                              split=~variable, 
                              type="scatter",mode="lines",
                              text=~my_text2, hoverinfo="text",
                              showlegend=T,colors=overview_cols) %>% 
                    add_trace(type="bar",
                              x=~year,
                              y=~perc2,
                              color=~change,
                              showlegend=F)
      )
      subplot(plots[["p"]], nrows = round(length(input$var_select2)/2), shareX = TRUE) %>%
        layout(height=pheight,legend=list(x=0,y=100)) %>% config(modeBarButtonsToRemove = modebar_remove) 
    }
    
    
    
    
    

  }
  
})
