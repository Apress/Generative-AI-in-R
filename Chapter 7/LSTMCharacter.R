# Load required libraries
library(keras)
library(stringr)
# -------------------------------------------------------------------------
# STEP 1: Define Input Text Corpus
# -------------------------------------------------------------------------
# Example training text — replace with your full dataset as needed
text <- "Q: What is the capital of France? A: Paris. Q: Who wrote 'Romeo
and Juliet'? A: William Shakespeare. ..."
text <- tolower(text) # Normalize to lowercase
cat("Corpus length:", nchar(text), "characters\n")
# -------------------------------------------------------------------------
# STEP 2: Prepare Character Set and Index Mapping
# -------------------------------------------------------------------------
chars <- sort(unique(strsplit(text, "")[[1]])) # Unique characters in the text
cat("Unique characters:", length(chars), "\n")
# Create character to index mapping
char_indices <- 1:length(chars)
names(char_indices) <- chars
# -------------------------------------------------------------------------
# STEP 3: Create Input Sequences and Next-Character Labels
# -------------------------------------------------------------------------
seq_length <- 100 # Length of input sequences
step <- 5 # Slide window by 5 characters
sentences <- c() # Stores input sequences
next_chars <- c() # Stores next character to predict
for(i in seq(1, nchar(text) - seq_length, by = step)) {
  seq <- substr(text, i, i + seq_length - 1)
  next_char <- substr(text, i + seq_length, i + seq_length)
  sentences <- c(sentences, seq)
  next_chars <- c(next_chars, next_char)
}
cat("Number of sequences:", length(sentences), "\n")
# -------------------------------------------------------------------------
# STEP 4: One-hot Encode the Sequences
# -------------------------------------------------------------------------
X <- array(0, dim = c(length(sentences), seq_length, length(chars)))
# Input shape: [samples, time steps, features]
y <- array(0, dim = c(length(sentences), length(chars)))
# Output shape: [samples, target_char_index]
for(i in 1:length(sentences)) {
  seq <- sentences[i]
  for(t in 1:seq_length) {
    char <- substr(seq, t, t)
    X[i, t, char_indices[[char]]] <- 1 # One-hot encode character at  position t
  }
  target_char <- next_chars[i]
  y[i, char_indices[[target_char]]] <- 1 # One-hot encode the next
  character
}
# -------------------------------------------------------------------------
# STEP 5: Define the LSTM Model
# -------------------------------------------------------------------------
model <- keras_model_sequential() %>%
  layer_lstm(units = 256, input_shape = c(seq_length, length(chars))) %>%
  layer_dense(units = length(chars), activation = "softmax")
# Compile the model
model %>% compile(
  loss = "categorical_crossentropy",
  optimizer = optimizer_rmsprop(lr = 0.01)
)
# Show model summary
model %>% summary()
