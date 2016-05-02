#### Functions for submitting R code to an HTCondor cluster directly from the R console and an R script file. ####
## Author : Sam Wilks


#### Function for submitting code to be run on the cluster. ####
submit.HTCondor <- function(code.file, job.name, num.runs=1){
  
  # Decide code.file, if not specified list all code files in directory "code/".
  if(missing(code.file)) {
    all.code.files <- list.files.by.date("code")
    print(data.frame(" "=all.code.files)[1:10,])
    code.choice <- readline("\nCode file: ")
    code.file   <- all.code.files[as.numeric(code.choice)]
    code.file   <- paste0("code/",code.file)
  }
  
  # Decide job name and make it safe, if not specified just create a safe variant of the code file name.
  if(missing(job.name)) {
    job.name = gsub("\\.R$","", code.file)
    job.name = gsub("^code\\/","", job.name)
  }
  job.name <- gsub(" ", "_", job.name)
  
  ## Look for an HT Condor directory at location "ht_condor" and create it if necessary.
  if(!file.exists("ht_condor")) { dir.create("ht_condor") }
  
  ## Create a working directory for the submission within the ht_condor folder, if it already exists, *it will be emptied*.
  local.dir <- file.path("ht_condor",job.name)
  wd.name   <- gsub("^.*/","",getwd())
  
  if(file.exists(local.dir)) { unlink(local.dir,recursive = T) }
  dir.create(local.dir)
  dir.create(file.path(local.dir,"data"))    # Creates a directory for storing sent data
  dir.create(file.path(local.dir,"output"))  # Creates a directory for storing retrieved data
  
  
  ## These next steps load up the required files, edit the code in various ways and save the workspace.
  # Get code text
  code.text  <- readChar(code.file, file.info(code.file)$size)
  
  
  # Find any references in the code file to the function "load()".
  text.match <- gregexpr("load\\(.*?\\)", code.text)
  
  start.chars   <- as.numeric(text.match[[1]])
  match.lengths <- attr(text.match[[1]],"match.length")
  
  # Load in these files so that they are already included in the workspace.
  for(x in 1:length(start.chars)) {
    matched.text <- substr(code.text,start.chars[x],start.chars[x]+match.lengths[x]-1)
    eval(parse(text=matched.text))
  }
  
  # Save the new workspace image with all the required files already loaded
  save(list=ls(),file = file.path(local.dir,"data/workspace_sent.RData"))
  
  
  # Find references in the code to sourced files.
  while(grepl("source\\(.*?\\)", code.text)) {
    
    text.match    <- gregexpr("source\\(.*?\\)", code.text)
    start.chars   <- as.numeric(text.match[[1]])
    match.lengths <- attr(text.match[[1]],"match.length")
    original.code <- code.text
    
    # Replace the references to sourced files with the actual code in the sourced file.
    for(x in 1:length(start.chars)) {
      matched.text <- substr(original.code,start.chars[x],start.chars[x]+match.lengths[x]-1)      
      source.file  <- gsub("^source\\(.", "", matched.text)
      source.file  <- gsub(".\\)$"      , "", source.file)
      source.text  <- readChar(source.file, file.info(source.file)$size)
      matched.text <- gsub("\\(","\\\\(",matched.text)
      matched.text <- gsub("\\)","\\\\)",matched.text)
      code.text    <- gsub(matched.text,source.text,code.text)
    }
  }
  
  # Edit code text to comment out any references to clearing the workspace or loading files, which are now already loaded.
  code.text <- gsub("(\n| )load\\(","\\1# load\\(",code.text)
  code.text <- gsub("(\n| |^)rm\\(","\\1# rm\\(",code.text)
  
  # Output the edited code file in the file "data/rscript.R"
  write(code.text, file = file.path(local.dir,"data/rscript.R"))
  
  
  ## These next steps are more specific for submitting to an HTCondor cluster using my account.
  # Copy the standard HTCondor submit file (if you need this ask) and edit it.
  submit.path <- file.path(local.dir,"submit_file.sub")
  file.copy(from = "../templates/template.sub", to = submit.path)
  submit.text <- readChar(submit.path, file.info(submit.path)$size)
  submit.text <- gsub("\\[job_name\\]",job.name,submit.text)
  submit.text <- gsub("\\[wd_name\\]" ,wd.name ,submit.text)
  submit.text <- gsub("\\[num_runs\\]" ,num.runs ,submit.text)
  write(submit.text, file = submit.path)
  
  # Finally copy over the running code and name it based on the job name sent.
  required.packages <- search()
  required.packages <- required.packages[grepl("package", required.packages)]
  required.packages <- gsub("package:","",required.packages)
  require.code <- c()
  for(pkg.name in required.packages) {
    require.code <- c(require.code, paste0("require(",pkg.name,")\n"))
  }
  require.code <- paste(require.code,collapse = "")
  code.file.path <- "../templates/run_code.R"
  code.file <- readChar(code.file.path, file.info(code.file.path)$size)
  code.file <- gsub("\\[required_packages\\]",require.code,code.file)
  write(code.file, file = paste0(local.dir,"/data/run_",job.name,"_code.R"))
  
  # Now copy the files to the server - assumes you have set up a shared key.
  system(paste0("ssh samwilks@albertine.antigenic-cartography.org ' mkdir -p /syn/samwilks/htcondor/",wd.name," '"))
  system(paste0("ssh samwilks@albertine.antigenic-cartography.org ' rm -rf /syn/samwilks/htcondor/",wd.name,"/",job.name," '"))
  system(paste0("scp -r /Users/samwilks/Desktop/LabBook/",wd.name,"/ht_condor/",job.name," samwilks@albertine.antigenic-cartography.org:/syn/samwilks/htcondor/",wd.name,"/",job.name))
  
  # Now run the code to submit the job to the cluster.
  system(paste0("ssh samwilks@albertine.antigenic-cartography.org ' condor_submit /syn/samwilks/htcondor/",wd.name,"/",job.name,"/submit_file.sub '"))
  
}




