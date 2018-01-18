

#' Plot stacked histogram
#'
#' @param data
#' @param xlab
#' @param main
#' @param breaks
#' @param hist_cols
#' @param border
#' @param legend_names
#' @param legend_inset
#'
#' @return
#' @export
#'
hist_stacked <- function(data,
                         breaks    = "Sturges",
                         ylim      = NULL,
                         xlab      = "",
                         main      = "",
                         hist_cols = rainbow(length(data)),
                         border    = "black",
                         legend_names,
                         legend_inset = 0.05){

  # Plot initial histogram
  hist_result  <- hist(x = unlist(data),
                       breaks = breaks,
                       xlab = xlab,
                       ylim = ylim,
                       main = main,
                       border = NA)
  break_points <- hist_result$breaks

  # Now calculate numbers in each category
  hist_counts <- t(sapply(data, function(x){
    hist(x      = x,
         breaks = break_points,
         plot   = FALSE)$counts
  }))
# blablabla
  # Now plot histogram
  for(n in 1:ncol(hist_counts)) {

    # Histogram splits
    for(x in 1:length(data)) {
      bar_height <- sum(hist_counts[x:nrow(hist_counts),n])
      polygon(x = c(break_points[n], break_points[n], break_points[n+1], break_points[n+1]),
              y = c(0, bar_height, bar_height, 0),
              col = hist_cols[x],
              border = NA)
    }

    # Border around edge
    bar_height <- sum(hist_counts[,n])
    polygon(x = c(break_points[n], break_points[n], break_points[n+1], break_points[n+1]),
            y = c(0, bar_height, bar_height, 0),
            border = border)
  }

  # Plot legend if names given
  if(!missing(legend_names)) {
    legend(x      = "topright",
           legend = legend_names,
           fill   = hist_cols,
           bty    = "n",
           inset  = legend_inset,
           y.intersp = 1.5)
  }

}


