# xgboost_iris.R
# Install xgboost package
install.packages("xgboost")
library(xgboost)
# Prepare the data
data(iris)
iris_data <- as.matrix(iris[, -5])
iris_label <- as.numeric(iris$Species) - 1
# Create an xgboost model
xgb_model <- xgboost(data = iris_data, label = iris_label, nrounds = 100,
                     objective = "multi:softmax", num_class = 3)
# Print the model summary
print(xgb_model)