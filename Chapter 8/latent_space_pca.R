# ----------------------------------------------------------
# 8.2_latent_space_pca.R
# Visualizing a simulated latent space using PCA in 2D
# This example mimics how VAE or GAN latent vectors might be analyzed
# ----------------------------------------------------------
# Step 1: Load required libraries
# ggplot2 is used for plotting; Rtsne is optional for future t-SNE support
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2") # Install ggplot2 if not already installed
}
if (!requireNamespace("Rtsne", quietly = TRUE)) {
  install.packages("Rtsne") # Optional: install Rtsne if planning to   use t-SNE
}
library(ggplot2)
library(Rtsne) # Included for extensibility; not used directly in this example
# Step 2: Simulate latent space vectors
# -------------------------------------
# Create a matrix of 100 samples, each with 10 dimensions (features)
# Normally, these would be outputs from an encoder (e.g., VAE encoder)
set.seed(42) # Ensure reproducibility
latent_matrix <- matrix(rnorm(1000), nrow = 100, ncol = 10)
# Step 3: Assign artificial class labels
# --------------------------------------
# These labels simulate class identity (e.g., digit 0–9) for visualization
labels <- sample(0:9, 100, replace = TRUE)
# Step 4: Perform PCA for dimensionality reduction
# ------------------------------------------------
# PCA transforms the 10D latent vectors into 2D (first two principal components)
# This makes the data easier to visualize while retaining variance
structure
pca_result <- prcomp(latent_matrix, center = TRUE, scale. = TRUE)
# Extract the first two principal components for plotting
latent_2d <- pca_result$x[, 1:2]
# Step 5: Prepare data for ggplot2
# --------------------------------
# Combine PCA coordinates and labels into a data frame
df <- data.frame(
  PC1 = latent_2d[, 1], # First principal component
  PC2 = latent_2d[, 2], # Second principal component
  Label = as.factor(labels) # Convert numeric labels to factors for coloring
)
# Step 6: Plot the 2D PCA projection
# ----------------------------------
# This visualizes how the latent vectors group by class in reduced space
ggplot(df, aes(x = PC1, y = PC2, color = Label)) +
  geom_point(size = 3, alpha = 0.9) + # Draw points with slight transparency
  labs(
    title = "PCA Projection of Simulated Latent Space", # Plot title
    x = "Principal Component 1", # X-axis label
    y = "Principal Component 2", # Y-axis label
    color = "Class" # Legend label
  ) +
  theme_minimal() # Use a clean, minimal theme for clarity