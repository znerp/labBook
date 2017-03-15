
#' Setup LabBook
#'
#' Function to initialise a labBook
#'
#' @param labBook_name Name of your LabBook
#' @param target_dir Directory in which to place your labBook
#' @param project_name Name of your first project
#'
#' @return
#' @export
#'
#' @examples
labBook_setup <- function(labBook_name,
                          target_dir,
                          project_name,
                          open_project = TRUE) {

  ## Strip trailing slashes
  target_dir <- gsub("/$", "", target_dir)

  ## Copy LabBook files to target directory
  file.copy(from      = file.path(labBook_packageLocation(),"LabBook/"),
            to        = target_dir,
            recursive = TRUE)

  ## Rename index labBook name
  index_path    <- file.path(target_dir,"LabBook","index.html")
  index_content <- readChar(index_path, file.info(index_path)$size)
  index_content <- gsub("\\[labbook_title\\]", labBook_name, index_content)
  write(index_content, file = index_path)

  ## Create the first project
  labBook_newProject(project.title = project_name,
                     project_dir   = file.path(target_dir, "LabBook"),
                     template_dir  = file.path(target_dir, "LabBook/templates/_template_project"),
                     open_project  = open_project)

}


#' Update LabBook
#'
#' Function to update lab book with new features and javascript etc.
#'
#' @param labBook_dir
#' @param clean_first
#'
#' @return
#' @export
#'
#' @examples
labBook_update <- function(labBook_dir) {

  ## Get package file locations
  labBook_package_files <- file.path(labBook_packageLocation(),"LabBook")

  ## Strip trailing slashes
  labBook_dir <- gsub("/$", "", labBook_dir)

  ## Delete old files if requested
  unlink(file.path(labBook_dir, "javascript"), recursive = TRUE)
  unlink(file.path(labBook_dir, "styles"),     recursive = TRUE)
  unlink(file.path(labBook_dir, "templates"),  recursive = TRUE)

  ## Copy over all files
  file.copy(from = file.path(labBook_package_files, "javascript"),
            to   = labBook_dir,
            overwrite = TRUE, recursive = TRUE)
  file.copy(from = file.path(labBook_package_files, "styles"),
            to   = labBook_dir,
            overwrite = TRUE, recursive = TRUE)
  file.copy(from = file.path(labBook_package_files, "templates"),
            to   = labBook_dir,
            overwrite = TRUE, recursive = TRUE)

}


labBook_packageLocation <- function(){

  find.package("labBook")

}
