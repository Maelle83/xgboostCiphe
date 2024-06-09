#' createLandmarkDataset
#'
#' Create a landmark dataset by combining flow cytometry data from multiple files.
#'
#' @param landmarkRepertory The directory containing the landmark files.
#'
#' @importFrom flowCore read.FCS
#' @importFrom tools file_path_sans_ext
#'
#' @return A combined data frame representing the landmark dataset.
#' @export
#'
#' @examples
#' landmarkData <- createLandmarkDataset("/path/to/landmark/files")
#'
createLandmarkDataset <- function(landmarkRepertory) {

  # Get list of files in the landmark directorys
  popLandmark <- list.files(landmarkRepertory)

  # Initialize an empty dataframe for the reference dataset
  referenceDataset <- data.frame()

  # Iterate over each file in the landmark directory
  for (file in popLandmark) {

    # Read each FCS file
    fcs <- read.FCS(file.path(landmarkRepertory, file))

    # Extract markers from the FCS file
    markers <- c()
    fluo <- c()

    for (marker in 1:nrow(fcs@parameters@data)) {

      if (is.na(fcs@parameters@data[marker, "desc"])) {
        newMarker <- fcs@parameters@data[marker, "name"]
        newFluo <- fcs@parameters@data[marker, "name"]
      } else {
        newMarker <- fcs@parameters@data[marker, "desc"]
        newFluo <- fcs@parameters@data[marker, "name"]
      }

      markers <- c(markers, newMarker)
      fluo <- c(fluo, newFluo)
    }

    markers <- as.vector(markers)
    fluo <- as.vector(fluo)
    names(fluo) <- markers

    # Convert expression matrix to a dataframe
    df <- as.data.frame(fcs@exprs)
    colnames(df) <- names(fluo)

    # Create a new column containing poplabel (file name without extension)
    df$Pop <- rep(tools::file_path_sans_ext(file), nrow(df))

    # Concatenate dataframes
    referenceDataset <- rbind(referenceDataset, df)
  }

  return(referenceDataset)
}
