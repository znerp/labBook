

#' Function for calculating the confidence interval of a sample mean
#'
#' @param x
#' @param conf.level
#'
#' @export
mean_ci <- function(x,
                    conf.level = 0.95){

  # Remove NAs
  x <- x[!is.na(x)]

  # Get the sample size and standard deviation
  n    <- length(x)
  se   <- sd(x)/sqrt(n)
  xbar <- mean(x)

  # Get the upper and lower tails you want
  conf.upper <- 1 - (1 - conf.level)/2
  conf.lower <- (1 - conf.level)/2

  # Return the confidence intervals of the mean
  c(xbar + se*qt(conf.lower, n-1),
    xbar + se*qt(conf.upper, n-1))

}


#' Plot mean point with confidence intervals
#'
#' @param x
#' @param values
#' @param conf.level
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
plot_mean_ci <- function(x,
                         values,
                         conf.level = 0.95,
                         ...){

  # Get confidence interval
  conf_int <- mean_ci(x          = values,
                      conf.level = conf.level)

  # Plot confidence interval
  lines(x = c(x,x),
        y = conf_int,
        ...)

  # Plot mean point
  points(x = x,
         y = mean(values, na.rm = TRUE),
         pch = 16,
         ...)

}


