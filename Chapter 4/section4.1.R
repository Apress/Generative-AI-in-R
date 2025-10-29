# Code for Section 4.1 – Overview of Generative Models
# This example demonstrates how to generate synthetic data from a Gaussian distribution
# and visualize the distribution using a histogram.
# Install and load required packages
install.packages("ggplot2")#for data visualization
library(ggplot2)
# Example: Simple Gaussian Data Generation
# Generate synthetic data: 1000 samples from a normal distribution with mean 0 and SD 1
set.seed(42)
synthetic_data <- data.frame(x = rnorm(1000, mean = 0, sd = 1))
# Plot the synthetic data distribution
# Visualize the distribution using a histogram
ggplot(synthetic_data, aes(x = x)) +
  geom_histogram(bins = 30, fill = "blue", alpha = 0.5) +
  ggtitle("Synthetic Data Distribution")
