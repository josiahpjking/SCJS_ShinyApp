#' rowSums with na.rm = TRUE except for when all cols = NAs
#' equivalent to sum functionality in SAS (I think)
#' @param x an array of two or more dimensions, containing numeric, complex, integer or logical values, or a numeric data frame. For .colSums() etc, a numeric, integer or logical matrix (or vector of length m * n).
#' @param dims integer: Which dimensions are regarded as 'rows' or 'columns' to sum over. For row*, the sum or mean is over dimensions dims+1, ...; for col* it is over dimensions 1:dims.
#' @export
#' @examples
#' x <- cbind(x1 = c(NA,2:5), x2 = c(NA,7:9,NA))
#' rowSums_na(x)
#' ## as opposed to 
#' rowSums(x)
#' 
#' x <- array(2, rep(3, 3))
#' x[1,,]<-NA
#' x[3,3,3]<-NA
#' rowSums_na(x)
#' ## as opposed to 
#' rowSums(x)
rowSums_na<-function(x,dims=1L){
  #borrowed from rowSums checks
  if (is.data.frame(x)) 
    x <- as.matrix(x)
  if (!is.array(x) || length(dn <- dim(x)) < 2L) 
    stop("'x' must be an array of at least two dimensions")
  if (dims < 1L || dims > length(dn) - 1L) 
    stop("invalid 'dims'")
  p <- prod(dn[-(id <- seq_len(dims))])
  dn <- dn[id]
  
  #sum NAs across rows
  n <- rowSums(is.na(x))
  #sum all values, NAs reduced to 0
  rs <- rowSums(x,na.rm=T)
  #if nr NAs == nr Cols, then NA, else rowSum.
  out <- sapply(seq_len(dn), function(y) ifelse(n[y]==p, NA, rs[y]))
  out
}