

#' Write a simplified csv file
#'
#' @param x
#' @param file
#'
#' @return
#' @export
#'
#' @examples
write.simple.csv <- function(x, file){

  write.table(x    = x,
              file = file,
              row.names = FALSE,
              col.names = FALSE,
              sep = ",")

}


