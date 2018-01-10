

#' Start piping console output to the clipboard
#'
#' @export
#'
start_console2clip <- function(){
  clip <- pipe("pbcopy", "w")
  sink(clip)
}

#' Stop piping console output to the clipboard
#'
#' @export
#'
stop_console2clip <- function(){
  sink()
}


#' Format a table as latex
#'
#' @param R_table
#'
#' @return Returns a character string of the table formatted into latex
#' @export
#'
make_latex_table <- function(R_table){

  num_cols <- ncol(R_table)
  num_rows <- nrow(R_table)

  # Generate latex output
  latex_output <- c()
  latex_output <- paste0(latex_output, "\\begin{tabular}{ ", rep("c ", num_cols),"}\n")

  row_text <- apply(R_table, 1, function(x){
    paste0("  ", paste(x, collapse = " & "), " \\\\")
  })

  latex_output <- paste0(latex_output, paste(row_text, collapse = "\n"))
  latex_output <- paste0(latex_output, "\n\\end{tabular}")

  # Return latex
  latex_output

}




## Plot confidence intervals.
plot.ci <- function(x.point, conf.int, width, col="black") {
  lines(x=c(x.point,x.point),y=conf.int,col=col)
  lines(x=c(x.point+width,x.point-width),y=c(conf.int[1],conf.int[1]),col=col)
  lines(x=c(x.point+width,x.point-width),y=c(conf.int[2],conf.int[2]),col=col)
}


## Display notification when script is done.
done <- function(){
  system('osascript -e \'display notification "R Script done"\'')
}


## Easier version of the mclapply function that replaces apply.
papply <- function(X, MARGIN, FUN, pp=TRUE, ...) {

  if(pp) { num.cores <- 4 }
  else   { num.cores <- 1             }
  matrix.X   <- is.matrix(X)
  if(MARGIN == 1) { X <- t(X)             }
  output <- as.data.frame(mclapply(as.list(as.data.frame(X)),
                                   FUN,mc.cores = num.cores, ...))

  output <- as.matrix(output)
  if(MARGIN == 1 | matrix.X) { colnames(output) <- NULL }
  if(MARGIN == 2)            { rownames(output) <- NULL }

  return(output)

}

## Easier version of the apply function that works also with a vector.
napply <- function(X, MARGIN, FUN, ...) {
  if(is.null(dim(X))) {
    X <- matrix(X,nrow=1)
  }
  apply(X, MARGIN, FUN, ...)
}

## Convert to matrix function.
c2m <- function(X){
  if(is.null(X)) {
    return(NULL)
  }
  if(is.null(dim(X))) {
    matrix(X, nrow=1)
  }
  else {
    as.matrix(X)
  }
}


## Code for checking the workspace elements used by a given script.
get.script.globals <- function(script) {
  used.globals <- eval(parse(text=paste0("codetools::findGlobals(function(){",
                                         readChar(script, file.info(script)$size),
                                         "})")))
  used.globals <- ls(envir=parent.frame())[ls(envir=parent.frame()) %in% used.globals]
  return(used.globals)
}


#' Function for mixing two colours together
#'
#' @param col1
#' @param col2
#' @param prop
#'
#' @return
#' @export
#'
#' @examples
mix.cols <- function(col1, col2, prop=0.5) {

  if(prop > 1) { prop <- 1 }
  if(prop < 0) { prop <- 0 }

  r1 <- col2rgb(col1)[1]
  g1 <- col2rgb(col1)[2]
  b1 <- col2rgb(col1)[3]
  r2 <- col2rgb(col2)[1]
  g2 <- col2rgb(col2)[2]
  b2 <- col2rgb(col2)[3]

  rgb(r1*prop + r2*(1-prop),
      g1*prop + g2*(1-prop),
      b1*prop + b2*(1-prop),
      maxColorValue = 255)

}

mix.multicols <- function(cols, props) {

  r <- 0
  g <- 0
  b <- 0

  for(x in 1:length(cols)) {
    r <- r + col2rgb(cols[x])[1]*props[x]
    g <- g + col2rgb(cols[x])[2]*props[x]
    b <- b + col2rgb(cols[x])[3]*props[x]
  }

  rgb(r,g,b,maxColorValue = 255)

}

#' Function for fading a colour by a given alpha
#'
#' @param col
#' @param alpha
#'
#' @return
#' @export
#'
#' @examples
fade.cols <- function(col, alpha) {

  alpha <- 255*alpha
  faded.cols <- rep(NA, length(col))
  for(x in 1:length(faded.cols)) {
    faded.cols[x] <- rgb(col2rgb(col[x])[1],
                         col2rgb(col[x])[2],
                         col2rgb(col[x])[3],
                         alpha, maxColorValue = 255)
  }
  faded.cols

}



