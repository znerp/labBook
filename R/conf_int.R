

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
                         pch = 16,
                         bar_width,
                         min_crop,
                         ...){

  # Get confidence interval
  conf_int <- mean_ci(x          = values,
                      conf.level = conf.level)
  mean_val <- mean(values, na.rm = TRUE)

  # Crop to a minimum point is requested (i.e. nd)
  if(!missing(min_crop)){
    conf_int[conf_int < min_crop] <- min_crop
    mean_val[mean_val < min_crop] <- min_crop
  }

  # Plot confidence interval
  lines(x = c(x,x),
        y = conf_int,
        ...)

  # Plot bars if requested
  if(!missing(bar_width)){
    lines(x = c(x-bar_width/2, x+bar_width/2),
          y = c(conf_int[1], conf_int[1]),
          ...)

    lines(x = c(x-bar_width/2, x+bar_width/2),
          y = c(conf_int[2], conf_int[2]),
          ...)
  }

  # Plot mean point
  points(x = x,
         y = mean_val,
         pch = pch,
         ...)

}


