library(keras)
# -------------------------------
# 1. Prepare and Normalize the Dataset
# -------------------------------
set.seed(42)
patients_df <- data.frame(
  age = runif(500, 20, 80),
  glucose = runif(500, 70, 200),
  bp_systolic = runif(500, 100, 180),
  cholesterol = runif(500, 150, 300),
  gender_M = sample(0:1, 500, replace = TRUE),
  smoker = sample(0:1, 500, replace = TRUE)
)
# Normalize to [0, 1]
patients_df <- as.data.frame(lapply(patients_df, function(x) (x - min(x)) /
                                      (max(x) - min(x))))
x_data <- as.matrix(patients_df)
input_dim <- ncol(x_data)
latent_dim <- 8
# -------------------------------
# 2. Define the Decoder
# -------------------------------
decoder_input <- layer_input(shape = latent_dim)
decoder_output <- decoder_input %>%
  layer_dense(units = 32, activation = "relu") %>%
  layer_dense(units = 64, activation = "relu") %>%
  layer_dense(units = input_dim, activation = "sigmoid")
decoder <- keras_model(inputs = decoder_input, outputs = decoder_output)
# -------------------------------
# 3. Custom Sampling Function
# -------------------------------
sampling <- function(z_mean, z_log_var) {
  epsilon <- k_random_normal(shape = k_shape(z_mean), mean = 0.0,
                             stddev = 1.0)
  z_mean + k_exp(0.5 * z_log_var) * epsilon
}
# -------------------------------
# 4. Define Custom VAE Model with KL Loss
# -------------------------------
vae_model <- keras_model_custom(name = "VAE", function(self) {
  # Encoder layers (INSIDE this function block)
  self$dense1 <- layer_dense(units = 64, activation = "relu")
  self$dense2 <- layer_dense(units = 32, activation = "relu")
  self$z_mean_layer <- layer_dense(units = latent_dim)
  self$z_log_var_layer <- layer_dense(units = latent_dim)
  # Attach decoder model
  self$decoder <- decoder
  # Call function: defines forward pass
  self$call <- function(inputs, training = FALSE) {
    h <- inputs %>%
      self$dense1() %>%
      self$dense2()
    z_mean <- self$z_mean_layer(h)
    z_log_var <- self$z_log_var_layer(h)
    z <- sampling(z_mean, z_log_var)
    # Add KL divergence loss
    kl_loss <- -0.5 * k_sum(1 + z_log_var - k_square(z_mean) - k_exp(z_log_var), axis = -1)
    self$add_loss(k_mean(kl_loss))
    self$decoder(z)
  }
})
# -------------------------------
# 5. Compile and Train the VAE
# -------------------------------
vae_model %>% compile(
  optimizer = optimizer_adam(learning_rate = 0.001),
  loss = loss_mean_squared_error
)
history <- vae_model %>% fit(
  x = x_data, y = x_data,
  epochs = 50,
  batch_size = 32,
  validation_split = 0.1,
  verbose = 2
)
# -------------------------------
# 6. Generate Synthetic Data
# -------------------------------
new_z <- matrix(rnorm(10 * latent_dim), nrow = 10)
synthetic_patients <- decoder %>% predict(new_z)
cat("Synthetic Patient Records:\n")
print(round(synthetic_patients[1:5, ], 2))