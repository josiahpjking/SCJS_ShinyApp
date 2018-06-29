output$variable_info<-renderUI({
  div(id="variable_info",
      variable_info_list[[input$ov_var]],
      tags$p("Hover the mouse over the graph to display more information (percentages, sample sizes, confidence intervals) about each data point.")
  )
})

output$overview_1 <- renderUI({
  tags$p("See which divisions performed",
         tags$b(style="color:DodgerBlue","better (blue)"),"or",tags$b(style="color:Tomato","worse (orange)"),
         "than the National Average for a chosen year",tags$b(style="color:grey","(grey indicates no significant difference)."))
})

output$overview_2 <- renderUI({
  tags$p("See how a chosen police division has performed over time, with each year showing whether that division performed ",
         tags$b(style="color:DodgerBlue","better (blue)"),"or",tags$b(style="color:Tomato","worse (orange)"),
         "than the National Average",tags$b(style="color:black","(black line)"),"in that year",tags$b(style="color:grey","(grey indicates no significant difference)."))
})


