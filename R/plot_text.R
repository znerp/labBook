

#' Plot text on a blank plot
#'
#' @param text2plot
#' @param cex
#' @param valign
#'
#' @return
#' @export
#'
#' @examples
plot_text <- function(text2plot,
                      cex = 2,
                      plot_x = 0,
                      plot_y = 0,
                      ...) {

  par(mar=c(0,0,0,0))
  plot.new()
  plot.window(xlim = c(-1,1),
              ylim = c(-1,1))

  text(x = plot_x,
       y = plot_y,
       labels = text2plot,
       cex = cex,
       ...)

}

