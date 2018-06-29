div(id="tables",
  div(class="tvar",
      selectizeInput("table_var",label="Choose Variables",choices = c("Select All", all_vars), selected=c(all_vars[[1]][1]), multiple=T, options=list(maxItems=length(unlist(all_vars)))),
      selectizeInput("table_pdiv",label="Choose Police Divisions",choices=c("Select All", pdivis), selected="National Average", options = list(maxItems = length(pdivis))),
      downloadButton("downloadData", "Download"),
      actionButton("reset_tables", "Reset")
  ),
  
  tabsetPanel(selected="perc",
              tabPanel(title="Percentages",value="perc",
                       tableOutput('table_p')
              ),
              tabPanel(title="Sample Sizes",value="samps",
                       tableOutput('table_ss')
              )
  )
)