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
 
 Example 1: Predict Cell Annotations
```r
library(xgboostCiphe)

# Assume you have a trained model and a flowFrame
model <- yourModel
flowFrame <- yourFlowFrame

# Predict cell annotations
annotatedFlowFrame <- predictCellAnnotation(model, flowFrame, "AnnotationColumnName")
