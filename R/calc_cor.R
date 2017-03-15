

#' Calculate correlation between two vectors
#'
#' @param x_data
#' @param y_data
#' @param method
#' @param legend_pos
#'
#' @return
#' @export
#'
#' @examples
calc_cor <- function(x_data,
                     y_data,
                     method,
                     legend_pos,
                     legend_col = "blue"){

  # Calculate the pearson correlation
  if(method == "pearson") {
    cor_result <- cor(x      = x_data,
                      y      = y_data,
                      use    = "na.or.complete",
                      method = "pearson")
    cor_CI <- psych::r.con(rho       = cor_result,
                           p         = 0.95,
                           n         = length(x_data),
                           twotailed = TRUE)
  }


  # Calculate the spearman correlation
  if(method == "spearman") {
    cor_result <- cor(x      = x_data,
                      y      = y_data,
                      use    = "na.or.complete",
                      method = "spearman")

    r      <- cor_result
    num    <- sum(!is.na(x_data) & !is.na(y_data))
    stderr <- 1 / sqrt(num - 3)
    delta  <- 1.96 * stderr
    lower  <- tanh(atanh(r) - delta)
    upper  <- tanh(atanh(r) + delta)

    cor_CI <- c(lower, upper)

  }

  # Show correlation
  if(!missing(legend_pos)){

    legend(x        = legend_pos,
           legend   = paste0(round(cor_result, 2), " [", paste(round(cor_CI, 2), collapse = ", "), "]"),
           bty      = "n",
           text.col = legend_col)

  }

  # Return the correlation result
  c(cor_result, cor_CI)

}






