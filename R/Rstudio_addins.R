
## Function for editing webpage associated with current code document
edit_webpage <- function(){
  doc_info  <- rstudioapi::getActiveDocumentContext()
  code_path <- doc_info$path
  html_path <- gsub("\\.R", "\\.html", code_path)
  html_path <- gsub("/code/", "/pages/", html_path)
  file.edit(html_path)
}

## Function for editing webpage associated with current code document
edit_code <- function(){
  doc_info  <- rstudioapi::getActiveDocumentContext()
  html_path <- doc_info$path
  code_path <- gsub("\\.html", "\\.R", html_path)
  code_path <- gsub("/pages/", "/code/", code_path)
  file.edit(code_path)
}

## Function for viewing webpage associated with current code document
open_webpage <- function(html_path){
  if(missing(html_path)) {
    doc_info  <- rstudioapi::getActiveDocumentContext()
    code_path <- doc_info$path
    html_path <- gsub("\\.R", "\\.html", code_path)
    html_path <- gsub("/code/", "/pages/", html_path)
  }
  tryCatch(expr = { system2("open", html_path) },
           error = function(e){ system2("start", html_path) })
}

