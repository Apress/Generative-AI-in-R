# Original sensitive data (e.g., ages)
orig_ages <- c(25, 34, 46, 29, 52, 41)
# Differential privacy parameters
epsilon <- 1 # Privacy budget
sensitivity <- 1 # Sensitivity for count queries
# Manual Laplace noise function
rlaplace <- function(n, mu = 0, b = 1) {
  u <- runif(n, -0.5, 0.5)
  return(mu - b * sign(u) * log(1 - 2 * abs(u)))
}
# Generate synthetic data
set.seed(123)
noise <- rlaplace(length(orig_ages), mu = 0, b = sensitivity / epsilon)
syn_ages <- orig_ages + round(noise)
# Output
print(syn_ages)