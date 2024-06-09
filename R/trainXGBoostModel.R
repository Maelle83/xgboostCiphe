#' trainXGBoostModel
#'
#' Train an XGBoost model with a reference dataset that contains gated cell populations.
#'
#' @param referenceDataset A data frame containing the reference dataset with gated cell populations.
#' @param features A vector of markers to be used for training the model.
#' @param popIDColumn The name of the column in your dataset that contains the population IDs (popID).
#'
#' @importFrom xgboost xgb.train xgb.DMatrix
#' @importFrom stats scale
#'
#' @return An XGBoost model object trained on the reference dataset.
#' @export
#'
#' @examples
#' trainXGBoostModel(referenceDataset, c("FSC-A", "SSC-A", "CD4", "CD11b", "CD44", "CD5/Ly6G", "IA/IE", "CD317", "CD62L", "CD8a/SiglecF", "F4/80", "CD161", "Ly6C", "CD25", "CD11c", "CD19"), "popID")
#'
trainXGBoostModel <- function(referenceDataset, features, popIDColumn) {

  # Split data into training and testing sets
  indices <- sample(1:nrow(referenceDataset), 0.75 * nrow(referenceDataset))
  indices <- as.numeric(indices)

  # Training data
  train_data <- referenceDataset[indices, ]
  train_data <- apply(train_data, 2, as.numeric)

  # Test data
  test_data <- referenceDataset[-indices, ]
  test_data <- apply(test_data, 2, as.numeric)

  # Scaling and convert to numeric dataset
  x_train <- scale(as.matrix(train_data[, !(colnames(train_data) %in% c(popIDColumn))]))
  y_train <- as.numeric(train_data[, colnames(train_data) %in% c(popIDColumn)])

  x_test <- scale(as.matrix(test_data[, !(colnames(test_data) %in% c(popIDColumn))]))
  y_test <- as.numeric(test_data[, colnames(test_data) %in% c(popIDColumn)])

  # Determine number of classes
  pop <- as.factor(referenceDataset[, colnames(referenceDataset) %in% c(popIDColumn)])
  numberOfClasses <- length(levels(pop))

  # Define parameters for model training
  params <- list(
    booster = "gbtree",
    num_class = numberOfClasses,
    eval_metric = "auc",
    objective = "multi:softprob"
  )

  # Calculate weight of each class
  class_weights <- rep(1, numberOfClasses)
  class_weights[8] <- 100
  class_weights[9] <- 100

  datatest <- as.data.frame(table(y_train) / length(y_train))

  # Create a dataframe with class values and weights
  class_weights_df <- data.frame(
    y_train = datatest$Var1,
    Freq = class_weights
  )

  # Initialization of the weight vector
  weights_per_sample <- rep(0, length(y_train))

  # Assigning weights based on the class of each sample
  for (i in 1:length(y_train)) {
    class <- y_train[i]
    weight <- class_weights_df[class_weights_df$y_train == class, "Freq"]
    weights_per_sample[i] <- weight
  }

  # Convert to XGBoost DMatrix
  xgb_train <- xgb.DMatrix(data = x_train, label = y_train, weight = weights_per_sample)
  xgb_test <- xgb.DMatrix(data = x_test, label = y_test)

  # Watchlist for early stopping
  watchlist <- list(train = xgb_train, test = xgb_test)

  # Train the model
  bst <- xgb.train(
    params = params,
    data = xgb_train,
    nrounds = 200,
    watchlist = watchlist,
    early_stopping_rounds = 3,
    verbose = 1
  )

  return(bst)
}
