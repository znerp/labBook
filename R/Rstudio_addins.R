
## Function for editing webpage associated with current code document
edit_webpage <- function(){
  doc_info  <- rstudioapi::getActiveDocumentContext()
  code_path <- doc_info$path
  html_path <- gsub("\\.R", "\\.html", code_path)
  html_path <- gsub("code/", "", html_path)
  file.edit(html_path)
}

## Function for viewing webpage associated with current code document
open_webpage <- function(){
  doc_info  <- rstudioapi::getActiveDocumentContext()
  code_path <- doc_info$path
  html_path <- gsub("\\.R", "\\.html", code_path)
  html_path <- gsub("code/", "", html_path)
  system(paste("open",html_path))
}

