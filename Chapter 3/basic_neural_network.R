# basic_neural_network.R
# Load necessary libraries
if (!require("neuralnet")) install.packages("neuralnet",
                                            dependencies = TRUE)
library(neuralnet)
# Load dataset
data(mtcars)
# Normalize data (neural networks perform better with normalized data)
normalize <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}
mtcars_norm <- as.data.frame(lapply(mtcars, normalize))
# Split the dataset into training and testing sets
set.seed(123) # For reproducibility
train_indices <- sample(1:nrow(mtcars_norm), size = 0.8 *
                          nrow(mtcars_norm))
train_data <- mtcars_norm[train_indices, ]
test_data <- mtcars_norm[-train_indices, ]
# Define the formula for the neural network
formula <- mpg ~ hp + wt
# Train the neural network
set.seed(123) # For reproducibility
nn <- neuralnet(
  formula,
  data = train_data,
  hidden = c(5), # Single hidden layer with 5 neurons
  linear.output = TRUE # Because we're predicting a continuous variable
)
# Visualize the neural network
plot(nn)
# Make predictions on the test data
predictions <- compute(nn, test_data[, c("hp", "wt")])$net.result
# Evaluate the performance
# Denormalize the predictions and actual values
denormalize <- function(x, min, max) {
  x * (max - min) + min
}
actual_mpg <- denormalize(test_data$mpg, min(mtcars$mpg), max(mtcars$mpg))
predicted_mpg <- denormalize(predictions, min(mtcars$mpg), max(mtcars$mpg))
# Calculate Mean Squared Error (MSE)
mse <- mean((actual_mpg - predicted_mpg)^2)
cat("Mean Squared Error:", mse, "\n")
# Print actual vs. predicted values
results <- data.frame(Actual = actual_mpg, Predicted = predicted_mpg)
print(results)