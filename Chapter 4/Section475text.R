# Section 4.7.5 – Autoregressive Models: Text Generation using RNN
# This example shows how to build a basic autoregressive text generator using a simple RNN model in keras.
# Install and load required packages
install.packages("keras")
library(keras)
library(tensorflow)
# Sample text for demonstration
text_data <- "This is an example of autoregressive text generation."
# Tokenize the text using keras tokenizer
tokenizer <- text_tokenizer(num_words = 10000)
fit_text_tokenizer(tokenizer, text_data)
sequences <- texts_to_sequences(tokenizer, list(text_data))
input_text <- pad_sequences(sequences, maxlen = 10)
# Build a simple RNN model for text generation
model <- keras_model_sequential() %>%
  layer_embedding(input_dim = 10000, output_dim = 64) %>%
  layer_simple_rnn(units = 64, return_sequences = TRUE) %>%
  layer_simple_rnn(units = 64) %>%
  layer_dense(units = 10000, activation = "softmax")
# Compile and train the model (for demo purposes, input = output)
model %>% compile(
  loss = "sparse_categorical_crossentropy",
  optimizer = optimizer_adam(),
  metrics = c("accuracy")
)
# Train the model on dummy data (self-input)
model %>% fit(input_text, input_text, epochs = 10)
