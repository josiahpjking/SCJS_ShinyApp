compare_data <- reactive({
  #data for plotting
  df %>% filter(variable %in% (all_vars[[input$survey_section_compare]]) & breaks %in% input$parea1 & year %in% input$year1) -> conf_p1_data
  #data for plot 2
  df %>% filter(variable %in% (all_vars[[input$survey_section_compare]]) & breaks %in% input$parea2 & year %in% input$year2) -> conf_p2_data
  
  bind_rows(conf_p1_data,conf_p2_data) %>% filter((breaks==input$parea1 & year==input$year1) | (breaks==input$parea2 & year==input$year2)) -> conf_temp_data
  
  conf_temp_data %>% 
    group_by(variable) %>% 
    summarise(var_occurrence=sum(as.numeric(value))) %>% 
    filter(var_occurrence==2) %>% pull(variable) -> valid_variables
  
  #calculate whether signif, output data
  left_join(conf_temp_data %>% 
              filter(variable %in% valid_variables), 
            conf_temp_data %>%
              select(year,variable,p,ci,samplesize,des_effect,breaks,reverse_coded) %>%
              filter(variable %in% valid_variables) %>%
              group_by(variable) %>% 
              summarise(
                p_diff=abs(diff(p)),
                c=sqrt(sum(ci^2)),
                p_signif=p_diff>c,
                rev_coded=first(reverse_coded),
                better_break=ifelse(p_signif==TRUE & rev_coded=="1",breaks[which(p==min(p))],ifelse(p_signif==TRUE & rev_coded=="0", breaks[which(p==max(p))],"neither")),
                better_p=ifelse(p_signif==TRUE & rev_coded==1, min(p),
                                ifelse(p_signif==TRUE & rev_coded==0, max(p),NA))
                ) %>%
                  select(variable,p_signif,better_break,better_p)
  ) %>% 
    mutate(
      change = ifelse(p_signif==FALSE,"Same",
                         ifelse(breaks==better_break & p==better_p,"Better","Worse"))
    ) %>% 
    select(year,variable,wrappedv,wrapped_name,breaks,percentage,change,samplesize,ci)
})
  
output$compar_plot <- renderPlotly({
  compare_data() %>% filter(breaks %in% input$parea1 & year %in% input$year1) %>%
    plot_ly(., y=~wrapped_name, 
            x=~percentage, 
            text=~paste0(round(percentage,digits=1),"%"), 
            hoverinfo="y", 
            textposition="auto", 
            type = "bar", 
            color=~change, 
            colors = c("Same"="#BDBDBD","Better"="#82FA58","Worse"="#FA5858")
    ) %>% 
    layout(
      yaxis=list(title="", 
                 categoryarray=~rev(wrapped_name),categoryorder="array",
                 tickfont=list(family="Arial, sans-serif", size=10)), 
      xaxis=list(range=c(0,100),ticksuffix = "%")
    ) -> p1
  
  compare_data() %>% filter(breaks %in% input$parea2 & year %in% input$year2) %>% 
    plot_ly(., y=~wrapped_name, 
            x=~percentage, 
            text=~paste0(round(percentage,digits=1),"%"), 
            hoverinfo="y", 
            textposition="auto", 
            type = "bar",
            color=~change, 
            colors = c("Same"="#BDBDBD","Better"="#82FA58","Worse"="#FA5858")
    ) %>% 
    layout(
      yaxis=list(title="",
                 categoryarray=~rev(wrapped_name),categoryorder="array",
                 showticklabels = FALSE),
      xaxis=list(range=c(0,100),ticksuffix = "%")
    ) -> p2
  
  subplot(p1,p2) %>% 
    layout(showlegend=FALSE,
           margin=list(l=100),
           autosize=TRUE
    ) %>% config(displayModeBar=F)
})
