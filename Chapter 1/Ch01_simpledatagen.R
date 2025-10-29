# Ch01_simpledatagen.R

# Load necessary libraries
library(dplyr)

# Set seed for reproducibility
set.seed(123)

# Generate synthetic data
synthetic_data <- data.frame(
  ID = 1:1000,  # Unique identifier for each customer
  Age = round(rnorm(1000, mean = 35, sd = 10)),  # Age centered at 35, with some variation
  Salary = round(rnorm(1000, mean = 50000, sd = 15000)),  # Salary centered at 50000, with variation
  Churn = sample(c(0, 1), 1000, replace = TRUE, prob = c(0.7, 0.3))  # Churn status, 70% stay (0), 30% leave (1)
)

# View first few rows of the generated data
head(synthetic_data)
