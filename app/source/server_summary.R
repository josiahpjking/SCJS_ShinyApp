output$variable_info_ov<-renderUI({
  div(class="variable_info",
      variable_info_list[[input$ov_var]]
  )
})
output$variable_info_comp<-renderUI({
  div(class="variable_info",
      variable_info_list[[input$comp_var]]
  )
})



output$overview_1 <- renderUI({
  div(
    tags$p("Compared to the National Average, see which divisions had",
         tags$b(style="color:LimeGreen","More Positive (green)"),"or",tags$b(style="color:red","Less Positive (red)"),
         "responses to the SCJS for a chosen year",tags$b(style="color:grey","(grey indicates no significant difference from the National Average).")),
    tags$i("Hover the mouse over the graph to display more information (percentages, sample sizes, confidence intervals) about each data point.")
  )
})

output$overview_2 <- renderUI({
  div(
    tags$i("See how a chosen police division has performed over time, with each year showing whether that division had ",
           tags$b(style="color:LimeGreen","More Positive (green)"),"or",tags$b(style="color:red","Less Positive (red)"),
           "responses to the SCJS than the National Average",tags$b(style="color:black","(black line)"),"in that year",tags$b(style="color:grey","(grey indicates no significant difference).")),
    tags$p("Hover the mouse over the graph to display more information (percentages, sample sizes, confidence intervals) about each data point.")
  )
})


