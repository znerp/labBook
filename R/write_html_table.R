write.html.table <- function(pattern, ncells, ncols) {
  html.output <- "<table><tr>"
  for(cell in 1:ncells){
    if((cell-1)/ncols == round((cell-1)/ncols) & cell != 1) {
      html.output <- c(html.output,"</tr><tr>")
    }
    cell.contents <- gsub("\\[num\\]",cell,pattern)
    cell.contents <- paste0("<td>",cell.contents,"</td>")
    html.output <- c(html.output, cell.contents)
  }
  html.output <- c(html.output, "</tr></table>")
  
  ## Copy to clipboard ##
  clip <- pipe("pbcopy", "w")                       
  writeLines(html.output, clip)                               
  close(clip)
  
  ## Print output ##
  cat(paste(html.output,collapse = "\n"))
}