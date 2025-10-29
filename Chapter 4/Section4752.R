# Section 4.7.5.2 – Autoregressive Models: Pixel-by-Pixel Image Generation
# This code simulates a basic autoregressive pixel generation process using nested loops in R.

# Define image size (e.g., 8x8 grayscale image)
image_size <- 8
generated_image <- matrix(0, nrow = image_size, ncol = image_size)

# Define a simple function to generate pixel values based on neighbors
generate_pixel <- function(left, above) {
 
  if (is.na(left) && is.na(above)) {
    base <- runif(1, 0, 1)  
  } else {
    base <- mean(c(left, above), na.rm = TRUE)
  }
  
  # 🔹 CHANGED: Add noise and clip safely within [0,1]
  pixel_value <- base + rnorm(1, mean = 0, sd = 0.1)
  pixel_value <- max(0, min(1, pixel_value)) 
  
  return(pixel_value)
}

# Sequential pixel generation (row-wise)
for (i in 1:image_size) {
  for (j in 1:image_size) {
    left <- ifelse(j > 1, generated_image[i, j - 1], NA)
    above <- ifelse(i > 1, generated_image[i - 1, j], NA)
    generated_image[i, j] <- generate_pixel(left, above)
  }
}


image(
  t(apply(generated_image, 2, rev)),   # 🔹 CHANGED: transpose + flip
  col = gray.colors(256),
  main = "Generated Image (Autoregressive)"
)
