# Section 4.5 – Probabilistic Models
# This example demonstrates how to generate synthetic data from a Gaussian distribution
# and visualize its probability distribution using a histogram in R.
# Install and load the required package for visualization
install.packages("ggplot2") # Run this only once
library(ggplot2)
# Generate synthetic data from a standard normal distribution
set.seed(42)
synthetic_data <- data.frame(x = rnorm(1000, mean = 0, sd = 1))
# Plot the distribution using ggplot2
ggplot(synthetic_data, aes(x = x)) +
  geom_histogram(bins = 30, fill = "blue", alpha = 0.5) +
  ggtitle("Synthetic Data Distribution")
