# -------------------------------
# Discriminator Network
# -------------------------------
# The discriminator takes a 64x64x3 image and predicts whether #it's real or fake (1 = real, 0 = generated)
library(keras)
library(tensorflow)
discriminator <- keras_model_sequential(name = "discriminator") %>%
  # First Convolutional Block: Downsample from 64x64 -> 32x32
  layer_conv_2d(filters = 32, kernel_size = 5, strides = 2, padding = "same",
                input_shape = c(img_height, img_width, channels)) %>%
  layer_activation("relu") %>%
  layer_dropout(rate = 0.3) %>%
  # Second Convolutional Block: Downsample from 32x32 -> 16x16
  layer_conv_2d(filters = 64, kernel_size = 5, strides = 2, padding =
                  "same") %>%
  layer_activation("relu") %>%
  layer_dropout(rate = 0.3) %>%
  # Classification Layer: Flatten and use a sigmoid to classify
  layer_flatten() %>%
  layer_dense(units = 1, activation = "sigmoid")
# -------------------------------
# Compile Discriminator
# -------------------------------
# Binary crossentropy for real/fake classification
# Adam optimizer with learning rate = 0.0002 and beta_1 = 0.5 (commonly
used for GANs)
discriminator %>% compile(
  optimizer = optimizer_adam(learning_rate = 0.0002, beta_1 = 0.5),
  loss = "binary_crossentropy"
)