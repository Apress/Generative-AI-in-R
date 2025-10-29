# 8.3_latent_traversal.R
# Simulated latent space traversal using simple image interpolation
# Create two synthetic "digit-like" grayscale blobs (28x28)
img1 <- matrix(0, nrow = 28, ncol = 28)
img2 <- matrix(0, nrow = 28, ncol = 28)
# Define blocks representing digit strokes
img1[8:20, 10:18] <- 1.0 # Block in center-left
img2[8:20, 14:22] <- 1.0 # Block shifted right (like morphing 0 → 6)
# Interpolate between two latent representations
interpolate_images <- function(a, b, steps = 8) {
  alpha_vals <- seq(0, 1, length.out = steps)
  lapply(alpha_vals, function(alpha) (1 - alpha) * a + alpha * b)
}
# Generate interpolated images
morphed_imgs <- interpolate_images(img1, img2, steps = 8)
# Plot the sequence
if (!requireNamespace("graphics", quietly = TRUE)) {
  install.packages("graphics")
}
par(mfrow = c(1, 8), mar = c(1, 1, 1, 1))
for (img in morphed_imgs) {
  image(t(apply(img, 2, rev)), col = gray.colors(256), axes = FALSE)
}