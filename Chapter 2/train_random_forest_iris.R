# train_random_forest_iris.R
# Install caret package
install.packages("caret")
library(caret)
# Load the iris dataset
data(iris)
# Define the training control
train_control <- trainControl(method = "cv", number = 5)
# Train a random forest model
model <- train(Species ~ ., data = iris, method = "rf", trControl = train_control)
# Display the model summary
print(model)