# Plot a circle
draw.circle <- function(centre, radius, definition=50, fill=NA, lwd=1, ...) {

  circ.thetas <- seq(from=0, to=2*pi, length.out=definition)

  x.coords <- radius * cos(circ.thetas) + centre[1]
  y.coords <- radius * sin(circ.thetas) + centre[2]

  if(!is.na(fill)) {
    polygon(x.coords,
            y.coords,
            border = NA,
            col=fill)
  }

  if(lwd > 0) {
    lines(x = x.coords,
          y = y.coords,
          lwd = lwd, ...)
  }
}


# Function for writing to the clipboard and closing the connection to the clipboard.
open.cp <- function() {
  clipboard.connection <- pipe("pbcopy", "w")
  sink(clipboard.connection)
}

close.cp <- function() {
  #close(clipboard.connection)
  sink(type = "message")
  sink()
}


# Wrapper for the optim function to allow exploration from different starting parameters.
optim.multi <- function(par, fn, gr = NULL, ...,
                method = c("Nelder-Mead", "BFGS", "CG", "L-BFGS-B", "SANN",
                           "Brent"),
                lower = -Inf, upper = Inf,
                control = list(), hessian = FALSE) {

  result.table <- t(apply(par,1,function(x) {
    result <- optim(par     = x,
                    fn      = fn,
                    gr      = gr,
                    method  = method,
                    lower   = lower,
                    upper   = upper,
                    control = control,
                    hessian = hessian,
                    ...)

    return(c(result$val,result$par))
  }))

  best.val <- result.table[which.min(result.table[,1]),1]
  best.par <- result.table[which.min(result.table[,1]),-1]

  output <- c()
  output$val <- best.val
  output$par <- best.par
  return(output)

}






optim.multi2 <- function(par, fn, gr = NULL, ...,
                         method = c("Nelder-Mead", "BFGS", "CG", "L-BFGS-B", "SANN",
                                    "Brent"),
                         lower = -Inf, upper = Inf,
                         control = list(), hessian = FALSE) {

  #cat("\n")
  runs.complete <- 0
  total.runs    <- nrow(par)

  result.table <- t(apply(par,1,function(x) {
    value <- fn(x, ...)
    runs.complete <<- runs.complete+1
    #cat(paste0("\rOptim ",round(runs.complete/total.runs,2)*100,"% complete"))
    return(c(value,x))
  }))

  best.par <- result.table[which.min(result.table[,1]),-1]
  #print(best.par)

  result <- optim(par     = best.par,
                  fn      = fn,
                  gr      = gr,
                  method  = method,
                  lower   = lower,
                  upper   = upper,
                  control = control,
                  hessian = hessian,
                  ...)

  return(result)

}



list.files.by.date <- function(dir, full.names=F) {

  file.list      <- list.files(dir,full.names = F)
  file.list.full <- list.files(dir,full.names = T)

  if(full.names) { return(file.list.full[order(file.info(file.list.full)$mtime,decreasing = TRUE)]) }
  else           { return(file.list[order(file.info(file.list.full)$mtime,decreasing = TRUE)])      }

}



spread.titres <- function(x.coords, titres) {

  ## Remove NAs.
  na.values <- is.na(x.coords) | is.na(titres)
  titres    <- titres[!na.values]
  x.coords  <- x.coords[!na.values]

  spread.factor <- 0.1
  unique.coords <- unique(x.coords)
  for(coord in unique.coords) {
    unique.titres <- unique(titres[x.coords == coord])
    for(titre in unique.titres) {
      num.repeats <- sum(x.coords == coord & titres == titre)
      if(num.repeats > 1) {
        new.titres <- seq(from = titre - (spread.factor*(num.repeats-1))/2,
                          to   = titre + (spread.factor*(num.repeats-1))/2,
                          length.out = num.repeats)
        titres[titres == titre & x.coords == coord] <- new.titres
      }
    }
  }

  ## Replace NAs and return titres.
  titres.with.spread <- rep(NA, length(na.values))
  titres.with.spread[!na.values] <- titres
  return(titres.with.spread)

}



#' Convert year to long year format
#'
#' @param year
#'
#' @return
#' @export
#'
#' @examples
longYear <- function(year){

  if(nchar(year) == 1) {
    year <- paste0(0, year)
  }

  if(nchar(year) == 4) {
    return(year)
  }

  if(nchar(year) == 3 | nchar(year) > 4) {
    stop(paste("Unclear how to parse year", year))
  }

  if(as.numeric(year) > as.numeric(format(Sys.Date(), format = "%y"))) {
    return(as.numeric(paste0("19",year)))
  }
  else {
    return(as.numeric(paste0("20",year)))
  }

}

#' Open a file
#'
#' @param file_path
#'
#' @return
#' @export
#'
#' @examples
open_file <- function(file_path){

  system2("open", normalizePath(file_path))

}


#' Check if x is a multiple of something
#'
#' @param x
#' @param multiple
#'
#' @export
#'
is.multiple <- function(x, multiple){
 round(x/multiple) == x/multiple
}




