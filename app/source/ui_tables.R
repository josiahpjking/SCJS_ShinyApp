div(id="tables",
  div(class="tvar",
      selectizeInput("table_var",label="Choose Section of Survey",choices = c("Select All", names(all_vars)), selected=names(all_vars)[1], multiple=T, options=list(maxItems=length(names(all_vars)))),
      selectizeInput("table_pdiv",label="Choose Police Divisions",choices=c("Select All", pdivis), selected="National Average", options = list(maxItems = length(pdivis))),
      downloadButton("downloadData", "Download"),
      actionButton("reset_tables", "Reset")
  ),
  
  tabsetPanel(selected="table_perc",
              tabPanel(title="Percentages",value="table_perc",
                       tableOutput('table_p')
              ),
              tabPanel(title="Sample Sizes",value="table_samps",
                       tableOutput('table_ss')
              )
  )
)