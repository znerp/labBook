write.pdf <- function(file, width=7, height=7, html.height=600, add2cp=F, save2cp=T, ...){
  pdf(file=file, width=width, height=height, ...)
  
  x.y.aspect <- width/height
  html.width <- round(html.height*x.y.aspect)
  
  ## Copy html link to clipboard ##
  html.output <- ""
  if(add2cp) { html.output <- readLines(pipe("pbpaste")) }
  png.name <- gsub("pdf$","png",file)
  html.output <- c(html.output,paste0("<a href='",file,"'><img src='",png.name,"' style='height:",html.height,"px'/></a>"))
  
  if(save2cp) {
    clip <- pipe("pbcopy", "w")                       
    writeLines(html.output, clip)                               
    close(clip)
  }
  
  pdf.off <<- function(){
    dev.off()
    # Escape brackets
    file <- gsub("\\(","\\\\(",file)
    file <- gsub("\\)","\\\\)",file)
    png.name <- gsub("pdf$","png",eval(file))
    system(paste0('sips -s format png ',eval(file),' --out ',png.name),
           ignore.stdout = TRUE)
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


## Function to clear the clipboard.
clean.cp <- function() {
  clip <- pipe("pbcopy", "w")                       
  writeLines("", clip)                               
  close(clip)
}
