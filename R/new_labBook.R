
labBook_setup <- function(labBook_name,
                          target_dir) {

  ## Copy LabBook files to target directory
  file.copy(from      = paste0(labBook_packageLocation(),"/LabBook/"),
            to        = target_dir,
            recursive = TRUE)

}


labBook_packageLocation <- function(){

  find.package("labBook")

}
