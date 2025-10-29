# Section 4.2 – Distinction Between Discriminative and Generative Models
# This composite block demonstrates three examples:
# 1. A generative forward diffusion process using noise
# 2. A discriminative logistic regression classifier
# 3. A generative Gaussian sampler that mimics original data

  # Part 1: Forward Diffusion Process (Generative Model Perspective)
  # Adds Gaussian noise over time using torch in R
  # Install and load required packages
  install.packages("torch") # Only run if not installed
library(torch)
# Function to apply small Gaussian noise
gaussian_noise <- function(x, beta) {
  return(sqrt(1 - beta) * x + sqrt(beta) * torch_randn_like(x))
}
# Initialize random input (e.g., 28x28 image representation)
beta <- 0.02
x_0 <- torch_randn(c(1, 28, 28))
# Iteratively apply noise to simulate forward diffusion
x_t <- x_0
for (t in 1:100) {
  x_t <- gaussian_noise(x_t, beta)}
  # Display final noisy sample
  print(x_t)
  
    # Part 2: Discriminative Model – Logistic Regression
    # Install ggplot2 for visualization
    install.packages("ggplot2") # Only run if not installed
  library(ggplot2)
  # Generate a synthetic binary classification dataset
  set.seed(42)
  x <- rnorm(100)
  y <- ifelse(x + rnorm(100, sd = 0.5) > 0, 1, 0)
  # Fit a logistic regression model (predicting y from x)
  model <- glm(y ~ x, family = binomial(link = "logit"))
  # Display model summary
  summary(model)
  # Part 3: Generative Model – Sampling from Gaussian Distribution
  # Generate synthetic data using learned mean and standard deviation
  generated_samples <- rnorm(100, mean = mean(x), sd = sd(x))
  # Plot the distribution of generated samples
  ggplot(data.frame(x = generated_samples), aes(x = x)) +
    geom_histogram(bins = 30, fill = "red", alpha = 0.5) +
    ggtitle("Generated Samples from Gaussian Distribution")
  
  