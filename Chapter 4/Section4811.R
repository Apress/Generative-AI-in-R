# Section 4.8.1.1 – Evaluation Metrics: Fréchet Inception Distance (FID)
# This function computes FID between real and generated feature vectors using mean and covariance statistics.
# Install required packages
install.packages("reticulate")
install.packages("expm")
library(reticulate)
library(expm)
# Define FID calculation function
compute_fid <- function(real_features, fake_features) {
  mu_real <- colMeans(real_features)
  mu_fake <- colMeans(fake_features)
  cov_real <- cov(real_features)
  cov_fake <- cov(fake_features)
  diff_mean <- sum((mu_real - mu_fake) ^ 2)
  trace_term <- sum(diag(cov_real + cov_fake - 2 * sqrtm(cov_real %*%
                                                           cov_fake)))
  fid <- diff_mean + trace_term
  return(fid)
}
# Example: simulate feature vectors
real_features <- matrix(rnorm(1000), nrow = 100)
fake_features <- matrix(rnorm(1000), nrow = 100)
# Compute FID score
fid_score <- compute_fid(real_features, fake_features)
print(fid_score)
