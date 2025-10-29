# 5.5.4_positional_encoding.R
# Function to generate sinusoidal positional encoding
positional_encoding <- function(max_len, d_model) {
  # Initialize encoding matrix
  PE <- matrix(0, nrow = max_len, ncol = d_model)
  # Compute sinusoidal values for each position and dimension
  for (pos in 0:(max_len - 1)) {
    for (i in 0:(d_model / 2 - 1)) {
      angle_rate <- pos / (10000 ^ (2 * i / d_model))
      PE[pos + 1, 2 * i + 1] <- sin(angle_rate) # odd index (1-based)
      PE[pos + 1, 2 * i + 2] <- cos(angle_rate) # even index
    }
  }
  return(PE)
}
# ==== Example Call ====
# Generate positional encodings for 10 positions with model dimension 6
PE_matrix <- positional_encoding(max_len = 10, d_model = 6)
# Print a few rows for inspection
cat("Sample Positional Encoding Matrix (first 5 positions):\n")
print(round(PE_matrix[1:5, ], 4))
