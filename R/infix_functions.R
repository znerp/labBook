
#' Retrieve variable from list
#'
#' @param a
#' @param b
#'
#' @return
#' @export
#'
#' @examples
`%$%` <- function(a, b){
  b <- deparse(substitute(b))
  output <- NULL
  for(x in 1:length(a)){
    output <- rbind(output, a[[x]][[which(names(a[[x]]) == b)]])
  }
  output
}

