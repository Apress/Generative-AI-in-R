# Load required libraries
library(keras) # For deep learning functions
library(stringr) # For string manipulation utilities
# -------------------------------------------------------------------------
# STEP 1: Load and preprocess text
# -------------------------------------------------------------------------
# Replace with your actual text corpus (can be from a file or pasted text)
training_text <- "Q: What is the capital of France? A: Paris. Q: Who wrote
'Romeo and Juliet'? A: William Shakespeare. ..."
# Convert the text to lowercase for normalization (reduces number of unique characters)
training_text <- tolower(training_text)
# Print the length of the corpus
cat("Corpus length:", nchar(training_text), "characters\n")
# Extract all unique characters used in the corpus
chars <- sort(unique(strsplit(training_text, "")[[1]]))
cat("Unique characters:", length(chars), "\n")
# Create a named vector that maps each character to a unique index
char_indices <- 1:length(chars)
names(char_indices) <- chars
# -------------------------------------------------------------------------
# STEP 2: Prepare sequences for supervised learning
# -------------------------------------------------------------------------
# Set the length of each input sequence (e.g., 100 characters)
seq_length <- 100
# Step size to slide the window (e.g., every 5 characters)
step <- 5
# Initialize storage vectors for input sequences and corresponding next characters
sentences <- c() # Will hold character sequences
next_chars <- c() # Will hold the next character to be predicted
# Slide a window of `seq_length` across the text to create training pairs
for (i in seq(1, nchar(training_text) - seq_length, by = step)) {
  seq <- substr(training_text, i, i + seq_length - 1)
  # Input sequence
  next_char <- substr(training_text, i + seq_length, i + seq_length)
  # Next character to predict
  sentences <- c(sentences, seq)
  next_chars <- c(next_chars, next_char)
}
cat("Number of sequences:", length(sentences), "\n")
# -------------------------------------------------------------------------
# STEP 3: One-hot encode sequences and targets
# -------------------------------------------------------------------------
# Initialize the input array: 3D array [samples, time steps, features]
X <- array(0, dim = c(length(sentences), seq_length, length(chars)))
# Initialize the target array: 2D one-hot [samples, features]
y <- array(0, dim = c(length(sentences), length(chars)))
# Loop through each sequence
for (i in 1:length(sentences)) {
  seq <- sentences[i]
  # For each character in the sequence
  for (t in 1:seq_length) {
    char <- substr(seq, t, t)
    # One-hot encode the input character at position t
    X[i, t, char_indices[[char]]] <- 1
  }
  # One-hot encode the target character
  target_char <- next_chars[i]
  y[i, char_indices[[target_char]]] <- 1
}
