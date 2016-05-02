draw.abline <- function(y.data, x.data, silent=TRUE, ...) {

    na.data <- is.na(x.data) | is.na(y.data)
    x.data  <- x.data[!na.data]
    y.data  <- y.data[!na.data]

    abline.model <- lm(y.data ~ x.data)
    abline(abline.model, ...)

    # Draw prediction lines too.
	pp <- predict(abline.model, int="p")
	pc <- predict(abline.model, int="c")
	matlines(x.data[order(x.data)], pc[order(x.data),], lty=c(1,2,2), ...)

	if(silent==FALSE) {
	    print(abline.model)
  }
}
