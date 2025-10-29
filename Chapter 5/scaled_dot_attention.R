# 5.5.1_scaled_dot_attention.R
# Define a function to compute scaled dot-product attention
scaled_dot_attention <- function(Q, K, V) {
  d_k <- ncol(K) # Dimensionality of the key vectors (used for scaling)
  # Compute dot products between Q and K, then scale
  scores <- Q %*% t(K) / sqrt(d_k)
  # Apply softmax row-wise to get attention weights
  weights <- t(apply(scores, 1, function(x) exp(x) / sum(exp(x))))
  # Compute the final attention output
  output <- weights %*% V
  return(output)
}
# Example: Define dummy Q, K, V matrices (2 queries, 3 keys/values, 4-dim vectors)
Q <- matrix(c(1, 0, 1, 0,
              0, 1, 0, 1), nrow = 2, byrow = TRUE)
K <- matrix(c(1, 0, 1, 0,
              0, 1, 0, 1,
              1, 1, 0, 0), nrow = 3, byrow = TRUE)
V <- matrix(c(1, 2, 3, 4,
              5, 6, 7, 8,
              9, 10, 11, 12), nrow = 3, byrow = TRUE)
# Call the attention function
attention_output <- scaled_dot_attention(Q, K, V)
# Print the output
print("Scaled Dot-Product Attention Output:")
print(attention_output)
