# 5.5.3_multihead_attention.R
# Function to compute scaled dot-product attention
scaled_dot_attention <- function(Q, K, V) {
  d_k <- ncol(K)
  scores <- Q %*% t(K) / sqrt(d_k)
  weights <- t(apply(scores, 1, function(x) exp(x) / sum(exp(x))))
  output <- weights %*% V
  return(output)
}
# Multi-head attention function
multi_head_attention <- function(Q, K, V, num_heads) {
  d_model <- ncol(Q)
  d_k <- d_model / num_heads
  if (d_model %% num_heads != 0) {
    stop("d_model must be divisible by num_heads.")
  }
  heads <- list()
  for (i in 1:num_heads) {
    idx <- ((i - 1) * d_k + 1):(i * d_k)
    # Split Q, K, V for each head
    Qi <- Q[, idx, drop = FALSE]
    Ki <- K[, idx, drop = FALSE]
    Vi <- V[, idx, drop = FALSE]
    # Compute attention for each head
    head_i <- scaled_dot_attention(Qi, Ki, Vi)
    heads[[i]] <- head_i
  }
  # Concatenate outputs from all heads
  output <- do.call(cbind, heads)
  return(output)
}
# ==== Example Call ====
# Example Q, K, V matrices with 4-dim model and 2 heads
Q <- matrix(c(1, 0, 1, 0,
              0, 1, 0, 1), nrow = 2, byrow = TRUE)
K <- matrix(c(1, 0, 1, 0,
              0, 1, 0, 1,
              1, 1, 0, 0), nrow = 3, byrow = TRUE)
V <- matrix(c(1, 2, 3, 4,
              5, 6, 7, 8,
              9, 10, 11, 12), nrow = 3, byrow = TRUE)
# Number of heads = 2
output_mha <- multi_head_attention(Q, K, V, num_heads = 2)
# Print result
cat("Multi-Head Attention Output:\n")
print(output_mha)
