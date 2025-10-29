# -------------------------------------------------------------
# Capstone Project 1: Conditional GAN for MNIST Digit Generation
# -------------------------------------------------------------
# Load required libraries
library(keras)
library(tensorflow)
library(ggplot2)
# -------------------------------
# 1. Load and Prepare MNIST Data
# -------------------------------
mnist <- dataset_mnist()
x_train <- mnist$train$x # Training images: shape (60000, 28, 28)
y_train <- mnist$train$y # Training labels: shape (60000,)
# Normalize pixel values to [0, 1]
x_train <- x_train / 255
# Reshape to include channel dimension: (60000, 28, 28, 1)
x_train <- array_reshape(x_train, c(nrow(x_train), 28, 28, 1))
# Convert labels to integer (for one-hot encoding later)
y_train <- as.integer(y_train)
# -------------------------------
# 2. Define Model Parameters
# -------------------------------
img_shape <- c(28, 28, 1) # Shape of MNIST image
num_classes <- 10 # Digits 0–9
latent_dim <- 100 # Dimension of noise vector for generator
# -------------------------------
# 3. Build the Generator Model
# -------------------------------
# Inputs: noise vector and label (as one-hot vector)
noise_input <- layer_input(shape = c(latent_dim), name = "noise_input")
label_input <- layer_input(shape = c(num_classes), name = "label_input")
# Concatenate noise and label
merged_input <- layer_concatenate(list(noise_input, label_input), name =
                                    "generator_input")
# Dense layers to project and reshape into image
gen_dense1 <- merged_input %>%
  layer_dense(units = 128, activation = "relu") %>%
  layer_dense(units = prod(img_shape), activation = "sigmoid")
# Reshape output to image format
gen_output <- gen_dense1 %>%
  layer_reshape(target_shape = img_shape, name = "generated_image")
# Final Generator model
generator <- keras_model(inputs = list(noise_input, label_input), outputs =
                           gen_output, name = "Generator")
# -------------------------------
# 4. Build the Discriminator Model
# -------------------------------
# Inputs: image and corresponding label
image_input <- layer_input(shape = img_shape, name = "image_input")
label_input_d <- layer_input(shape = c(num_classes), name = "label_input_
for_disc")
# Flatten image and concatenate with label
flat_image <- image_input %>% layer_flatten()
merged_input_d <- layer_concatenate(list(flat_image, label_input_d), name =
                                      "discriminator_input")
# Dense layers to classify as real or fake
disc_dense1 <- merged_input_d %>% layer_dense(units = 128, activation =
                                                "relu")
disc_output <- disc_dense1 %>% layer_dense(units = 1, activation =
                                             "sigmoid", name = "real_or_fake")
# Final Discriminator model
discriminator <- keras_model(inputs = list(image_input, label_input_d),
                             outputs = disc_output, name = "Discriminator")
# Compile Discriminator
discriminator %>% compile(
  optimizer = optimizer_adam(lr = 0.0002, beta_1 = 0.5),
  loss = "binary_crossentropy"
)
# ---------------------------------------------
# 5. Combined CGAN: Generator + Frozen Discriminator
# ---------------------------------------------
# Freeze discriminator during generator training
discriminator$trainable <- FALSE
# Inputs for CGAN: noise + label
noise_input_cgan <- layer_input(shape = c(latent_dim), name = "noise_
input_cgan")
label_input_cgan <- layer_input(shape = c(num_classes), name = "label_
input_cgan")
# Generate image and check its validity
gen_image <- generator(list(noise_input_cgan, label_input_cgan))
validity <- discriminator(list(gen_image, label_input_cgan))
# Final CGAN model
cgan <- keras_model(inputs = list(noise_input_cgan, label_input_cgan),
                    outputs = validity, name = "CGAN_combined")
# Compile CGAN
cgan %>% compile(
  optimizer = optimizer_adam(lr = 0.0002, beta_1 = 0.5),
  loss = "binary_crossentropy"
)
# -------------------------------
# 6. Training Loop
# -------------------------------
epochs <- 1000
batch_size <- 32
half_batch <- as.integer(batch_size / 2)
for (epoch in 1:epochs) {
  # ---- Train Discriminator ----
  # Sample real images
  idx <- sample(1:nrow(x_train), half_batch)
  real_imgs <- x_train[idx, , , , drop = FALSE]
  real_labels <- y_train[idx]
  real_labels_oh <- to_categorical(real_labels, num_classes)
  # Generate fake images with random noise and labels
  noise <- matrix(runif(half_batch * latent_dim), nrow = half_batch)
  fake_labels <- sample(0:(num_classes-1), half_batch, replace = TRUE)
  fake_labels_oh <- to_categorical(fake_labels, num_classes)
  gen_imgs <- generator %>% predict(list(noise, fake_labels_oh))
  # Discriminator training: real -> 1, fake -> 0
  d_loss_real <- discriminator %>% train_on_batch(
    list(real_imgs, real_labels_oh), matrix(1, nrow = half_batch, ncol = 1)
  )
  d_loss_fake <- discriminator %>% train_on_batch(
    list(gen_imgs, fake_labels_oh), matrix(0, nrow = half_batch, ncol = 1)
  )
  # Average discriminator loss
  d_loss <- 0.5 * (d_loss_real + d_loss_fake)
  # ---- Train Generator ----
  noise2 <- matrix(runif(batch_size * latent_dim), nrow = batch_size)
  random_labels <- sample(0:(num_classes-1), batch_size, replace = TRUE)
  random_labels_oh <- to_categorical(random_labels, num_classes)
  # Generator tries to fool discriminator: labels = 1 (real)
  g_loss <- cgan %>% train_on_batch(
    list(noise2, random_labels_oh), matrix(1, nrow = batch_size, ncol = 1)
  )
  # Print progress every 100 epochs
  if (epoch %% 100 == 0) {
    cat(sprintf("Epoch %d / %d [D loss: %.4f] [G loss: %.4f]\n", epoch,
                epochs, d_loss, g_loss))
  }
}
# -------------------------------
# 7. Generator Summary
# -------------------------------
summary(generator)
# -------------------------------
# 8. Generate Images Using Generator
# -------------------------------
# One image per digit label (0 to 9)
noise_test <- matrix(runif(num_classes * latent_dim), nrow = num_classes)
labels_test <- 0:(num_classes - 1)
labels_test_oh <- to_categorical(labels_test, num_classes)
gen_images <- generator %>% predict(list(noise_test, labels_test_oh))
# -------------------------------
# 9. Visualize Generated Images
# -------------------------------
gen_images <- array_reshape(gen_images, c(num_classes, 28, 28))
plot_data <- data.frame()
# Convert each image into a data frame
for (i in 1:num_classes) {
  img_matrix <- gen_images[i,,]
  df <- expand.grid(x = 1:28, y = 1:28)
  df$intensity <- as.vector(img_matrix)
  df$label <- labels_test[i]
  plot_data <- rbind(plot_data, df)
}
# Plot with ggplot2
ggplot(plot_data, aes(x = x, y = y, fill = intensity)) +
  geom_tile() +
  scale_fill_gradient(low = "black", high = "white") +
  facet_wrap(~ label) +
  scale_y_reverse() + # correct image orientation
  theme_minimal() +
  labs(title = "CGAN Generated MNIST Digits")
