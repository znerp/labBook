
#' New labBook project
#'
#' Function to setup a new labBook project.
#'
#' @param project.title
#'
#' @return
#' @export
#'
#' @examples
labBook_newProject <- function(project.title,
                               project_dir  = "..",
                               template_dir,
                               open_project = TRUE){

  # Get standard template if template_dir is missing
  if(missing(template_dir)) {
    template_dir <- system.file("LabBook/templates/_template_project", package="labBook")
  }

  ## Work out page name and code name ##
  safe.title <- labBook_makeSafeName(project.title)

  ## Stop if project directory already exists
  if(dir.exists(file.path(project_dir, safe.title))){
    stop("Project already exists, please remove the existing project first")
  }

  ## Create project directory
  dir.create(file.path(project_dir, safe.title))

  ## Copy files from project template
  lapply(X         = list.files(template_dir, full.names = T, include.dirs = T),
         FUN       = file.copy,
         to        = file.path(project_dir, safe.title),
         recursive = TRUE)

  project_file <- paste0(safe.title,".Rproj")
  file.rename(from = file.path(project_dir, safe.title, "_template_project.Rproj"),
              to   = file.path(project_dir, safe.title, project_file))

  # Save the command history
  savehistory()

  # Save the workspace
  save.image()

  # Update the index page
  index_path   <- file.path(project_dir, "index.html")
  project_html <- paste0('<div class="project">\n<h3>',toupper(project.title),'</h3><hr/>\n</div>')
  index_page   <- labBook_getFileContents(index_path)
  index_page   <- labBook_addProjectSection(index_page   = index_page,
                                            project_html = project_html)
  write(index_page, file = index_path)

  # Open the new project
  if(open_project) {
    system2("open", file.path(project_dir, safe.title, project_file))
  }

}

