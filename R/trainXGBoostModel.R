


#' trainXGBoostModel
#'
#'
#' Train an XGBoost model with a reference dataset that contains gated cell populations
#'
#' @param referenceDataset
#'
#' @param features Markers that you want to use to train the model
#'
#' @param popIDColumn Column name in your fcs that contains the popID.
#'
#' @return
#' @export
#'
#' @examples
#' trainXGBoostModel(referenceDataset, c("FSC-A","SSC-A","CD4","CD11b","CD44","CD5/Ly6G","IA/IE","CD317","CD62L","CD8a/SiglecF","F4/80","CD161","Ly6C","CD25","CD11c",'CD19'), "popID")
#'
#'

trainXGBoostModel<-function(referenceDataset, features, popIDColumn){

  # Split data
  indices <-sample(1:nrow(referenceDataset), 0.75 * nrow(referenceDataset))

  indices<-as.numeric(indices)

  # Training data
  train_data <- df[indices, ]
  train_data<- apply(train_data, 2, as.numeric)

  # Test data
  test_data <- df[-indices, ]
  test_data<- apply(test_data, 2, as.numeric)

  # Scaling and convert to numeric dataset

  x_train <- scale(as.matrix(train_data[ ,!(colnames(train_data) %in% c(popIDColumn))]))
  y_train <- as.numeric(train_data[ ,(colnames(train_data) %in% c(popIDColumn))])

  x_test <- scale(as.matrix(test_data[ ,!(colnames(test_data) %in% c(popIDColumn))]))
  y_test <- as.numeric(test_data[ ,(colnames(test_data) %in% c(popIDColumn))])


  # Determine number of classes
  pop<-as.factor(df[, colnames(df) %in% c(popIDColumn)])

  numberOfClasses=length(levels(pop))



  # Define parameters for model training
  params <- list(
    booster="gbtree",
    num_class=numberOfClasses,
    eval_metric="auc",
    objective="multi:softprob"
  )


  # Calculate weight of each class
  class_weights <- rep(1, numberOfClasses)
  class_weights[8] <- 100
  class_weights[9] <- 100

  datatest <- as.data.frame(table(reclassed_y_train) / length(reclassed_y_train))

  # Create a dataframe with reclassed values and weight
  class_weights_df <- data.frame(
    reclassed_y_train = datatest$reclassed_y_train,
    Freq = class_weights
  )

  # Initialization of the weight vector
  weights_per_sample <- rep(0, length(reclassed_y_train))

  # Assigning weights based on the class of each sample
  for (i in 1:length(reclassed_y_train)) {
    class <- reclassed_y_train[i]
    weight <- class_weights_df[class_weights_df$reclassed_y_train == class, "Freq"]
    weights_per_sample[i] <- weight
  }

  # Watchlist for early stopping
  watchlist <- list(train = xgb_train, test = xgb_test)

  # Train the model
  bst <- xgb.train(
    params = params,
    data = xgb_train,
    nrounds = 200,
    watchlist = watchlist,
    early_stopping_rounds = 3,
    verbose = 1,
    weight = class_weights,
    #xgb_model=bst

  )
  return(bst)

  #bst<-saveRDS(paste0(outputDir, "model_XGBoost_softmax.rds"))
}
