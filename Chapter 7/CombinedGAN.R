# -------------------------------
# Combined GAN Model
# -------------------------------
# This model connects the generator and discriminator end-to-end.
# It is used to train the generator with feedback from the discriminator.
# Step 1: Freeze the discriminator so that its weights are not updated during generator training
discriminator$trainable <- FALSE
# Step 2: Define input for the GAN - latent vector (random noise)
gan_input <- layer_input(shape = c(latent_dim)) # e.g., latent_dim = 100
# Step 3: Pass the latent vector through the generator, then to the frozen
discriminator
gan_output <- discriminator(generator(gan_input))
# Step 4: Define and compile the GAN model
gan <- keras_model(inputs = gan_input, outputs = gan_output)
# Use binary crossentropy loss to measure how well the generator fools the
discriminator
# Adam optimizer is commonly used for stable GAN training
gan %>% compile(
  optimizer = optimizer_adam(learning_rate = 0.0002, beta_1 = 0.5),
  loss = "binary_crossentropy"
)
# -------------------------------------------------------------------------
# Training Loop for GAN
# -------------------------------------------------------------------------
# Parameters
batch_size <- 64 # Total images per training step
epochs <- 10000 # Total number of training iterations
half_batch <- batch_size / 2 # Used to train discriminator on half real and half fake
for(epoch in 1:epochs) {
  # -----------------------------------------------------------------------
  # 1. Train the Discriminator
  # -----------------------------------------------------------------------
  # Select a random half-batch of real images
  idx <- sample(1:nrow(real_images), half_batch)
  real_imgs_batch <- real_images[idx,,,drop=FALSE]
  # Generate a half-batch of fake images from noise
  noise <- matrix(rnorm(half_batch * latent_dim), nrow = half_batch)
  gen_imgs_batch <- predict(generator, noise)
  # Create labels for real (1) and fake (0)
  real_labels <- matrix(1, nrow = half_batch, ncol = 1)
  fake_labels <- matrix(0, nrow = half_batch, ncol = 1)
  # Train discriminator on real images
  d_loss_real <- discriminator %>% train_on_batch(real_imgs_batch,real_labels)
  # Train discriminator on fake images
  d_loss_fake <- discriminator %>% train_on_batch(gen_imgs_batch,fake_labels)
  # Average the two discriminator losses
  d_loss <- 0.5 * (d_loss_real + d_loss_fake)
  # -----------------------------------------------------------------------
  # 2. Train the Generator via the Combined GAN
  # -----------------------------------------------------------------------
  # Generate a full batch of noise
  noise <- matrix(rnorm(batch_size * latent_dim), nrow = batch_size)
  # Generator wants discriminator to believe fake images are real →   use label 1
  trick_labels <- matrix(1, nrow = batch_size, ncol = 1)
  # Train the generator via the GAN model (discriminator weights   are frozen)
g_loss <- gan %>% train_on_batch(noise, trick_labels)
# -----------------------------------------------------------------------
# 3. Print Progress
# -----------------------------------------------------------------------
if(epoch %% 1000 == 0) {
  cat(sprintf("Epoch %d: D_loss = %.4f, G_loss = %.4f\n", epoch, d_loss,
              g_loss))
}
}
# -------------------------------------------------------------------------
# Generate Synthetic Images Using the Trained Generator
# -------------------------------------------------------------------------
# Number of new synthetic samples to generate
n_samples <- 5
# Sample random latent vectors (noise) from a normal distribution
noise <- matrix(rnorm(n_samples * latent_dim), nrow = n_samples)
# Generate synthetic images from the latent vectors using the generator
synthetic_images <- predict(generator, noise)
# Output shape: (n_samples, 64, 64, 3)
# Pixel values will be in the range [-1, 1] due to 'tanh' activation in the
generator
# -------------------------------------------------------------------------
# Post-process for Viewing or Saving
# -------------------------------------------------------------------------
# Rescale pixel values from [-1, 1] to [0, 255]
synthetic_images <- (synthetic_images * 127.5 + 127.5)
synthetic_images <- as.integer(synthetic_images) # Convert to integer for image libraries
# -------------------------------------------------------------------------
# Displaying the First Image (Example using imager)
# -------------------------------------------------------------------------
# Optional: install.packages("imager") if not already installed
# library(imager)
# image_array <- synthetic_images[1,,,] # shape: 64x64x3
# im <- as.cimg(image_array / 255) # imager expects [0,1] values
# plot(im, main = "Generated Image 1")
  