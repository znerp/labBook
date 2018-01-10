
#' Write to a pdf file
#'
#' Function to write to a pdf file and also make a png copy of it, copying the link to your clipboard.
#'
#' @param file
#' @param width
#' @param height
#' @param html.height
#' @param add2cp
#' @param save2cp
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
write.pdf <- function(file=NA, width=7, height=7, html.width=800, add2cp=F, save2cp=T, ...){

  ## Create temp file if file argument is missing
  if(is.na(file)) {
    file_loc   <- tempfile()
    file_given <- FALSE
  }
  else {
    file_loc   <- file
    file_given <- TRUE
  }

  ## Open pdf connection
  pdf(file=file_loc, width=width, height=height, ...)

  if(file_given) {
    ## Copy html link to clipboard
    html.output <- ""
    if(add2cp) {
      paste_pipe  <- pipe("pbpaste")
      html.output <- readLines(paste_pipe)
      close(paste_pipe)
    }
    png.name <- gsub("pdf$","png",file_loc)
    html.output <- c(html.output,paste0("<a href='../",file_loc,"'><img src='../",png.name,"' style='width:",html.width,"px'/></a>"))

    ## Append to clipboard if requested
    if(save2cp) {
      clip <- pipe("pbcopy", "w")
      writeLines(html.output, clip)
      close(clip)
    }
  }

  # Escape brackets
  file_loc <- gsub("\\(","\\\\(",file_loc)
  file_loc <- gsub("\\)","\\\\)",file_loc)

  ## Define function for pdf.off
  if(file_given) {
    pdf.off <<- function(){
      dev.off()
      png.name <- gsub("pdf$","png",eval(file_loc))
      system(paste0('sips -s format png ',eval(file_loc),' --resampleWidth ',html.width*2,' --out ', png.name),
             ignore.stdout = TRUE)
    }
  }
  else {
    pdf.off <<- function(){
      dev.off()
      system(paste0('open ',eval(file_loc)))
    }
  }
}



copy.pdf <- function(file, html.width="200px", html.height="120px") {

  ## Check if file already exists ##
  file.overwrite <- T
  if(file.exists(file)) {
  file.overwrite <- readline(prompt="Files already exist, overwrite? (T/F)\n ")
  file.overwrite <- as.logical(file.overwrite)
  }

  if(file.overwrite) {
  ## Copy file from workspace_output and rename. ##
  file.copy(from="workspace_output.pdf", to=file, overwrite = TRUE)

  ## Copy html link to clipboard ##
  html.output <- paste0("<img src='",file,"' width='",html.width,"px' height='",html.height,"px'/>")

  clip <- pipe("pbcopy", "w")
  writeLines(html.output, clip)
  close(clip)
  }
}


#' Clear clipboard
#'
#' Function to clear the clipboard.
#'
#' @return
#' @export
#'
#' @examples
clean.cp <- function() {
  clip <- pipe("pbcopy", "w")
  writeLines("", clip)
  close(clip)
}
