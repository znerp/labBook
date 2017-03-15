
#' Do a 2D density function plot
#'
#' @param x
#' @param y
#' @param xlab
#' @param ylab
#'
#' @return
#' @export
#'
#' @examples
plot_density <- function(x, y,
                         xlab = "",
                         ylab = "",
                         xaxs = "r",
                         yaxs = "r",
                         xlim = range(x),
                         ylim = range(y),
                         dens_col = topo.colors(40),
                         dens_fun,
                         fit_h,
                         ndens    = 100){

  # Remove nas
  na_titres <- is.na(x) | is.na(y)
  x <- x[!na_titres]
  y <- y[!na_titres]

  # Do density plot
  density_result <- MASS::kde2d(x = x,
                                y = y,
                                h = fit_h,
                                n = ndens)

  # Apply a transformation to z if specified
  if(!missing(dens_fun)) {
    density_result$z <- dens_fun(density_result$z)
  }

  # Do a contour plot
  image(x = density_result$x,
        y = density_result$y,
        z = density_result$z,
        xlim = xlim,
        ylim = ylim,
        xaxs = xaxs,
        yaxs = yaxs,
        xlab = xlab,
        ylab = ylab,
        col  = dens_col,
        useRaster = TRUE)

}

