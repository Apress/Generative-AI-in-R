generate_text <- function(model, seed_text, length = 200) {
  output <- seed_text # Final output text, initialized with the seed
  seed <- seed_text # Moving seed window for prediction
  for(i in 1:length) {
    # ---------------------------------------------------------------------
    # 1. Vectorize the seed into one-hot format
    # ---------------------------------------------------------------------
    x_pred <- array(0, dim = c(1, seq_length, length(chars)))
    for(t in 1:nchar(seed)) {
      char <- substr(seed, t, t)
      if(char %in% names(char_indices)) {
        x_pred[1, t, char_indices[[char]]] <- 1
      }
    }
    # ---------------------------------------------------------------------
    # 2. Predict probabilities for the next character
    # ---------------------------------------------------------------------
    preds <- model %>% predict(x_pred)
    preds <- preds[1,] # Extract the probability vector
    # ---------------------------------------------------------------------
    # 3. Pick the character with the highest probability
    # (Greedy sampling; for more creativity, use temperature sampling)
    # ---------------------------------------------------------------------
    next_index <- which.max(preds)
    next_char <- chars[next_index]
    # ---------------------------------------------------------------------
    # 4. Append to the output and update seed
    # ---------------------------------------------------------------------
    output <- paste0(output, next_char)
    seed <- paste0(substr(seed, 2, nchar(seed)), next_char) # Slide the window
  }
  return(output)
}
seed_text <- substr(text, 1, seq_length) # Take first 100 characters as the seed
generated_text <- generate_text(model, seed_text, length = 300)
cat("Generated text:\n", generated_text)