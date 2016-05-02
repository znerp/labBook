
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
                               template_dir = "../templates/_template_project"){

  ## Work out page name and code name ##
  safe.title <- tolower(project.title)
  safe.title <- gsub(" ", "_", safe.title)
  safe.title <- gsub("/", "_", safe.title)

  ## Create project directory
  dir.create(file.path(project_dir, safe.title))

  ## Copy files from project template
  lapply(X         = list.files(template_dir, full.names = T),
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
  # If no project section exists, create it.
  index_path   <- file.path(project_dir, "index.html")
  index.page   <- readChar(index_path, file.info(index_path)$size)
  project.tag  <- "<!-- PROJECTS //-->"
  project.html <- paste0(project.tag,'\n<div class="project">\n<h3>',toupper(project.title),
                         '</h3><hr/>\n</div>\n')
  index.page   <- gsub(project.tag, project.html, index.page)
  write(index.page, file = index_path)

  # Open the new project
  system2("open", file.path(project_dir, safe.title, project_file))

}

