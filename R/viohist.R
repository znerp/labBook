
#' Plot a viohist
#'
#' @param x
#' @param breaks
#' @param at
#' @param wex
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
viohist <- function(x,
                    breaks = "Sturges",
                    at  = 1,
                    wex = 1,
                    ...) {


  # Get number of detectable measurements and remove NAs
  x <- x[!is.na(x)]
  n <- length(x)

  # First fit histogram
  hist_data <- hist(x      = x,
                    breaks = breaks,
                    plot   = FALSE)

  # Plot a rectangle for each polygon
  for(x in 1:length(hist_data$counts)){

    rect(xleft   = at - (hist_data$counts[x]/n)/2,
         xright  = at + (hist_data$counts[x]/n)/2,
         ybottom = hist_data$breaks[x],
         ytop    = hist_data$breaks[x+1],
         ...)

  }

}



