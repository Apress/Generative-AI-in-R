# Load the text2vec package
library(text2vec)
# ----------------------------------------------------------------
# Step 1: Define meaningful sentences for context
# Each sentence must contain multiple words to enable cooccurrence
# ----------------------------------------------------------------
captions <- c(
  "zero is less than one",
  "one is the first number",
  "two comes after one",
  "three is greater than two",
  "four follows three",
  "five is in the middle",
  "six is a number",
  "seven is a lucky number",
  "eight is a round number",
  "nine is just before ten"
)
# ----------------------------------------------------------------
# Step 2: Create a token iterator
# ----------------------------------------------------------------
it <- itoken(captions, progressbar = FALSE)
# ----------------------------------------------------------------
# Step 3: Build vocabulary and vectorizer
# ----------------------------------------------------------------
vocab <- create_vocabulary(it)
vectorizer <- vocab_vectorizer(vocab)
# ----------------------------------------------------------------
# Step 4: Create Term Co-occurrence Matrix (TCM)
# This matrix counts how often words appear near each other
# ----------------------------------------------------------------
tcm <- create_tcm(it, vectorizer, skip_grams_window = 5)
# ----------------------------------------------------------------
# Step 5: Train the GloVe model on the TCM
# ----------------------------------------------------------------
glove <- GlobalVectors$new(rank = 50, x_max = 10)
word_vectors_main <- glove$fit_transform(tcm, n_iter = 100)
# Combine main and context vectors for better embeddings
word_vectors_context <- glove$components
word_vectors <- word_vectors_main + t(word_vectors_context)
# ----------------------------------------------------------------
# Step 6: Extract and inspect the vector for a specific word
# ----------------------------------------------------------------
text_emb_zero <- word_vectors["zero", ]
print(text_emb_zero)
