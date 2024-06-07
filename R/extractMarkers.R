

#' Extract markers
#'
#'
#'Extract markers presents in a fcs file
#'
#' @param fcs_file
#'
#' @return
#' @export
#'
#' @examples


extractMarkers<-function(fcs_file){

  # Extract the part that contains the markers
  data<-as.data.frame(fcs_file@parameters@data)

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

  return(fluo)
}

