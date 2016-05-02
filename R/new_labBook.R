
#' Setup LabBook
#'
#' Function to initialise a labBook
#'
#' @param labBook_name
#' @param target_dir
#'
#' @return
#' @export
#'
#' @examples
labBook_setup <- function(labBook_name,
                          target_dir,
                          project_name) {

  ## Strip trailing slashes
  target_dir <- gsub("/$", "", target_dir)

  ## Copy LabBook files to target directory
  file.copy(from      = paste0(labBook_packageLocation(),"/LabBook/"),
            to        = target_dir,
            recursive = TRUE)

  ## Create the first project
  labBook_newProject(project.title = project_name,
                     project_dir   = file.path(target_dir, "LabBook"),
                     template_dir  = file.path(target_dir, "LabBook/templates/_template_project"))

}


labBook_packageLocation <- function(){

  find.package("labBook")

}
