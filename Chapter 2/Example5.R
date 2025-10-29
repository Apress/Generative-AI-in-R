# Load keras
install.packages('keras')
library(keras)
# Define a neural network model
model <- keras_model_sequential() %>%
  layer_dense(units = 32, activation = 'relu', input_shape = c(4)) %>%
  layer_dense(units = 3, activation = 'softmax')
# Compile the model
model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = optimizer_rmsprop(),
  metrics = c('accuracy')
)
# Summary of the model
summary(model)