

#' Plot titres
#'
#' @param x_data
#' @param y_data
#' @param xlim
#' @param ylim
#' @param xlab
#' @param ylab
#' @param nd_titres
#' @param princomp
#' @param princomp_col
#' @param draw_eq_line
#' @param lm
#' @param lm_col
#'
#' @return
#' @export
#'
#' @examples
plot_titres <- function(x_data,
                        y_data,
                        xlim = c(-1,8),
                        ylim = c(-1,8),
                        xlab = "",
                        ylab = "",
                        nd_titres = TRUE,
                        princomp = FALSE,
                        princomp_col = "red",
                        titre_class_means = FALSE,
                        draw_eq_line = TRUE,
                        lm = FALSE,
                        lm_col = "blue",
                        fit_x_nd = !nd_titres,
                        fit_y_nd = !nd_titres,
                        jitter = NA,
                        x_jitter = jitter,
                        y_jitter = jitter,
                        title,
                        ...) {

  # Remove NAs
  na_titres <- is.na(x_data) | is.na(y_data)
  x_data <- x_data[!na_titres]
  y_data <- y_data[!na_titres]

  # Do plot
  plot.new()
  plot.window(xlim = xlim,
              ylim = ylim)

  # Plot axes
  if(nd_titres) {
    axis(1, at = xlim[1]:xlim[2], labels = gsub("-1", "nd", xlim[1]:xlim[2]))
    axis(2, at = ylim[1]:ylim[2], labels = gsub("-1", "nd", ylim[1]:ylim[2]), las = 2)
  }
  else {
    axis(1, at = xlim[1]:xlim[2])
    axis(2, at = ylim[1]:ylim[2], las = 2)
  }
  box()

  # Plot labels
  mtext(xlab, 1, 2.5)
  mtext(ylab, 2, 2.5)

  # Plot points
  if(!is.na(x_jitter)) { x_data_plot <- jitter(x_data, amount = x_jitter) }
  else                 { x_data_plot <- x_data }
  if(!is.na(y_jitter)) { y_data_plot <- jitter(y_data, amount = y_jitter) }
  else                 { y_data_plot <- y_data }
  points(x = x_data_plot,
         y = y_data_plot,
         pch = 16, col = rgb(0,0,0,0.2))

  # Draw line of equality
  if(draw_eq_line) {
    abline(0, 1, lty=2)
  }


  # Don't fit nd data unless requested
  x_data_fit <- x_data
  y_data_fit <- y_data

  if(!fit_x_nd) {
    x_nd_data <- x_data_fit <= -1
    x_data_fit <- x_data_fit[!x_nd_data]
    y_data_fit <- y_data_fit[!x_nd_data]
  }

  if(!fit_y_nd) {
    y_nd_data <- y_data_fit <= -1
    x_data_fit <- x_data_fit[!y_nd_data]
    y_data_fit <- y_data_fit[!y_nd_data]
  }


  # Draw principal component
  if(princomp) {
    draw.princomp(x_data = x_data_fit,
                  y_data = y_data_fit,
                  col = princomp_col,
                  legend_pos = "topleft",
                  legend_col = princomp_col,
                  ...)
  }

  # Draw principal component
  if(lm) {
    lm_fit <- draw.abline(x_data = x_data_fit,
                          y_data = y_data_fit,
                          col = lm_col,
                          legend_pos = "topleft",
                          legend_col = lm_col,
                          ...)
  }

  # Plot means for each titre class if requested
  if(titre_class_means) {

    x_data_rounded <- round(x_data)
    for(x in xlim[1]:xlim[2]) {
      if(sum(x_data_rounded == x) > 3) {
        lines(x = c(x,x),
              y = mean_ci(y_data[x_data_rounded == x]),
              col = "white", lwd = 3)
        lines(x = c(x,x),
              y = mean_ci(y_data[x_data_rounded == x]),
              lwd = 2)
        points(x = x,
               y = mean(y_data[x_data_rounded == x]),
               pch = 16,
               cex = 2,
               col = "white",
               ...)
        points(x = x,
               y = mean(y_data[x_data_rounded == x]),
               pch = 16,
               cex = 1.5,
               ...)
      }
    }

  }

  # Write title if provided
  if(!missing(title)){
    title(title)
  }

}
