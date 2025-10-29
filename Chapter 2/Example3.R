# Load caret package
install.packages('caret')
library(caret)
# Load iris dataset
data(iris)
# Define training control
train_control <- trainControl(method = 'cv', number = 5)
# Train a random forest model
model <- train(Species ~ ., data = iris, method = 'rf', trControl = train_control)
# Display model summary
print(model)