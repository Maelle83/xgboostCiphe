#' predictCellAnnotation
#'
#' The function predictCellAnnotation is designed to add predicted cell annotations to a flow cytometry dataset. This function takes a trained model, a flowFrame object, and a name for the new annotation column, then returns the flowFrame object with the added annotations.
#'
#' @param model A trained predictive xgboost  model that will be used to make predictions on the flow cytometry data
#' @param flowFrame a flowFrame object containing the flow cytometry data to which the new annotations will be added.
#' @param enrichColumnName The name of the new column to be added to the flowFrame containing the predictions
#'
#' @importFrom flowWorkspace enrich.FCS.CIPHE
#' @importFrom stats predict
#'
#'
#'
#' @return enrichedFlowFrame
#' @export
#'
#' @examples
#'
#'

predictCellAnnotation <- function(model, flowFrame, enrichColumnName){

  # Prediction (annotation)
  predictions <- predict(model, data)

  # Transform to matrix
  predictions <- as.matrix(predictions)

  # Add 1 to all predictions
  predictions <- predictions + 1

  colnames(predictions) <- enrichColumnName

  # Add the new column to the FCS file
  flowFrame <- enrich.FCS.CIPHE(flowFrame, predictions)

  return (enrichedFlowFrame)
}
