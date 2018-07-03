#' Function to rowSum variables which have partial name matches. 
#' E.g. survey data, one sample had a question named "qworr_01", all other samples were named "qworr_1". How annoying! 
#' This will look for variables which contain @param partial and match them with variables containing @param full and then rowSum them. 
#' Note, uses rowSums_na() because otherwise rows with all NAs will be coded as 0, rather than NA.
#' @param df data
#' @param partial partial string of variable (common to both variables)
#' @param full full string (only present in the longer named variable)
#' @export
#' @examples
#' we have two variables qworr_1 and qworr_01 which are the same question.
#' rowsum_partialstringmatch_variables(data, "_", "_0") -> df
rowsum_partialstringmatch_variables<-function(df,partial,full){
  df %>% dplyr::select(contains(partial)) %>% names() -> allnames
  #these are all the variables which have an equivalent variable but with a 0
  allnames[sapply(seq_along(allnames),
                  function(x) any(grepl(gsub(partial,full,allnames[x]),allnames[-x]))
  )] -> mismatchnames
  
  for (i in gsub(partial,full,mismatchnames)){
    df[,i]<-rowSums_na(cbind(df[,i],df[,gsub("0","",i)]))
  }
  cat("these variables",mismatchnames,"have been collapsed into",gsub(partial,full,mismatchnames),sep=" ")
  return(df %>% dplyr::select(-one_of(mismatchnames)))
}
