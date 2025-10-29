# basic_cnn.r
# Load necessary libraries
if (!require("keras")) install.packages("keras", dependencies = TRUE)
library(keras)
# Load the MNIST dataset
mnist <- dataset_mnist()
# Split into training and test sets
x_train <- mnist$train$x
y_train <- mnist$train$y
x_test <- mnist$test$x
y_test <- mnist$test$y
# Reshape and normalize the data
x_train <- array_reshape(x_train, c(nrow(x_train), 28, 28, 1)) / 255
x_test <- array_reshape(x_test, c(nrow(x_test), 28, 28, 1)) / 255
# One-hot encode the labels
y_train <- to_categorical(y_train, 10)
y_test <- to_categorical(y_test, 10)
# Define the CNN model
model <- keras_model_sequential() %>%
  # First convolutional layer
  layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = "relu",
                input_shape = c(28, 28, 1)) %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  # Second convolutional layer
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation =
                  "relu") %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  # Flatten and add dense layers
  layer_flatten() %>%
  layer_dense(units = 128, activation = "relu") %>%
  layer_dense(units = 10, activation = "softmax") # Output layer for 10 classes
# Compile the model
model %>% compile(
  loss = "categorical_crossentropy", # For multi-class classification
  optimizer = optimizer_adam(), # Adam optimizer
  metrics = c("accuracy") # Evaluation metric
)
# Train the model
history <- model %>% fit(
  x_train, y_train,
  epochs = 10, # Number of epochs
  batch_size = 128, # Size of each batch
  validation_split = 0.2 # Use 20% of training data for validation
)
# Evaluate the model on test data
score <- model %>% evaluate(x_test, y_test, verbose = 0)
cat("Test Loss:", score["loss"], "\n")
cat("Test Accuracy:", score["accuracy"], "\n")
# Predict on test data
predictions <- model %>% predict(x_test)
predicted_classes <- apply(predictions, 1, which.max) - 1 # Convert to class labels (0-9)
# Compare actual and predicted classes
results <- data.frame(
  Actual = mnist$test$y[1:10],
  Predicted = predicted_classes[1:10]
)
print(results)
