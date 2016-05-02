
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
labBook_newProject <- function(project.title){

  ## Work out page name and code name ##
  safe.title <- tolower(project.title)
  safe.title <- gsub(" ", "_", safe.title)
  safe.title <- gsub("/", "_", safe.title)

  ## Create project directory
  dir.create(paste0("../",safe.title))

  ## Copy files from project template
  lapply(list.files("../_template_project/",full.names = T),
         file.copy,
         to = paste0("../",safe.title),
         recursive = TRUE)

  file.rename(from = paste0("../",safe.title,"/_template_project.Rproj"),
              to   = paste0("../",safe.title,"/",safe.title,".Rproj"))

  # Save the command history
  savehistory()

  # Save the workspace
  save.image()

  # Update the index page
  # If no project section exists, create it.
  index.page   <- readChar("../index.html", file.info("../index.html")$size)
  project.tag  <- "<!-- PROJECTS //-->"
  project.html <- paste0(project.tag,'\n<div class="project">\n<h3>',toupper(project.title),
                         '</h3><hr/>\n</div>\n')
  index.page   <- gsub(project.tag, project.html, index.page)
  write(index.page, file = "../index.html")

  # Open the new project
  system2("open", paste0("../",safe.title,"/",safe.title,".Rproj"))

}

