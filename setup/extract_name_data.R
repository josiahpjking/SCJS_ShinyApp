#' Function to extract all (and only) variables from a dataframe which contain a string.
#' Give it a data frame, and a string (or strings separated by "|") and it will extrace all and only variables which match those strings. 
#' Note - this is not computationally more efficient (it requires reading the entire data, then subsetting). It is intended as a mental efficiency :)
#' @param df path to data file
#' @param var_string string or strings (sep by |) to match variables to. ALL LOWER CASE.
#' @param readfun function to read the data. defaults read.csv
#' @export
#' @examples
#' new_df <- extract_name_data("/somedata.csv","qswemwbs|qworr")
#' new_df <- extract_name_data("/somedata.rds","qswemwbs",readfun=readRDS())
extract_name_data<-function(df,var_string,readfun=read.csv()){
  alldat = readfun(df)
  names(alldat)<-tolower(names(alldat))
  var_data = alldat[,grepl(var_string,names(alldat))]
  var_data$sourcefile = df
  return(var_data)
}