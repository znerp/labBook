

setwd("~/Desktop/LabBook/adjuvanted_vaccines/")



labBook_listProjects <- function(index_content){

  # Strip stuff before project section
  index_content <- labBook_isolateProjectSection(index_content)

  # Strip project names
  project_names <- strsplit(x = index_content, split = '<div class="project">')[[1]][-1]
  project_names <- gsub(".*<h3>(.*?)</h3>.*$", "\\1", project_names)
  project_names

}


labBook_listLinkedPages <- function(index_content){

  # Strip stuff before project section
  index_content <- labBook_isolateProjectSection(index_content)

  # Get page links
  page_links <- strsplit(x = index_content, split = 'href=("|\')')[[1]][-1]
  page_links <- gsub('("|\').*$', '', page_links)
  page_links

}

labBook_listCodePageFiles <- function(labBook_dir){

  # Hold page files
  code_files <- c()
  page_files <- c()

  # Cycle through dirs
  labBook_dirs <- list.dirs(labBook_dir, full.names = TRUE)

  for(test_dir in labBook_dirs){

    code_dir <- file.path(test_dir, "code")
    page_dir <- file.path(test_dir, "pages")

    if(file.exists(code_dir)){
      code_files <- c(code_files, list.files(code_dir, full.names = TRUE))
    }

    if(file.exists(page_dir)){
      page_files <- c(page_files, list.files(page_dir, full.names = TRUE))
    }

  }

  # Return file list
  output <- c()
  output$code_files <- code_files
  output$page_files <- page_files
  output

}


labBook_isolateProjectSection <- function(index_content){

  gsub("^.*<!-- PROJECTS \\/\\/-->", "", index_content)

}


labBook_listUnidexedFiles <- function(labBook_dir){

  # Assume you are in a project folder if labBook dir not specified
  if(missing(labBook_dir)){ labBook_dir <- "../" }
  labBook_dir <- normalizePath(labBook_dir)

  # Read the index page
  index_content <- labBook_getFileContents(file.path(labBook_dir, "index.html"))

  # Get the page links
  page_links <- file.path(labBook_dir, labBook_listLinkedPages(index_content))
  code_links <- gsub("/pages/(.*?)\\.html", "/code/\\1.R", page_links)

  # Get all code and page files
  existing_files <- labBook_listCodePageFiles(labBook_dir)

  # Work out pages not linked
  unlinked_pages <- existing_files$page_files[!existing_files$page_files %in% page_links]
  unlinked_code  <- existing_files$code_files[!existing_files$code_files %in% code_links]

  # Work out which page links are broken
  broken_page_links <- page_links[!page_links %in% existing_files$page_files]

  # Return output
  output <- c()
  output$unlinked_pages    <- unlinked_pages
  output$unlinked_code     <- unlinked_code
  output$broken_page_links <- broken_page_links
  output

}

# unindexed_files <- labBook_listUnidexedFiles()
# unlinked_pages  <- unindexed_files$unlinked_pages
#
# index_page <- labBook_getFileContents("~/Desktop/LabBook/index.html")
#
# for(file_num in 16){
#   subtitle  <- "Visualising data"
#   page_name <- gsub(".*/", "", unlinked_pages[file_num])
#   page_name <- gsub("\\.html$", "", page_name)
#   page_name <- gsub("_", " ", page_name)
#   substr(page_name, 1, 1) <- toupper(substr(page_name, 1, 1))
#   project_name <- gsub(".*/LabBook/", "", unlinked_pages[file_num])
#   project_name <- gsub("/.*$", "", project_name)
#   project_name <- gsub("_", " ", project_name)
#
#   # Add page link to index page.
#   index_page <- labBook_appendLink(index_page   = index_page,
#                                    project_name = project_name,
#                                    page_name    = page_name,
#                                    subtitle     = subtitle)
#
#   # Tidy index page
#   index_page <- gsub("</html>\n*","</html>",index_page)
#
# }
#
#
# # Write index page
# write(index_page, file = "~/Desktop/LabBook/index.html")




