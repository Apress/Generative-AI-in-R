# 5.5.2_masked_attention.R
# Define a function for masked scaled dot-product attention
masked_attention <- function(Q, K, V, mask) {
  d_k <- ncol(K) # Dimensionality of the key vectors
  scores <- Q %*% t(K) / sqrt(d_k) # Scaled dot product
  # Add the mask (should have same shape as scores)
  scores <- scores + mask
  # Apply softmax row-wise
  weights <- t(apply(scores, 1, function(x) exp(x) / sum(exp(x))))
  # Compute final attention output
  output <- weights %*% V
  return(output)
}
# Example: Define Q, K, V matrices (2 queries, 3 keys/values, 4-dimensional vectors)
Q <- matrix(c(1, 0, 1, 0,
              0, 1, 0, 1), nrow = 2, byrow = TRUE)
K <- matrix(c(1, 0, 1, 0,
              0, 1, 0, 1,
              1, 1, 0, 0), nrow = 3, byrow = TRUE)
V <- matrix(c(1, 2, 3, 4,
              5, 6, 7, 8,
              9, 10, 11, 12), nrow = 3, byrow = TRUE)
# Define a mask: set last key to be ignored for both queries (add large negative)
mask <- matrix(c(0, 0, -1e9,
                 0, 0, -1e9), nrow = 2, byrow = TRUE)
# Call the function
masked_output <- masked_attention(Q, K, V, mask)
# Print the output
cat("Masked Attention Output:\n")
print(masked_output)
