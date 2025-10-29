# Load necessary libraries
library(MASS) # for mvrnorm (multivariate normal sampling)
library(Matrix) # for nearPD (nearest positive definite matrix)
# Step 1: Create a small sensitive raw dataset
raw_data <- data.frame(
  age = c(45, 52, 51, 60, 61, 48, 53, 46),
  systolic_bp = c(132, 140, 135, 150, 148, 130, 142, 128)
)
# Step 2: Compute mean and covariance matrix of the raw data
raw_mean <- colMeans(raw_data)
raw_cov <- cov(raw_data)
# Step 3: Define privacy budget and add Gaussian noise
epsilon <- 0.5 # Lower epsilon = stronger privacy = more noise
set.seed(42) # For reproducibility
# Add noise to mean
noisy_mean <- raw_mean + rnorm(2, mean = 0, sd = 5 / epsilon)
# Add noise to covariance matrix
noisy_cov <- raw_cov + matrix(rnorm(4, mean = 0, sd = 10 / epsilon),
                              nrow = 2)
# Step 4: Make sure covariance matrix is positive definite
noisy_cov_pd <- as.matrix(nearPD(noisy_cov)$mat)
# Step 5: Generate synthetic data from noisy statistics
syn_data <- mvrnorm(n = nrow(raw_data), mu = noisy_mean, Sigma =
                      noisy_cov_pd)
syn_data <- as.data.frame(syn_data)
colnames(syn_data) <- colnames(raw_data)
# Step 6: Print the synthetic dataset
print(round(syn_data, 2)) # rounded for readability