
#' Function for drawing a loess fit through data
#'
#' @param x_data
#' @param y_data
#' @param model_sp
#' @param model_bw
#' @param model_dg
#' @param bs_repeats
#' @param fit_resolution
#' @param conf
#' @param col
#'
#' @return
#' @export
#'
#' @examples
draw.loess <- function(x_data,
                       y_data,
                       model_sp = 0,
                       model_bw = 0,
                       model_dg,
                       bs_repeats = 1000,
                       fit_resolution = 100,
                       conf = 0.68,
                       col="blue",
                       lwd = 2,
                       ...) {

  # Remove NA values
  na_data <- is.na(x_data) | is.na(y_data)
  x_data  <- x_data[!na_data]
  y_data  <- y_data[!na_data]

  x_prediction_values <- seq(from=min(x_data), to=max(x_data), length.out=fit_resolution)

  # Bootstrap the loess fit.
  fit_loess <- function(data, indices){
    x_data <- data[indices,1]
    y_data <- data[indices,2]

    # Try fitting the loess fit.
    fitted_values <- rep(NA, nrow(data))
    try(expr = {
          loess.fit     <- locfit(y_data~lp(x_data, nn = model_sp, h = model_bw, deg=model_dg))
          #loess.fit     <- loess(y_data~x_data, span = model_sp, degree = model_dg)
          fitted_values <- predict(loess.fit, data.frame(x_data=x_prediction_values))
        })

    # Return the fitted values
    return(fitted_values)
  }


  # Bootstap if requested
  if(!is.na(bs_repeats)) {
    boot_results <- boot(data      = cbind(x_data,y_data),
                         statistic = fit_loess,
                         R         = bs_repeats)

    loess_lowerci <- rep(NA,fit_resolution)
    loess_upperci <- rep(NA,fit_resolution)

    for(x in 1:fit_resolution){
      loess_lowerci[x] <- boot.ci(boot_results, type="perc", index=x, conf = conf)$perc[4]
      loess_upperci[x] <- boot.ci(boot_results, type="perc", index=x, conf = conf)$perc[5]
    }

    polygon_col <- rgb(col2rgb(col)[1], col2rgb(col)[2], col2rgb(col)[3], 50, maxColorValue = 255)

    polygon(c(x_prediction_values,rev(x_prediction_values)),
            c(loess_lowerci, rev(loess_upperci)),
            col=polygon_col, border=NA)
  }
  else {
    loess_lowerci <- NA
    loess_upperci <- NA
  }

  # Show regular fit
  loess_actual  <- fit_loess(cbind(x_data,y_data),1:length(x_data))
  lines(x_prediction_values, loess_actual, col=col, lwd=lwd, ...)

  # Return fit data as output
  output <- c()
  output$fit_x        <- x_prediction_values
  output$fit_y        <- loess_actual
  output$fit_upper_ci <- loess_upperci
  output$fit_lower_ci <- loess_lowerci
  output

}
