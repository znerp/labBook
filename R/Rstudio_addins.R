
## Function for editing webpage associated with current code document
edit_webpage <- function(){
  doc_info  <- rstudioapi::getActiveDocumentContext()
  code_path <- doc_info$path
  html_path <- gsub("\\.R", "\\.html", code_path)
  html_path <- gsub("/code/", "/", html_path)
  file.edit(html_path)
}

## Function for editing webpage associated with current code document
edit_code <- function(){
  doc_info  <- rstudioapi::getActiveDocumentContext()
  html_path <- doc_info$path
  code_path <- gsub("\\.html", "\\.R", html_path)
  code_path <- gsub("(^.*/)(.*?)$", "\\1code/\\2", code_path)
  file.edit(code_path)
}

## Function for viewing webpage associated with current code document
open_webpage <- function(){
  doc_info  <- rstudioapi::getActiveDocumentContext()
  code_path <- doc_info$path
  html_path <- gsub("\\.R", "\\.html", code_path)
  html_path <- gsub("/code/", "/", html_path)
  system(paste("open",html_path))
}

