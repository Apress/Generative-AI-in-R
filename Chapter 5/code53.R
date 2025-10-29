# Load the required library
# Install torch package if not already installed
# install.packages("torch")
library(torch)
# Define a simple Gaussian noise function for forward diffusion
# This function simulates one step of noise addition using a Gaussian process
gaussian_noise <- function(x, beta) {
  return(sqrt(1 - beta) * x + sqrt(beta) * torch_randn_like(x))
}
# Set the noise variance for each diffusion step (beta is usually small)
beta <- 0.02 # Controls the strength of noise added at each step
# Initialize a random image-like tensor (e.g., 28x28 pixel grayscale image)
x_0 <- torch_randn(c(1, 28, 28)) # Original data sample
# Perform the forward diffusion process over 100 timesteps
x_t <- x_0 # Initialize the noisy version with the original image
for (t in 1:100) {
  x_t <- gaussian_noise(x_t, beta) # Add noise at each step
}
# Display the final noisy image after 100 steps
print(x_t)