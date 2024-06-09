#' obtainAnnotationStatistics
#'
#' Calculate annotation statistics from an enriched FlowFrame.
#'
#' @param enrichedFlowFrame A FlowFrame object that has been enriched with annotation information.
#' @param enrichColumnName The name of the column containing the enrichment information.
#'
#'
#' @importFrom dplyr mutate
#' @importFrom flowCore exprs
#'
#' @return A data frame containing the population IDs, counts, and percentages.
#' @export
#'
#' @examples
#' stats <- obtainAnnotationStatistics(enrichedFlowFrame, "popIDXGBoost")
#'
obtainAnnotationStatistics <- function(enrichedFlowFrame, enrichColumnName) {

  # Convert to a dataframe
  x <- as.data.frame(enrichedFlowFrame@exprs)

  # Create a frequency table for the specified column
  x <- table(x[[enrichColumnName]])

  # Convert to a dataframe
  x <- as.data.frame(x)

  # Add percentage column
  x <- x %>%
    mutate(Percentage = round(Freq / sum(Freq) * 100, 3))

  # Create a dataframe that contains the results
  results <- data.frame(popID = x$Var1, count = x$Freq, Percentage = x$Percentage)

  return(results)
}
