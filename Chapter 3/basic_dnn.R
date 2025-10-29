#basic_dnn.r
#Load necessary libraries
if (!require("keras")) install.packages("keras", dependencies = TRUE)
library(keras)
# Prepare the dataset
data(mtcars)
# Normalize the data
normalize <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}
mtcars_norm <- as.data.frame(lapply(mtcars, normalize))
# Split the dataset into training and testing sets
set.seed(123)
train_indices <- sample(1:nrow(mtcars_norm), size = 0.8 *
                          nrow(mtcars_norm))
train_data <- mtcars_norm[train_indices, ]
test_data <- mtcars_norm[-train_indices, ]
# Separate features (x) and target (y)
x_train <- as.matrix(train_data[, c("hp", "wt", "disp", "cyl")])
y_train <- as.matrix(train_data$mpg)
x_test <- as.matrix(test_data[, c("hp", "wt", "disp", "cyl")])
y_test <- as.matrix(test_data$mpg)
# Define the deep neural network model
model <- keras_model_sequential() %>%
  layer_dense(units = 64, activation = "relu", input_shape = ncol(x_train))%>% # Input layer
  layer_dense(units = 32, activation = "relu") %>% # Hidden layer 1
  layer_dense(units = 16, activation = "relu") %>% # Hidden layer 2
  layer_dense(units = 1) # Output layer for regression
# Compile the model
model %>% compile(
  optimizer = optimizer_adam(), # Adaptive moment estimation
  loss = "mean_squared_error", # Regression loss function
  metrics = c("mean_absolute_error") # Evaluation metric
)
# Train the model
history <- model %>% fit(
  x_train, y_train,
  epochs = 100, # Number of training epochs
  batch_size = 8, # Size of each batch
  validation_split = 0.2, # Use 20% of training data for validation
  verbose = 1 # Print training progress
)
# Evaluate the model on the test data
score <- model %>% evaluate(x_test, y_test, verbose = 0)
cat("Test Mean Squared Error:", score["loss"], "\n")
cat("Test Mean Absolute Error:", score["mean_absolute_error"], "\n")
# Make predictions
predictions <- model %>% predict(x_test)
# Denormalize predictions and actual values for comparison
denormalize <- function(x, min, max) {
  x * (max - min) + min
}
actual_mpg <- denormalize(y_test, min(mtcars$mpg), max(mtcars$mpg))
predicted_mpg <- denormalize(predictions, min(mtcars$mpg), max(mtcars$mpg))
# Compare actual vs predicted values
results <- data.frame(Actual = actual_mpg, Predicted = predicted_mpg)
print(results)