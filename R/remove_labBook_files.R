

#' Remove labBook page
#'
#' Removes the code file, html file and index reference for a labBook page
#'
#' @param page_title
#' @param project
#'
#' @return
#' @export
#'
#' @examples
labBook_removePage <- function(page_title,
                               project_dir){

  if(missing(page_title)) {
    cat("\nPage name:\n\n")
    page_title <- readline()
    cat("\n\n\n")
  }

  # Default to the current project directory
  if(missing(project_dir)) { project_dir <- getwd() }

  # Infer directory name
  dir.name <- gsub("^.*/", "", project_dir)

  # Infer the project name
  project_name <- gsub("_", " ", dir.name)

  # Work out index path
  index_path <- file.path(project_dir, "../index.html")

  # Work out page name and code name
  safe.name <- labBook_makeSafeName(page_title)
  safe.name <- gsub("/", "_", safe.name)

  page.name <- paste0(safe.name,".html")
  code.name <- paste0(safe.name, ".R")

  # Remove the files
  unlink(file.path(project_dir, "pages", page.name))
  unlink(file.path(project_dir, "code", code.name))

  # Remove the index link
  index_page <- labBook_getFileContents(index_path)
  index_page <- labBook_removeLink(index_page   = index_page,
                                   project_name = project_name,
                                   page_name    = page_title)
  write(index_page, index_path)

}


