# Install the torch package if not already installed
# install.packages("torch")
# Load the torch library for tensor operations
library(torch)
# Define a simple Gaussian noise function used in forward diffusion
gaussian_noise <- function(x, beta) {
  # Adds scaled Gaussian noise to input tensor x
  return(sqrt(1 - beta) * x + sqrt(beta) * torch_randn_like(x))
}
# Set diffusion noise variance (β). A small beta keeps the structure stable.
beta <- 0.02 # Small noise variance per timestep
# Create an initial sample (e.g., 28x28 grayscale image)
x_0 <- torch_randn(c(1, 28, 28)) # Shape: (Channels, Height, Width)
# Initialize x_t with the original sample
x_t <- x_0
# Perform forward diffusion for 100 time steps
for (t in 1:100) {
  x_t <- gaussian_noise(x_t, beta) # Add Gaussian noise at each step
}
# Print the final noisy sample
print(x_t)