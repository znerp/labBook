
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

## Function for updating antibody landscapes package to latest version
update_AbLandscapes <- function(){
  devtools::install_github(repo                 = "sw463/ab-landscapes",
                           auth_token           = "0e26b2eb12d2d6c0c3290a3476719d986b306dec",
                           subdir               = "AbLandscapes",
                           type                 = "source",
                           upgrade_dependencies = FALSE)
}

## Function for updating labbook to latest version
update_LabBook_pkg <- function(){
  remove.packages("labBook")
  install.packages("../labbook_code/labBook_0.1.0.tar.gz", repos = NULL, type="source")
}

