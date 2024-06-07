#' obtainAnnotationStatistics
#'
#' @param enrichedFlowFrame
#' @param enrichColumnName
#'
#' @return
#' @export
#'
#' @examples
#'


obtainAnnotationStatistics <- function(enrichedFlowFrame, enrichColumnName){

  # Convert to a dataframe
  x <- as.data.frame(enrichedFlowFrame@exprs)

  # Add informations of all pop
  x <- table(x$popIDXGBoost)

  # Convert to a dataframe
  x<-as.data.frame(x)
  #
  #   # Call the function to match label with popID
  #   popLabel<-matchPopIDD()
  #
  #   labels<-c()
  #
  #   for (i in x$Var1){
  #
  #     for (j in 1:29){
  #
  #       if (i==j){
  #
  #         labels<-c(labels,popLabel[[j]])
  #       }
  #     }
  #
  #   }
  #
  #   # Add new label column
  #   x$label <-labels

  # Add percentage column
  x <- x %>%
    mutate(Percentage = round(Freq/sum(Freq)*100,3))


  # dataframe that contains xgboost results
  results<-data.frame(popID=x$Var1, count=x$Freq,Percentage =x$Percentage)


  return(results)


}
