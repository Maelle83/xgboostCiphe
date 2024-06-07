#' predictCellAnnotation
#'
#' @param model
#' @param flowFrame
#' @param enrichColumnName
#'
#' @return
#' @export
#'
#' @examples
#'
#'


predictCellAnnotation <- function(model, flowFrame, enrichColumnName){

  #  Prediction (annotation)
  predictions <- predict(model, data)

  # Transform to matrix
  predictions<-as.matrix(predictions)

  # Add 1 to all predictions
  predictions<-predictions + 1

  colnames(predictions) <- enrichColumnName

  # Ajouter la nouvelle colonne dans le fichier fcs
  flowFrame<- enrich.FCS.CIPHE(flowFrame, predictions)


}
