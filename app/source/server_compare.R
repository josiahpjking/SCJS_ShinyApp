compare_data <- reactive({
  #data for plotting
  df %>% filter(variable %in% (all_vars[[input$comp_var]]) & police_div %in% input$comp_pdiv1 & year %in% input$comp_year1) -> conf_p1_data
  #data for plot 2
  df %>% filter(variable %in% (all_vars[[input$comp_var]]) & police_div %in% input$comp_pdiv2 & year %in% input$comp_year2) -> conf_p2_data
  
  bind_rows(conf_p1_data,conf_p2_data) %>% 
    filter((police_div==input$comp_pdiv1 & year==input$comp_year1) | (police_div==input$comp_pdiv2 & year==input$comp_year2)) %>% 
    mutate(
      wrapped_name = sapply(name_trunc, FUN = function(x) {paste(strwrap(x, width = 20), collapse = "<br>")})
    ) -> conf_temp_data
  
  conf_temp_data %>% 
    group_by(variable) %>% 
    summarise(var_occurrence=sum(!is.na(p))) %>% 
    filter(var_occurrence==2) %>% pull(variable) -> valid_variables
  
  #calculate whether signif, output data
  left_join(conf_temp_data %>% 
              filter(variable %in% valid_variables), 
            conf_temp_data %>%
              select(year,variable,p,ci,samplesize,des_effect,police_div,reverse_coded) %>%
              filter(variable %in% valid_variables) %>%
              group_by(variable) %>% 
              summarise(
                p_diff=abs(diff(p)),
                c=sqrt(sum(ci^2)),
                p_signif=p_diff>c,
                rev_coded=first(reverse_coded),
                better_break=ifelse(p_signif==TRUE & rev_coded=="1",police_div[which(p==min(p))],ifelse(p_signif==TRUE & rev_coded=="0", police_div[which(p==max(p))],"neither")),
                better_p=ifelse(p_signif==TRUE & rev_coded==1, min(p),
                                ifelse(p_signif==TRUE & rev_coded==0, max(p),NA))
                ) %>%
                  select(variable,p_signif,better_break,better_p)
  ) %>% 
    mutate(
      change = ifelse(p_signif==FALSE,"No difference",
                         ifelse(police_div==better_break & p==better_p,"More Positive","Less Positive"))
    ) %>% 
    select(year,variable,wrappedv,wrapped_name,police_div,percentage,change,samplesize,ci)
})
  
output$compar_plot <- renderPlotly({

  compare_data() %>% nrow()/2 -> visible_vars
  
  compare_data() %>% filter(police_div %in% input$comp_pdiv1 & year %in% input$comp_year1) %>% 
    plot_ly(., y=~wrapped_name, 
            x=~percentage, 
            text=~paste0(round(percentage,digits=1),"%"), 
            hoverinfo="y", 
            textposition="auto", 
            type = "bar", 
            color=~change, 
            legendgroup=~change, 
            showlegend=F,
            colors = overview_cols,
            height=(visible_vars*110)+100
    ) %>% 
    layout(
      yaxis=list(title="",
                 tickfont=list(family="Arial, sans-serif", size=10),
                 showticklabels = FALSE,
                 categoryarray=~rev(wrapped_name),categoryorder="array"), 
      xaxis=list(range=c(0,100),ticksuffix = "%",showticklabels = FALSE)
    ) %>% add_annotations(x = 0, y = ~wrapped_name,
                      xanchor = 'right', text = ~wrapped_name,
                      font = list(family = 'Sans', size = 10),
                      showarrow = FALSE, align = 'right') -> p1
  
  compare_data() %>% filter(police_div %in% input$comp_pdiv2 & year %in% input$comp_year2) %>% 
    plot_ly(., y=~wrapped_name, 
            x=~percentage, 
            text=~paste0(round(percentage,digits=1),"%"), 
            hoverinfo="y", 
            textposition="auto", 
            type = "bar",
            color=~change, 
            showlegend=FALSE,
            colors = overview_cols,
            height=(visible_vars*110)+100
    ) %>% 
    layout(
      yaxis=list(title="",
                 categoryarray=~rev(wrapped_name),categoryorder="array",
                 showticklabels = FALSE),
      xaxis=list(range=c(0,100),ticksuffix = "%",showticklabels = FALSE)
    ) -> p2
  
  tryCatch({
    subplot(p1,p2) %>% 
      layout(showlegend=T,
             margin=list(l=120),
             autosize=TRUE
      ) %>% config(modeBarButtonsToRemove = modebar_remove)
  },
  error=function(cond){
    plot_ly() %>% layout(title="<br>Variables not present <br> in both years <br><br>Please choose another year",
                         yaxis=list(showticklabels=FALSE,showgrid = FALSE,zeroline = FALSE),
                         xaxis=list(showticklabels=FALSE,showgrid = FALSE,zeroline = FALSE),
                         paper_bgcolor="transparent", plot_bgcolor="transparent") %>%
      config(displayModeBar=F)
  }
  )
})
