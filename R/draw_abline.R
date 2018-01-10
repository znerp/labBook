
#' Function for drawing a linear regression through data
#'
#' @param y_data
#' @param x_data
#' @param interval
#' @param col
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
draw.abline <- function(x_data,
                        y_data,
                        interval = "c",
                        col = "blue",
                        legend_pos = "topright",
                        legend_col = col,
                        ...) {

  # Remove NAs
  na_data <- is.na(x_data) | is.na(y_data)
  x_data  <- x_data[!na_data]
  y_data  <- y_data[!na_data]

  # Do some checks on the data
  if(length(x_data) != length(y_data)) {
    stop("x and y data different lengths")
  }

  # Check there is enough data
  if(length(x_data) < 3) {
    warning(paste0("Insufficient data (n=",length(x_data),") to draw lm line"))
    return(NULL)
  }

  # Check there is a data range
  if(diff(range(x_data)) == 0) {
    warning(paste0("Cannot draw lm line with no variation in x value"))
    return(NULL)
  }

  # Now fit model
  abline_model <- lm(y_data ~ x_data)

  # Draw abline
  abline(abline_model,
         col = col,
         ...)

  # Draw prediction lines too.
  if(!is.na(interval)){
    fitted_interval <- predict(abline_model, int=interval)
    matlines(x_data[order(x_data)],
             fitted_interval[order(x_data),],
             lty = c(1,2,2),
             col = col,
             ...)
  }


  # Return abline model
  abline_model

}




#' Fit princomp line
#'
#' Get the intercept and slope for the 1st principle component.
#'
#' @param x The x data
#' @param y The y data
#'
#' @return Returns the intercept and slope.
#' @export
#'
get_prcomp_abline <- function(x, y){

  r <- prcomp(~ x + y)

  slope     <- r$rotation[2,1] / r$rotation[1,1]
  intercept <- r$center[2] - slope*r$center[1]

  c(intercept, slope)

}


#' Function for drawing a linear regression through data
#'
#' @param y_data
#' @param x_data
#' @param interval
#' @param col
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
draw.princomp <- function(x_data,
                          y_data,
                          col = "blue",
                          interval = "c",
                          legend_pos = "topright",
                          legend_col = "blue",
                          x_fit_data = seq(from = min(x_data),
                                           to   = max(x_data),
                                           length.out = 200),
                          ...) {

  # Remove NAs
  na_data <- is.na(x_data) | is.na(y_data)
  x_data  <- x_data[!na_data]
  y_data  <- y_data[!na_data]

  # Do some checks on the data
  if(length(x_data) != length(y_data)) {
    stop("x and y data different lengths")
  }

  # Check there is enough data
  if(length(x_data) < 3) {
    warning(paste0("Insufficient data (n=",length(x_data),") to draw lm line"))
    return(NULL)
  }

  # Check there is a data range
  if(diff(range(x_data)) == 0) {
    warning(paste0("Cannot draw lm line with no variation in x value"))
    return(NULL)
  }

  # Now fit model
  get_y_predictions <- function(data, indices, x_fit_data){

    fit_pars <- get_prcomp_abline(x = data[indices,1],
                                  y = data[indices,2])

    x_fit_data*fit_pars[2] + fit_pars[1]

  }

  pr_result <- get_prcomp_abline(x_data, y_data)
  if(!is.na(interval)) {
    pr_bs_result <- boot::boot(data       = cbind(x_data, y_data),
                               statistic  = get_y_predictions,
                               R          = 1000,
                               x_fit_data = x_fit_data)
    y_CIs <- apply(pr_bs_result$t, 2, quantile, probs = c(0.025, 0.975), na.rm = TRUE)

    # Draw confidence intervals
    lines(x = x_fit_data,
          y = y_CIs[1,],
          col = col,
          lty = 2)

    lines(x = x_fit_data,
          y = y_CIs[2,],
          col = col,
          lty = 2)
  }

  # Draw abline
  abline(a = pr_result[1],
         b = pr_result[2],
         col = col,
         ...)


  # Return abline model
  c(pr_result[1], pr_result[2])

}




# x_data <- rnorm(20)
# y_data <- x_data*2 + rnorm(20)
#
# plot(x_data, y_data)
# draw.abline(x_data, y_data, col = "red")
# draw.princomp(x_data, y_data)




