# 8.4_gan_vector_arithmetic.R
# Simulate vector arithmetic in GAN latent space using 28x28 grayscale mock images
# Create a neutral base face (gray background)
base_face <- matrix(0.4, nrow = 28, ncol = 28)
# Add eyeglasses component (two squares + a bar)
glasses <- matrix(0, nrow = 28, ncol = 28)
glasses[10:12, 8:20] <- 1 # top bar
glasses[12:16, 8:10] <- 1 # left lens
glasses[12:16, 18:20] <- 1 # right lens
# Add smile component (a curved "smile" at the bottom)
smile <- matrix(0, nrow = 28, ncol = 28)
smile[20:22, 12:16] <- 1
# Combine using linear vector-style arithmetic
# Final face = base + 0.6 * glasses + 0.3 * smile
result_face <- base_face + 0.6 * glasses + 0.3 * smile
result_face[result_face > 1] <- 1 # Clip to max intensity
# Plot base, additions, and result
par(mfrow = c(1, 4), mar = c(1, 1, 2, 1))
image(t(apply(base_face, 2, rev)), col = gray.colors(256), axes = FALSE,
      main = "Base Face")
image(t(apply(glasses, 2, rev)), col = gray.colors(256), axes = FALSE, main
      = "+ Glasses")
image(t(apply(smile, 2, rev)), col = gray.colors(256), axes = FALSE, main =
        "+ Smile")
image(t(apply(result_face, 2, rev)), col = gray.colors(256), axes = FALSE,
      main = "= Result")