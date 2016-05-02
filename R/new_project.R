make.new.project <- function(project.title){
  
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

  # Write a new page setting up the workspace
  #make.new.page(page.title = "Set up workspace",
  #              code.file = paste0("../",safe.title,"/workspace.R"),
  #              project = project.title,
  #              open.files = FALSE)
  
  # Open the new project
  system2("open", paste0("../",safe.title,"/",safe.title,".Rproj"))
  
  # Save lines to clipboard
  clip <- pipe("pbcopy", "w")                       
  writeLines('file.edit("workspace.R")\nsource("workspace.R")\nmake.new.page("Set up workspace")', clip)                               
  close(clip)
  
}

