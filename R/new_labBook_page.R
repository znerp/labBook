
#' New LabBook page
#'
#' Function for creating new LabBook page.
#'
#' @param page_name
#' @param code.file
#' @param project
#' @param open.files
#'
#' @return
#' @export
#'
#' @examples
labBook_newPage <- function(page_name,
                            code.file,
                            project_dir,
                            subtitle,
                            open.files = TRUE){

  # Ask for input on the page title if not provided
  if(missing(page_name)) {
    cat("\nPage name:\n\n")
    page_name <- readline()
    cat("\n\n\n")
  }

  # Default to the workspace as the code file
  if(missing(code.file)) { code.file <- "workspace.R" }

  # Default to the current project directory
  if(missing(project_dir)) { project_dir <- getwd() }

  # Infer directory name
  project_dir <- gsub("/$", "", project_dir)
  dir.name    <- gsub("^.*/", "", project_dir)

  # Infer the project name
  project_name <- gsub("_", " ", dir.name)

  # Work out index path
  index_path <- file.path(project_dir, "../index.html")

  ## Work out page name and code name ##
  safe.name <- labBook_makeSafeName(page_name)
  page.name <- paste0(safe.name,".html")
  code.name <- paste0(safe.name, ".R")

  ## Work out the path to output the new page
  new_page_path <- file.path(project_dir, "pages", page.name)
  new_code_path <- file.path(project_dir, "code", code.name)

  ## Check if file exists already.
  if(file.exists(new_page_path) |
     file.exists(new_code_path)) {
    stop("File already exists please remove the existing file first")
  }


  ## Make HTML file -----------
  # First get the page template.
  template_file <- system.file("LabBook/templates/_template_page.html", package="labBook")
  page.template <- readChar(template_file, file.info(template_file)$size)

  # Replace relevant aspects of the template.
  page.template <- gsub("\\[Title\\]", page_name, page.template)
  page.template <- gsub("\\[code_name\\]", code.name, page.template)
  page.template <- gsub("\\[creation_date\\]", Sys.Date(), page.template)

  # Write the template page out
  write(page.template, file = new_page_path)


  ## Make code file -----------
  # Get the working from the current workspace
  R.code <- readChar(code.file, file.info(code.file)$size)

  # Write the R code to another file
  write(R.code, file = new_code_path)


  ## Update index page ----------
  # Get index page content
  index_page <- labBook_getFileContents(index_path)

  # Get subtitle
  subtitle <- labBook_selectSubtitle(project_name = project_name,
                                     index_page   = index_page,
                                     subtitle     = subtitle)

  # Add page link to index page.
  index_page <- labBook_appendLink(index_page   = index_page,
                                   project_name = project_name,
                                   page_name    = page_name,
                                   subtitle     = subtitle)

  # Tidy index page
  index_page <- gsub("</html>\n*","</html>",index_page)

  # Write index page
  write(index_page, file = index_path)

  ## Open files ready to edit ##
  if(open.files){
    file.edit(new_code_path)
    file.edit(new_page_path)
    open_webpage(new_page_path)
  }

}



#' Get file contents
#'
#' @param filepath
#'
#' @return
#' @export
#'
#' @examples
labBook_getFileContents <- function(filepath){
  readChar(filepath, file.info(filepath)$size)
}

labBook_getProjectSection <- function(project_name,
                                      index_page){

  # Define project header.
  project_header <- paste0("<h3>",toupper(project_name),"</h3><hr/>")

  # Get the section of html relating to the project.
  project_subset <- gsub(pattern     = paste0('^.*(<div class="project">\n*',project_header,'.*?</div>).*$'),
                         replacement = "\\1",
                         x           = index_page)

  # Return the project subset
  project_subset

}

labBook_appendLink <- function(index_page,
                               project_name,
                               page_name,
                               subtitle = ""){

  # Decide subheader
  if(subtitle == ""){ subheader <- paste0("<h3>",toupper(project_name),"</h3><hr/>") }
  else              { subheader <- paste0("<h4>",toupper(subtitle),"</h4>")          }

  # Infer project directory name
  proj_dir  <- labBook_makeSafeName(project_name)
  page_link <- labBook_makeSafeName(page_name)

  # Get the relevant project section
  project_section <- labBook_getProjectSection(project_name, index_page)

  # Add subtitle if it doesn't already exist
  if(subtitle != "" &
     !grepl(subheader, project_section)) {
    project_section <- gsub(pattern     = "<\\/div>$",
                            replacement = paste0("\n<h4>", toupper(subtitle), "</h4>\n</div>"),
                            x           = project_section)
  }

  # Add page link to index page.
  project_section <- gsub(pattern     = paste0('(',subheader,'.*?)(\n\n|\n</div>)'),
                          replacement = paste0('\\1\n<a href="',proj_dir,'/pages/',page_link,'.html">',page_name,'</a>\\2'),
                          x           = project_section)

  # Update index
  index_page <- labBook_replaceProjectSection(index_page, project_name)
  index_page <- labBook_addProjectSection(index_page, project_section)
  index_page

}


