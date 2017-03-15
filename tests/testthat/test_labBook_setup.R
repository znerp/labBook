





stop()

## Set a temporary directory
labBook_dir <- tempdir()
unlink(paste0(labBook_dir, "/LabBook"), recursive = TRUE)

project1_name <- "My first project"
project2_name <- "Second project"

## Setup the labBook
labBook_setup(labBook_name = "Sam's labBook",
              target_dir   = labBook_dir,
              project_name = project1_name,
              open_project = FALSE)

## Add a second project
labBook_newProject(project.title = project2_name,
                   project_dir   = file.path(labBook_dir, "LabBook"),
                   open_project  = FALSE)

## Add a page
labBook_newPage(page_name   = "Page 1",
                code.file   = file.path(labBook_dir, "LabBook", labBook_makeSafeName(project1_name), "workspace.R"),
                project_dir = file.path(labBook_dir, "LabBook", labBook_makeSafeName(project1_name)),
                subtitle    = "Subtitle no. 1",
                open.files  = FALSE)

## Add a page
labBook_newPage(page_name   = "Pp 2",
                code.file   = file.path(labBook_dir, "LabBook", labBook_makeSafeName(project2_name), "workspace.R"),
                project_dir = file.path(labBook_dir, "LabBook", labBook_makeSafeName(project2_name)),
                subtitle    = "",
                open.files  = FALSE)

labBook_newPage(page_name   = "Pp 3",
                code.file   = file.path(labBook_dir, "LabBook", labBook_makeSafeName(project2_name), "workspace.R"),
                project_dir = file.path(labBook_dir, "LabBook", labBook_makeSafeName(project2_name)),
                subtitle    = "Hello",
                open.files  = FALSE)

labBook_newPage(page_name   = "Pp 4",
                code.file   = file.path(labBook_dir, "LabBook", labBook_makeSafeName(project2_name), "workspace.R"),
                project_dir = file.path(labBook_dir, "LabBook", labBook_makeSafeName(project2_name)),
                subtitle    = "Hello",
                open.files  = FALSE)

## Remove a page
labBook_removePage(page_title  = "Pp 2",
                   project_dir = file.path(labBook_dir, "LabBook", labBook_makeSafeName(project2_name)))


#system2("open", labBook_dir)
system2("open", file.path(labBook_dir, "LabBook/index.html"))

#unlink(paste0(labBook_dir, "/LabBook"), recursive = TRUE)

# index_page <- labBook_getFileContents("~/LabBook/index.html")
# index_page <- labBook_appendLink(index_page   = index_page,
#                                  project_name = "Adjuvanted vaccines",
#                                  page_name    = "Test page",
#                                  subtitle     = "Making maps with human data")
# index_page <- labBook_removeLink(index_page   = index_page,
#                                  project_name = "Adjuvanted vaccines",
#                                  page_name    = "Group averages")
# project_section <- labBook_getProjectSection("Adjuvanted vaccines", index_page)
# cat(project_section)
