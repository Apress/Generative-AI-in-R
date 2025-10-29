# random_forest_iris2.R
# Install randomForest package
install.packages("randomForest")
library(randomForest)
# Train a random forest model
rf_model <- randomForest(Species ~ ., data = iris, ntree = 100)
# Print the model summary
print(rf_model)
