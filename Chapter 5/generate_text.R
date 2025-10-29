# generate_text.R
# Function to simulate text generation using an autoregressive model
generate_text <- function(model_fn, start_tokens, max_length = 10) {
  generated <- start_tokens # Initialize with starting tokens
  for (i in 1:max_length) {
    probs <- model_fn(generated) # Get next-token probability distribution
    next_token <- sample(1:length(probs), size = 1, prob = probs)
    # Sample token
    generated <- c(generated, next_token) # Append token to sequence
    if (next_token == "<END>") break # Stop if <END> token is produced
  }
  return(generated) # Return the full generated token sequence
}
# ==== Example Demonstration ====
# Dummy model: always returns same probability over 5 tokens
dummy_model <- function(tokens) {
  prob <- rep(1, 5)
  prob <- prob / sum(prob)
  return(prob)
}
# Simulate generation starting from token 1 (e.g., "<START>")
set.seed(123) # For reproducibility
output <- generate_text(dummy_model, start_tokens = c(1), max_length = 10)
cat("Generated token sequence:\n", output, "\n")

