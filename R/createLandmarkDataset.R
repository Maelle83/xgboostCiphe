library(flowCore)


#' createLandmarkDataset
#'
#' @param landmarkRepertory
#'
#' @return
#' @export
#'
#' @examples
createLandmarkDataset <- function(landmarkRepertory){

  popLandmark<-list.files(landmarkRepertory)

  # Loop to create training dataset

  # Initialize dataframe
  referenceDataset<-data.frame()

  for (file in popLandmark){

    fcs<-read.FCS(paste0(landmarkRepertory,"/",file))

    # Extract markers of fcs file

    # Extract the part that contains the markers
    data<-as.data.frame(fcs@parameters@data)

    # Initialize marker vector
    markers<-c()

    # Initialize fluo vector
    fluo <-c()

    # Loop
    for (marker in 1:nrow(data)){

      # If  marker not contain description exemple for FSC-A/SSC-A
      if (is.na(data[marker,"desc"]) ){

        newMarker<-data[marker,"name"]

        newFluo<-data[marker,"name"]

      }else{

        newMarker<-data[marker,"desc"]

        newFluo<-data[marker,"name"]
      }

      markers<-c(markers,newMarker)

      fluo<-c(fluo,newFluo)

    }

    # Add markers
    markers<-as.matrix(markers)

    markers<-as.vector(markers[,1])

    fluo<-as.matrix(fluo)

    fluo<-as.vector(fluo[,1])

    names(fluo)<-markers


    # Convert expression matrix to a dataframe
    df<-as.data.frame(fcs@exprs)

    colnames(df) <- names(fluo)

    # Create new column containing poplabel
    df$Pop<-rep(basename(file),nrow(df))

    # Concatene dataframes
    referenceDataset<-rbind(referenceDataset,df)
  }

  return(referenceDataset)

}
# createLandmarkDataset("/home/maelleWorkspace/GatedCleanLandmarkFSCTransformed")
