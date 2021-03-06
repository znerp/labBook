

#' Do a filled Contour plot
#'
#' @param x
#' @param y
#' @param z
#' @param xlim
#' @param ylim
#' @param zlim
#' @param levels
#' @param nlevels
#' @param color.palette
#' @param col
#' @param plot.title
#' @param plot.axes
#' @param key.title
#' @param key.axes
#' @param asp
#' @param xaxs
#' @param yaxs
#' @param las
#' @param axes
#' @param frame.plot
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
contour_plot <- function (x = seq(0, 1, length.out = nrow(z)), y = seq(0, 1,
                                                                       length.out = ncol(z)), z, xlim = range(x, finite = TRUE),
                          ylim = range(y, finite = TRUE), zlim = range(z, finite = TRUE),
                          levels = pretty(zlim, nlevels), nlevels = 20, color.palette = cm.colors,
                          col = color.palette(length(levels) - 1), plot.title, plot.axes,
                          key.title, key.axes, asp = NA, xaxs = "i", yaxs = "i", las = 1,
                          axes = TRUE, frame.plot = axes, ...)
{
  if (missing(z)) {
    if (!missing(x)) {
      if (is.list(x)) {
        z <- x$z
        y <- x$y
        x <- x$x
      }
      else {
        z <- x
        x <- seq.int(0, 1, length.out = nrow(z))
      }
    }
    else stop("no 'z' matrix specified")
  }
  else if (is.list(x)) {
    y <- x$y
    x <- x$x
  }
  if (any(diff(x) <= 0) || any(diff(y) <= 0))
    stop("increasing 'x' and 'y' values expected")
  mar.orig <- (par.orig <- par(c("mar", "las", "mfrow")))$mar
  on.exit(par(par.orig))
  w <- (3 + mar.orig[2L]) * par("csi") * 2.54

  par(las = las)

  if (!missing(key.title))
    key.title
  mar <- mar.orig
  mar[4L] <- 1
  par(mar = mar)
  plot.new()
  .filled.contour(x, y, z, levels, col)
  if (missing(plot.axes)) {
    if (axes) {
      title(main = "", xlab = "", ylab = "")
      Axis(x, side = 1)
      Axis(y, side = 2)
    }
  }
  else plot.axes
  if (frame.plot)
    box()
  if (missing(plot.title))
    title(...)
  else plot.title
  invisible()
}


#' Do a filled contour legend
#'
#' @param x
#' @param y
#' @param z
#' @param xlim
#' @param ylim
#' @param zlim
#' @param levels
#' @param nlevels
#' @param color.palette
#' @param col
#' @param plot.title
#' @param plot.axes
#' @param key.title
#' @param key.axes
#' @param asp
#' @param xaxs
#' @param yaxs
#' @param las
#' @param axes
#' @param frame.plot
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
contour_legend <- function (x = seq(0, 1, length.out = nrow(z)), y = seq(0, 1,
                                                                         length.out = ncol(z)), z, xlim = range(x, finite = TRUE),
                            ylim = range(y, finite = TRUE), zlim = range(z, finite = TRUE),
                            levels = pretty(zlim, nlevels), nlevels = 20, color.palette = cm.colors,
                            col = color.palette(length(levels) - 1), plot.title, plot.axes,
                            key.title, key.axes, asp = NA, xaxs = "i", yaxs = "i", las = 1,
                            axes = TRUE, frame.plot = axes, ...)
{
  if (missing(z)) {
    if (!missing(x)) {
      if (is.list(x)) {
        z <- x$z
        y <- x$y
        x <- x$x
      }
      else {
        z <- x
        x <- seq.int(0, 1, length.out = nrow(z))
      }
    }
    else stop("no 'z' matrix specified")
  }
  else if (is.list(x)) {
    y <- x$y
    x <- x$x
  }
  if (any(diff(x) <= 0) || any(diff(y) <= 0))
    stop("increasing 'x' and 'y' values expected")
  mar.orig <- (par.orig <- par(c("mar", "las", "mfrow")))$mar
  on.exit(par(par.orig))
  w <- (3 + mar.orig[2L]) * par("csi") * 2.54
  par(las = las)
  mar <- mar.orig
  mar[4L] <- mar[2L]
  mar[2L] <- 1
  par(mar = mar)
  plot.new()
  plot.window(xlim = c(0, 1), ylim = range(levels), xaxs = "i",
              yaxs = "i")
  rect(0, levels[-length(levels)], 1, levels[-1L], col = col)
  if (missing(key.axes)) {
    if (axes)
      axis(4)
  }
  else key.axes
  box()
  invisible()
}



# require(grDevices) # for colours
# graphics.off()
#
# split.screen(c(1,3))
# screen(1)
# contour_plot(volcano, color = terrain.colors, asp = 1) # simple
# screen(2)
# contour_plot(volcano, color = terrain.colors, asp = 1) # simple
# screen(3)
# contour_plot(volcano, color = terrain.colors, asp = 1) # simple