#### Function for fetching code from the cluster. ####
get.HTCondor <- function(job.name="") {
  
  ## If job name not specified, list the jobs currently uploaded to the cluster.
  if(job.name=="") {
    all.jobs <- list.files("ht_condor/")[order(sapply(list.files("ht_condor/",full.names = T),function(x){file.info(x)$mtime}))]
    print(data.frame(" "=all.jobs))
    job.choice <- readline("\nJob num: ")
    job.name <- all.jobs[as.numeric(job.choice)]
  }
  
  ## Make the job name a safe variant if necessary
  job.name <- gsub(" ", "_", job.name)
  
  ## Inform that job results are being fetched.
  cat(paste0("\nFetching job '",job.name,"'\n\n"))
  
  ## Work out the relevant directory based on your current working directory.
  local.dir <- file.path("ht_condor",job.name)
  wd.name   <- gsub("^.*/","",getwd())
  
  ## Retrieve the output files from the server.
  system(paste0("scp -r samwilks@albertine.antigenic-cartography.org:/syn/samwilks/htcondor/",wd.name,"/",job.name,"/* /Users/samwilks/Desktop/LabBook/",wd.name,"/ht_condor/",job.name,"/"))
  
  # Copy over any image files into your local "image" directory *replacing any currently matching images*.
  file.copy(from = file.path(local.dir,"output/images"),
            to   = getwd(), overwrite = TRUE, recursive = TRUE)
  
  # ..and any data files *replacing any currently matching data files*.
  file.copy(from = file.path(local.dir,"output/data"),
            to   = getwd(), overwrite = TRUE, recursive = TRUE)
  
  ## Load up the output R workspace into your local R workspace if each file exists.
  error.outputs <- list.files(local.dir)
  error.outputs <- error.outputs[grepl("^error", error.outputs)]
  for(n in 1:length(error.outputs)) {
    cat(paste0("Loading output from job ",n,"..."))
    if(file.exists(paste0(local.dir,"/output/workspace_received",n,".RData"))) {
      load(paste0(local.dir,"/output/workspace_received",n,".RData"), envir = .GlobalEnv)
      cat("done.")
    }
    ## If the workspace output file does not exist, explore why.
    else {
      # Find and read the error output file.
      error.path <- paste0("/Users/samwilks/Desktop/LabBook/",wd.name,"/ht_condor/",job.name,"/error_",n-1,".txt")
      error.text <- readChar(error.path, file.info(error.path)$size)
      # Find and read the log output file.
      log.path <- paste0("/Users/samwilks/Desktop/LabBook/",wd.name,"/ht_condor/",job.name,"/log_",n-1,".txt")
      log.text <- readChar(log.path, file.info(log.path)$size)
      
      # If the log file contains "Job terminated" there was a problem running the code, so cat the contents of the error file.
      if(grepl("Job terminated",log.text)) {
        cat("not found.\n\n")
        cat("Error file states:\n\n")
        cat(error.text)
      }
      
      # If not, it's most likely that the code has simply not yet finished running on the cluster.
      else {
        cat("not yet complete.")
      }
      
    }
    cat("\n")
  }
  cat("\n")
  
}



## Function for checking the status of jobs on the cluster.
status.HTCondor <- function(all=FALSE){
  if(all == TRUE) { all.text <- ""          }
  else            { all.text <- "samwilks " }
  system(paste0("ssh samwilks@albertine.antigenic-cartography.org ' condor_q ",all.text,"'"))
  cat("\n\n")
}



## Function for running commands on the remote server, i.e. for removing jobs from the cluster.
run.HTCondor <- function(command) {
  system(paste0("ssh samwilks@albertine.antigenic-cartography.org '",command,"'"))
}



