# Load required libraries
library(torch) # For tensor operations
library(ggplot2) # For plotting
# Define the Gaussian noise function
gaussian_noise <- function(x, beta) {
  sqrt(1 - beta) * x + sqrt(beta) * torch_randn_like(x)
}
# Set the noise level
beta <- 0.02 # Small variance of Gaussian noise
# Create an initial random image-like tensor (e.g., 28x28 pixels)
x_0 <- torch_randn(c(1, 28, 28)) # Simulates one grayscale image
x_t <- x_0 # Initialize current state
# Track mean pixel value at each timestep
mean_values <- numeric(100)
# Simulate the forward diffusion process
for (t in 1:100) {
  x_t <- gaussian_noise(x_t, beta)
  mean_values[t] <- as.numeric(torch_mean(x_t)) # Store mean   for visualization
}
# Prepare a data frame for plotting
df <- data.frame(step = 1:100, mean_value = mean_values)
# Plot the mean pixel value over timesteps
ggplot(df, aes(x = step, y = mean_value)) +
  geom_line(color = "blue") +
  ggtitle("Mean Pixel Value Over Diffusion Steps") +
  ylab("Mean Value") + xlab("Diffusion Step")