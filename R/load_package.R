

load_AbLandscapes <- function(version){

  ## Try to get current package version and if not installed, install.
  if(!"AbLandscapes" %in% rownames(installed.packages())) {
    install_AbLandscapes(version)
  }
  else {
    ## If package version does not equal requested version, remove and reinstall.
    current_version <- packageVersion("AbLandscapes")
    if(current_version != version) {
      #remove.packages("AbLandscapes")
      install_AbLandscapes(version)
    }
  }

}

install_AbLandscapes <- function(version){
  # Install antibody landscapes package
  pkg_archive <- "~/Desktop/LabBook/developing_antibody_landscapes/ab-landscapes/package_archive/"
  pkg_path <- paste0(pkg_archive,"AbLandscapes_",version,".tar.gz")
  install.packages(pkg_path, repos = NULL, type="source")

  # Check version of RGL
  if(packageVersion("rgl") != "0.95.1337") {
    install.packages("https://cran.r-project.org/src/contrib/Archive/rgl/rgl_0.95.1337.tar.gz", repos=NULL)
  }
}

