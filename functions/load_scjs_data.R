#' #this is basically a data loading function. it picks up the file extension, and reads in the data appropriately.
#' Give it a filepath, and it will either read in using read.csv or read.spss depending on file extension.
#' @param filename path to file
#' @export
#' @examples
#' new_df <- load_scjs_data("data/mydata.sav")
load_scjs_data<-function(filename){
  if(grepl(".sav",filename)){
    df = read.spss(filename, to.data.frame=T, use.value.labels = F, use.missings = F)
    names(df) = tolower(names(df))
    return(df)
  } else if(grepl(".csv",filename)){
    df = read.csv(filename)
    names(df) = tolower(names(df))
    return(df)
  } else {
    return("Sorry, File type not recognised. Should be .sav or .csv")
  }
}
