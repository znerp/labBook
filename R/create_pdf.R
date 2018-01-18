#' Copies content of current device to PDF and PNG. (created by Nick)
#'
#' Function to create a pdf file of the content of the current device and also make a png copy of it, copying the link to your clipboard. Simultaneously opens the corresponding html file, provided the cd/wd is currently in the project folder of the labBook.
#'
#' @param filename Please supply the filename without any extensions.
#' @param widthPDF
#' @param heightPDF
#' @param widthPNG
#' @param heightPNG
#' @param openhtml
#' @param html_width
#' @param overwrite
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
#' Here you can write examples.
save2pdfNpng <- function(filename,
                         widthPDF=7, heightPDF=7,
                         widthPNG = 600, heightPNG = 400,
                         openhtml = T, html_width=500,
                         overwrite = F, ...){
  # create pdf and png name
  pdf_name <- paste0(filename, ".pdf")
  png_name <- paste0(filename, ".png")
  # png_name <- gsub("pdf$","png",filename)

  # if (file.exists(pdf_name)){
    # if (overwrite){ # if file exists: only execute in case of overwrite

      ## Copy html link to clipboard
      html_output <- paste0("<a href='../",pdf_name,"'><img src='../",png_name,"' style='width:",html_width,"px'/></a>")

      # call functions to create pdf and png
      d <- dev.copy(pdf, pdf_name, widthPDF, heightPDF)
      dev.off(d)

      e <- dev.copy(png, png_name, widthPNG, heightPNG)
      dev.off(e)

      if (openhtml){
        # save link in clipboard
        writeClipboard(html_output) # save to clipboard

        scriptContext <- rstudioapi::getActiveDocumentContext()
        Rfile <- sub('.*/', '', scriptContext$path) # also works with '.*code'
        htmlfile <- sub('.R', '.html', Rfile)

        # open html file to edit
        file.edit(paste0("pages/", htmlfile))
      }

    # }
    # else{
    #   return(NA)
    # }

  # }
  # else { # if pdf does not exist
    # ## Copy html link to clipboard
    # html_output <- paste0("<a href='../",pdf_name,"'><img src='../",png_name,"' style='width:",html_width,"px'/></a>")
    #
    # # call functions to create pdf and png
    # d <- dev.copy(pdf, pdf_name, widthPDF, heightPDF)
    # dev.off(d)
    #
    # e <- dev.copy(png, png_name, widthPNG, heightPNG)
    # dev.off(e)
    #
    # if (openhtml){
    #   # save link in clipboard
    #   writeClipboard(html_output) # save to clipboard
    #
    #   scriptContext <- rstudioapi::getActiveDocumentContext()
    #   Rfile <- sub('.*/', '', scriptContext$path) # also works with '.*code'
    #   htmlfile <- sub('.R', '.html', Rfile)
    #
    #   # open html file to edit
    #   file.edit(paste0("pages/", htmlfile))
    # }

  # }
}


#' Clear clipboard
#'
#' Function to clear the clipboard.
#'
#' @return
#' @export
#'
#' @examples
clear_cp <- function() {
  writeClipboard("")
}
