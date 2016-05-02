
draw.loess.bs <- function(x.data,
                          y.data, 
                          span = 0, 
                          bandwidth = 0, 
                          degree, 
                          bs.repeats = 1000, 
                          fit.resolution = 100, 
                          conf = 0.68,
                          col="blue") {
  
  library(locfit)
  library(boot)
  
  x.prediction.values <- seq(from=min(x.data), to=max(x.data), length.out=fit.resolution)
  
  # Bootstrap the loess fit.
  fit.loess <- function(data, indices){
    x.data <- data[indices,1]
    y.data <- data[indices,2]
    
    # Fit the loess fit.
    loess.fit     <- locfit(y.data~lp(x.data, nn = span, h = bandwidth, deg=degree))
    fitted.values <- predict(loess.fit, data.frame(x.data=x.prediction.values))
    
    # Return the fitted values
    return(fitted.values)
  }
    
  boot.results <- boot(data      = cbind(x.data,y.data),
                       statistic = fit.loess,
                       R         = bs.repeats)
  
  loess.actual  <- fit.loess(cbind(x.data,y.data),1:length(x.data))
  loess.lowerci <- rep(NA,fit.resolution)
  loess.upperci <- rep(NA,fit.resolution)
  
  for(x in 1:fit.resolution){
    loess.lowerci[x] <- boot.ci(boot.results, type="perc", index=x, conf = conf)$perc[4]
    loess.upperci[x] <- boot.ci(boot.results, type="perc", index=x, conf = conf)$perc[5]
  }
  
  polygon.col <- rgb(col2rgb(col)[1], col2rgb(col)[2], col2rgb(col)[3], 50, maxColorValue = 255)
  
  polygon(c(x.prediction.values,rev(x.prediction.values)),
          c(loess.lowerci, rev(loess.upperci)),
          col=polygon.col, border=NA)
  lines(x.prediction.values, loess.actual, col=col, lwd=2)
  
  # Return fit data as output
  output <- c()
  output$fit_x        <- x.prediction.values
  output$fit_y        <- loess.actual
  output$fit_upper_ci <- loess.upperci
  output$fit_lower_ci <- loess.lowerci
  output
  
}