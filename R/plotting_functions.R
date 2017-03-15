
#' Setup a blank plot
#'
#' This function sets up a blank plot ready for plotting.
#'
#' @param xlim The limits of the x axis.
#' @param ylim The limits of the y axis.
#' @param xlab Optional x axis label.
#' @param ylab Optional x axis label.
#' @param main Optional title.
#' @param margins Option to specify plot margins in inches specifically.
#' @param pad_axes Logical, should the plot pad x and y axes.
#' @param label_axes Logical, should axes be labelled.
#' @param y_las Rotation of y axis tick labels.
#'
#' @export
#'
setup.plot <- function(xlim       = c(-1,1),
                       ylim       = c(-1,1),
                       xlab, ylab, main,
                       margins,
                       pad_axes   = TRUE,
                       x_axis     = TRUE,
                       y_axis     = TRUE,
                       xlab_dist  = 2.8,
                       ylab_dist  = 3,
                       y_las      = 1) {

  # Decide axis type
  if(pad_axes) {
    xaxs = "r"
    yaxs = "r"
  }
  else {
    xaxs = "i"
    yaxs = "i"
  }

  # Decide on margins
  if(missing(margins)) {
    margins <- c(4,4,2,2)
    if(!missing(xlab)) { margins[1] <- 5.5 }
    if(!missing(ylab)) { margins[2] <- 5.5 }
    if(!missing(main)) { margins[3] <- 5   }
  }

  # Setup plot
  plot.new()
  par(mar = margins)
  plot.window(xlim = xlim,
              ylim = ylim,
              xaxs = xaxs,
              yaxs = yaxs)
  box()

  # Draw axes
  if(x_axis) { axis(1) }
  if(y_axis) { axis(2, las = y_las) }

  # Draw axes labels
  if(!missing(xlab)) { mtext(xlab, 1, xlab_dist) }
  if(!missing(ylab)) { mtext(ylab, 2, ylab_dist) }

  # Draw title
  if(!missing(main)) { title(main) }

}




#' Layout a pair plot
#'
#' @param x
#' @param widths
#' @param heights
#'
#' @return
#' @export
#'
#' @examples
layout_pairplot <- function(x,
                            widths  = rep(1, x),
                            heights = rep(1, x)){

  # Setup base matrix
  plot_num      <- 1
  layout_matrix <- matrix(NA, nrow = x, ncol = x)

  # Fill in the diagonal first
  for(n in 1:x){
    layout_matrix[n,n] <- plot_num
    plot_num <- plot_num + 1
  }

  # Now fill in the bottom rows
  for(col in 1:(x-1)){
    for(row in (col+1):x){
      layout_matrix[row,col] <- plot_num
      plot_num <- plot_num + 1
    }
  }

  # Now fill in the top rows
  for(row in 1:(x-1)){
    for(col in (row+1):x){
      layout_matrix[row,col] <- plot_num
      plot_num <- plot_num + 1
    }
  }

  # Layout the plot
  layout(mat     = layout_matrix,
         widths  = widths,
         heights = heights)

}




