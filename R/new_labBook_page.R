
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
labBook_newPage <- function(page.title,
                            code.file,
                            project,
                            open.files = TRUE){

  if(missing(page.title)) {
    cat("\nPage name:\n\n")
    page.title <- readline()
    cat("\n\n\n")
  }

  if(missing(code.file)){ code.file <- "workspace.R" }
  if(missing(project))  { dir.name  <- gsub("^.*/", "", getwd()) }
  else                  { dir.name  <- gsub(" ", "_", project)   }

  ## Work out page name and code name ##
  safe.name <- gsub(" ", "_", page.title)
  safe.name <- gsub("/", "_", safe.name)

  page.name <- paste0(safe.name,".html")
  code.name <- paste0(safe.name, ".R")

  ## Check if file exists already.
  if(file.exists(paste0("../",dir.name,"/",page.name)) |
     file.exists(paste0("../",dir.name,"/code/",code.name))) {
    stop("File already exists")
  }


  ## Make HTML file -----------
  # First get the page template.
  page.template <- readChar("../templates/_template_page.html", file.info("../templates/_template_page.html")$size)

  # Replace relevant aspects of the template.
  page.template <- gsub("\\[Title\\]", page.title, page.template)
  page.template <- gsub("\\[code_name\\]", code.name, page.template)
  page.template <- gsub("\\[creation_date\\]", Sys.Date(), page.template)

  # Write the template page out
  write(page.template, file = paste0("../",dir.name,"/",page.name))


  ## Make code file -----------
  # Get the working from the current workspace
  R.code <- readChar(code.file, file.info(code.file)$size)

  # Write the R code to another file
  write(R.code, file = paste0("../",dir.name,"/code/",code.name))


  ## Update index page ----------
  # Infer dir title
  dir.title <- gsub("_", " ", dir.name)

  # Get index page content
  index.page <- readChar("../index.html", file.info("../index.html")$size)

  # Define project header.
  project.header <- paste0("<h3>",toupper(dir.title),"</h3><hr/>")

  # Get the section of html relating to the project.
  index.page.subset <- gsub(pattern     = paste0('^.*(<div class="project">\n',project.header,'.*?</div>).*$'),
                            replacement = '\\1',
                            x           = index.page)

  # Decide on the subtitle to put the page under.
  sub.titles <- strsplit(index.page.subset, "<h4>")[[1]]
  sub.titles <- sub.titles[grepl("</h4>",sub.titles)]
  sub.titles <- gsub("</h4>.*$","",sub.titles)

  # Offer choice of existing subtitles.
  print(data.frame(" "=sub.titles))
  cat("\n\nSubtitle:\n\n")
  sub.title.choice <- readline()

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
      index.page.subset <- gsub(pattern     = paste0("(",project.header,".*?)</div>"),
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
  index.page <- gsub(pattern     = paste0('\n<div class="project">\n',project.header,'.*?</div>'),
                     replacement = paste0(''),
                     x           = index.page)
  index.page <- gsub(pattern     = project.tag,
                     replacement = paste0(project.tag, '\n', index.page.subset),
                     x           = index.page)

  # Strip trailing newlines
  index.page <- gsub("</html>\n*","</html>",index.page)

  # Write index page
  write(index.page, file = "../index.html")

  ## Open files ready to edit ##
  if(open.files){
    file.edit(paste0("../",dir.name,"/code/",code.name))
    file.edit(paste0("../",dir.name,"/",page.name))
  }

}

