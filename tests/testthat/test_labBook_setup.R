
setwd("../test_labBook/LabBook/")
rm(list=ls())

unlink("~/Desktop/LabBook/labbook_code/test_labBook/LabBook", recursive = TRUE)
labBook_setup("Test", "~/Desktop/LabBook/labbook_code/test_labBook", project_name = "My first project")

labBook_newProject("My first project")
