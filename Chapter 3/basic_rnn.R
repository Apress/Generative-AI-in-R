#basic_rnn.r
# Load necessary libraries
library(keras)
# Define example parameters
num_samples <- 1000 # Number of sequences
timesteps <- 10 # Number of timesteps per sequence
input_dim <- 20 # Number of features per timestep
output_dim <- 1 # Output dimension
# Generate dummy data
set.seed(123) # For reproducibility
X <- array(runif(num_samples * timesteps * input_dim), dim = c(num_samples,
                                                               timesteps, input_dim))
y <- matrix(runif(num_samples * output_dim), nrow = num_samples, ncol =
              output_dim)
# Build the RNN model
model <- keras_model_sequential() %>%
  layer_simple_rnn(units = 32, input_shape = c(timesteps, input_dim)) %>%
  layer_dense(units = output_dim)
# Compile the model
model %>% compile(
  optimizer = 'adam',
  loss = 'mse',
  metrics = c('mae')
)
# Print the model summary
summary(model)
# Train the model
history <- model %>% fit(
  x = X, y = y,
  epochs = 10,
  batch_size = 32,
  validation_split = 0.2
)
# Evaluate the model
evaluation <- model %>% evaluate(X, y)
cat("Loss:", evaluation[[1]], "\nMAE:", evaluation[[2]], "\n")