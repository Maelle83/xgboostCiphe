# xgboostCiphe

This package provides tools for processing flow cytometry data and training models using XGBoost for cell population annotations.

## Installation

You can install the package directly from GitHub using `devtools`:

```r
# Install devtools if you haven't already
install.packages("devtools")

# Install the package from GitHub
devtools::install_github("Maelle83/xgboostCiphe")
```
### Usage

 Here are some examples of how to use the main functions in the xgboostCiphe package.
 
 Example 1: Create a Landmark Dataset

```r
library(xgboostCiphe)
# Specify the directory containing landmark files
landmarkDirectory <- "/path/to/landmark/files"

# Create a landmark dataset
landmarkData <- createLandmarkDataset(landmarkDirectory)
```
Example 2: Train an XGBoost Model
```r
# Assume you have a reference dataset
referenceDataset <- yourReferenceDataset

# Train an XGBoost model
xgboostModel <- trainXGBoostModel(referenceDataset, c("FSC-A", "SSC-A", "CD4", "CD11b", "CD44", "CD5/Ly6G", "IA/IE", "CD317", "CD62L", "CD8a/SiglecF", "F4/80", "CD161", "Ly6C", "CD25", "CD11c", "CD19"), "popID")
```
Example 3: Prepare Ungated Data for Analysis
```r
# Assume you have a flowFrame and a trained XGBoost model
flowFrame <- yourFlowFrame
xgboostModel <- yourXGBoostModel

# Prepare the data for analysis
preparedData <- prepareUngatedData(flowFrame, c("FSC-A", "SSC-A", "CD4", "CD11b", "CD44", "CD5/Ly6G", "IA/IE", "CD317", "CD62L", "CD8a/SiglecF", "F4/80", "CD161", "Ly6C", "CD25", "CD11c", "CD19"), xgboostModel)
```
Example 4: Predict Cell Annotations
```r
# Assume you have a trained model and a flowFrame
model <- yourModel
flowFrame <- yourFlowFrame

# Predict cell annotations
annotatedFlowFrame <- predictCellAnnotation(model, flowFrame, "AnnotationColumnName")
```
Example 4: Obtain Annotation Statistics

```r
# Assume you have an enriched flowFrame
enrichedFlowFrame <- yourEnrichedFlowFrame

# Get annotation statistics
annotationStats <- obtainAnnotationStatistics(enrichedFlowFrame, "popIDXGBoost")
```