labBook_removeLink <- function(index_page,
                               project_name,
                               page_name){

  # Infer project directory name
  proj_dir  <- labBook_makeSafeName(project_name)
  page_link <- labBook_makeSafeName(page_name)

  # Get the relevant project section
  project_section <- labBook_getProjectSection(project_name, index_page)

  # Remove the link
  link_pattern <- paste0('\n<a[^\n]*>', page_name, '<[^\n]*')
  if(!grepl(link_pattern, project_section)){
    warning(paste0('Page "', page_name, '" not found in project "', project_name, '"'))
  }
  project_section <- gsub(pattern     = link_pattern,
                          replacement = "",
                          x           = project_section)

  # Replace the project section
  labBook_replaceProjectSection(index_page   = index_page,
                                project_name = project_name,
                                replacement  = project_section)

}



labBook_replaceProjectSection <- function(index_page,
                                          project_name,
                                          replacement = ""){

  # Define project header.
  project_header <- paste0("<h3>",toupper(project_name),"</h3><hr/>")

  # Get the section of html relating to the project.
  gsub(pattern     = paste0('(^.*)(<div class="project">\n*',project_header,'.*?</div>)(.*$)'),
       replacement = paste0('\\1', replacement,'\\3'),
       x           = index_page)

}

labBook_addProjectSection <- function(index_page,
                                      project_html){

  project_tag  <- "<!-- PROJECTS //-->"
  gsub(project_tag, paste0(project_tag, "\n", project_html), index_page)

}

labBook_selectSubtitle <- function(project_name,
                                   index_page,
                                   subtitle){

  # Simply return the subtitle if one is provided
  if(!missing(subtitle)){ return(subtitle) }

  # Get project section
  project_section <- labBook_getProjectSection(project_name = project_name,
                                               index_page   = index_page)

  # Decide on the subtitle to put the page under.
  sub_titles <- strsplit(project_section, "<h4>")[[1]]
  sub_titles <- sub_titles[grepl("</h4>",sub_titles)]
  sub_titles <- gsub("</h4>.*$","",sub_titles)

  # Offer choice of existing subtitles.
  print(data.frame(" "=sub_titles))
  cat("\n\nSubtitle:\n\n")
  sub_title_choice <- readline()

  if(sub_title_choice == "") {
    subtitle <- ""
  }
  if(as.numeric(sub_title_choice) %in% 1:length(sub_titles)) {
    subtitle <- sub_titles[as.numeric(sub_title_choice)]
  }
  else {
    subtitle <- as.character(sub_title_choice)
  }

  # Return the subtitle
  subtitle

}


# index_page <- labBook_getFileContents("~/LabBook/index.html")
# index_page <- labBook_appendLink(index_page   = index_page,
#                                  project_name = "Adjuvanted vaccines",
#                                  page_name    = "Test page",
#                                  subtitle     = "Making maps with human data")
# index_page <- labBook_removeLink(index_page   = index_page,
#                                  project_name = "Adjuvanted vaccines",
#                                  page_name    = "Group averages")
# project_section <- labBook_getProjectSection("Adjuvanted vaccines", index_page)
# # subtitle <- labBook_selectSubtitle(project_name = "Adjuvanted vaccines",
# #                                    index_page   = index_page)
# # print(subtitle)
# cat(project_section)


#' Make safe file name
#'
#' @param file_name
#'
#' @return
#' @export
#'
#' @examples
labBook_makeSafeName <- function(file_name){

  safe.name <- gsub(" ", "_", file_name)
  safe.name <- gsub("/", "_", safe.name)
  safe.name <- tolower(safe.name)
  safe.name

}




unlink("~/Desktop/Nils/LabBook/modelling_b_cells/pages/test.html")
unlink("~/Desktop/Nils/LabBook/modelling_b_cells/code/test.R")

labBook_newPage(page_name   = "test",
                code.file   = "~/Desktop/Nils/LabBook/modelling_b_cells/workspace.R",
                project_dir = "~/Desktop/Nils/LabBook/modelling_b_cells/",
                open.files  = FALSE,
                subtitle    = "B CELL MODELS")
