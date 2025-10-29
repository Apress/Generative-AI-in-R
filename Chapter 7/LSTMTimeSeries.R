library(keras)
# -------------------------------
# 1. Simulate time series data
# -------------------------------
set.seed(42)
time <- seq(0, 100, by = 0.1) # Time vector
series <- sin(time) + rnorm(length(time), mean = 0, sd = 0.1) # Sine
wave + noise
# -------------------------------
# 2. Prepare data for supervised learning
# -------------------------------
timestep <- 20 # Number of past time steps to use for prediction
# Create input-output pairs: X (features), y (target)
X <- array(0, dim = c(length(series) - timestep, timestep, 1)) # 3D input [samples, time steps, features]
y <- numeric(length(series) - timestep)
for(i in 1:(length(series) - timestep)) {
  X[i,,1] <- series[i:(i + timestep - 1)] # past 20 values
  y[i] <- series[i + timestep] # next value (target)
}
-------------------------------
  # 3. Define LSTM model
  # -------------------------------
model <- keras_model_sequential() %>%
  layer_lstm(units = 50, input_shape = c(timestep, 1), return_sequences =
               FALSE) %>%
  layer_dense(units = 1) # Output a single value (regression)
# Compile with MSE loss and Adam optimizer
model %>% compile(
  optimizer = "adam",
  loss = "mse"
)
# -------------------------------
# 4. Train the model
# -------------------------------
history <- model %>% fit(
  x = X, y = y,
  epochs = 50,
  batch_size = 32,
  validation_split = 0.1,
  verbose = 2
)
# Initialize generation with the first 20 points of real series #as seed
seed <- series[1:20]
generated <- as.numeric(seed) # will hold the growing generated series
# Generate the next 200 points
for(i in 1:200) {
  # Prepare the last 'timestep' values as model input
  input_seq <- array(generated[length(generated) - timestep +
                                 1:length(generated)], dim = c(1, timestep, 1))
  next_val <- model %>% predict(input_seq)
  # Append the predicted value
  generated <- c(generated, as.numeric(next_val))
}
# Plot the synthetic series versus the original series segment
plot(generated, type='l', col="blue", ylim=c(0,1), ylab="Normalized value",
     xlab="Time")
lines(series[1:length(generated)], col="red", lty=2)
legend("topright", legend=c("Synthetic", "Original"), col=c("blue","red"),
       lty=c(1,2))
