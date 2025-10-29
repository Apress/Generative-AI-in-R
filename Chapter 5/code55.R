# Load the torch library
library(torch)
# Define the reverse denoising function
reverse_denoise <- function(x_t, beta) {
  # Simulate denoising by reducing noise — reverse of forward step
  return(x_t / sqrt(1 - beta))
}
# Set the same beta used during forward diffusion
beta <- 0.02 # Small noise variance per timestep
# Start from a noisy sample (as produced in forward process)
x_t <- torch_randn(c(1, 28, 28)) # Assumed pure noise input
# Apply reverse denoising over 100 steps
for (t in 1:100) {
  x_t <- reverse_denoise(x_t, beta)
}
# Display the final reconstructed (denoised) sample
print(x_t)