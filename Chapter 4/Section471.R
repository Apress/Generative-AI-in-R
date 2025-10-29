# Section 4.7.1 – Neural Network-Based Models: VariationalAutoencoders (VAEs)
# This code defines the encoder and decoder components of a Variational Autoencoder in R using the keras package.
# Install and load the keras package
install.packages("keras") # Run once
library(keras)

  # Define the VAE Encoder
  # This encoder maps input data to a latent space represented by mean and variance vectors.
vae_encoder <- function(input_dim, latent_dim) {
  keras_model_sequential() %>%
    layer_dense(units = 128, activation = "relu", input_shape = input_dim) %>%
    layer_dense(units = latent_dim * 2) # Output includes both mean and
  log-variance
}
# Define the VAE Decoder
# The decoder reconstructs the original input from a sampled latent vector.
vae_decoder <- function(latent_dim, output_dim) {
  keras_model_sequential() %>%
    layer_dense(units = 128, activation = "relu", input_shape = latent_dim) %>%
    layer_dense(units = output_dim, activation = "sigmoid") # Output layer
}

