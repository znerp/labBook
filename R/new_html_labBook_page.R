#' New LabBook page
#'
#' Function for creating new LabBook page.
#'
#' @param page.title
#' @param code.file
#' @param project
#' @param open.files
#'
#' @return
#' @export
#'
#' @examples
make.new.page <- function(page.title,
                          code.file,
                          project,
                          open.files = TRUE){

  if(missing(code.file)){ code.file <- "workspace.R" }
  if(missing(project))  { dir.name  <- gsub("^.*/", "", getwd()) }
  else                  { dir.name  <- gsub(" ", "_", project)   }

  ## Work out page name and code name ##
  safe.name <- gsub(" ", "_", page.title)
  safe.name <- gsub("/", "_", safe.name)

  page.name <- paste0(safe.name,".html")
  code.name <- paste0(safe.name, ".R")

  ## Check if file exists already.
  file.overwrite <- T
  file.present   <- F
  if(file.exists(paste0("../",dir.name,"/",page.name)) | file.exists(paste0("../",dir.name,"/code/",code.name))) {
    file.present   <- T
    file.overwrite <- readline(prompt="Files already exist, overwrite? (T/F) ")
    file.overwrite <- as.logical(file.overwrite)
  }

  if(file.overwrite){

      ## First get the page template. ##
      page.template <- readChar("../_template_page.html", file.info("../_template_page.html")$size)

      ## Replace relevant aspects of the template. ##
      page.template <- gsub("\\[Title\\]", page.title, page.template)
      page.template <- gsub("\\[code_name\\]", code.name, page.template)
      page.template <- gsub("\\[creation_date\\]", Sys.Date(), page.template)

      ## Get the working from the current workspace ##
      R.code <- readChar(code.file, file.info(code.file)$size)

      ## Write the R code to another file ##
      write(R.code, file = paste0("../",dir.name,"/code/",code.name))

      ## Write the template page out ##
      write(page.template, file = paste0("../",dir.name,"/",page.name))

      ## Infer dir title ##
      dir.title <- gsub("_", " ", dir.name)

      ## Update index page. ##
      if(!file.present) {
      index.page <- readChar("../index.html", file.info("../index.html")$size)

      # Define project header.
      project.header <- paste0("<h3>",toupper(dir.title),"</h3><hr/>")

      # Get the section of html relating to the project.
      index.page.subset <- gsub(paste0('^.*(',project.header,'.*?)\n<div class="project">.*'),
                                '\\1',index.page)

      # Decide on the subtitle to put the page under.
      sub.titles <- strsplit(index.page.subset, "<h4>")[[1]]
      sub.titles <- sub.titles[grepl("</h4>",sub.titles)]
      sub.titles <- gsub("</h4>.*$","",sub.titles)

      # Offer choice of existing subtitles.
      print(data.frame(" "=sub.titles))
      sub.title.choice <- readline("\nSubtitle: ")

      if(sub.title.choice == "") {
        sub.title <- ""
      }
      if(grepl("[:upper:]",sub.title.choice) | grepl("[:lower:]",sub.title.choice)) {
        sub.title <- as.character(sub.title.choice)
      }
      if(!(grepl("[:upper:]",sub.title.choice) | grepl("[:lower:]",sub.title.choice)) & sub.title.choice != "") {
        sub.title <- sub.titles[as.numeric(sub.title.choice)]
      }

      # If no sub title exists, create it.
      if (sub.title!="") {
      if (!grepl(paste0("<h4>",toupper(sub.title),"</h4>"),index.page.subset)) {
        index.page.subset <- gsub(pattern     = paste0("(",project.header,".*)</div>"),
                                  replacement = paste0("\\1\n<h4>",toupper(sub.title),"</h4>\n</div>"),
                                  x           = index.page.subset)
      }
      }

      if (sub.title!="") { sub.header <- paste0("<h4>",toupper(sub.title),"</h4>") }
      else               { sub.header <- project.header }

      # Add page link to index page.
      index.page.subset <- gsub(pattern     = paste0('(',sub.header,'.*?)(\n\n|\n</div>)'),
                                replacement = paste0('\\1\n<a href="',dir.name,'/',page.name,'">',page.title,'</a>\\2'),
                                x           = index.page.subset)

      # Update index page but put the project at the top.
      project.tag  <- "<!-- PROJECTS //-->"
      index.page <- gsub(pattern     = paste0('(^.*)\n<div class="project">\n',project.header,'.*?(\n<div class="project">.*)'),
                         replacement = paste0('\\1\\2'),
                         x           = index.page)
      index.page <- gsub(pattern     = project.tag,
                         replacement = paste0(project.tag,'\n<div class="project">\n',index.page.subset),
                         x           = index.page)

      # Strip trailing newlines
      index.page <- gsub("</html>\n*","</html>",index.page)

      write(index.page, file = "../index.html")
      }

      ## Open files ready to edit ##
      if(open.files){
        file.edit(paste0("../",dir.name,"/code/",code.name))
        file.edit(paste0("../",dir.name,"/",page.name))
      }
  }

}

