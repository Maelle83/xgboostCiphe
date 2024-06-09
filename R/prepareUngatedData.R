#' prepareUngatedData
#'
#' prepareUngatedData function is designed to preprocess flow cytometry data for prediction using an XGBoost model. This function extracts, from transformed fcs, and formats the relevant markers from the flow cytometry data to match the features used in the model, ultimately returning a data matrix ready for prediction.
#'
#' @param flowFrame A flowFrame object containing flow cytometry data.
#' @param markersInFCSFile A vector of marker names present in the FCS file.
#' @param algo A trained model object (e.g., XGBoost) with feature names.
#'
#' @importFrom flowCore exprs
#' @importFrom stats scale
#' @importFrom xgboost xgb.DMatrix
#'
#' @return An XGBoost DMatrix object with scaled data ready for prediction.
#' @export
#'
#' @examples
#' matrixForAnnotation <- prepareMatrix(fcs,  c("FSC-A","SSC-A","CD4","CD11b","CD44","CD5/Ly6G","IA/IE","CD317","CD62L","CD8a/SiglecF","F4/80","CD161","Ly6C","CD25","CD11c",'CD19'), xgboostModel)
#'
prepareUngatedData <- function(flowFrame, markersInFCSFile, algo) {

  # Extract expression matrix
  ungatedData <- as.data.frame(flowFrame@exprs)

  # Extract features of model
  markersInModel <- algo@feature_names

  print(paste0("Markers in FCS file: ", markersInFCSFile))
  print(paste0("Features used in model: ", markersInModel))

  # Keep only markers you want
  ungatedData <- ungatedData[, markersInFCSFile]

  # Give features names of model to our expression matrix
  colnames(ungatedData) <- markersInModel

  # Scaling
  ungatedDataScaled <- scale(ungatedData)

  # Transform to XGBoost object
  ungatedDataScaled <- xgb.DMatrix(as.matrix(ungatedDataScaled))

  # Return dataFrame
  return(ungatedDataScaled)
}
