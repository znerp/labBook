
capture_webpage <- function(webpage, output) {
  
  # Convert to absolute paths
  webpage <- paste0("file://", normalizePath(webpage))
  output  <- normalizePath(output)
  
  # Take snapshot
  message("Capturing webpage screenshot\n")
  sys_command <- paste("osascript ~/Desktop/LabBook/general_data/applescript/webpage_screenshot.scpt",
                       webpage, output)
  system(sys_command)
  
}

