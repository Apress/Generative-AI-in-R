# 6.2.2: StableDiffusionPipeline.R
library(reticulate)
# Import Python Diffusers and Torch
sd <- import("diffusers")
torch <- import("torch")
# Load Stable Diffusion pipeline (this will download model weights)
pipe <- sd$StableDiffusionPipeline$from_pretrained(
  "runwayml/stable-diffusion-v1-5",
  revision = "fp16",
  torch_dtype = torch$float16
)
pipe$to("cuda") # Move to GPU if available
# Generate an image with a textual prompt
prompt <- "A fantasy landscape, sunset over mountains, digital art"
result <- pipe(prompt, guidance_scale = 7.5)
img <- result$images[[1]]
# Display the image (requires the 'grid' or 'magick' package in R)
if (requireNamespace("magick", quietly = TRUE)) {
  magick::image_write(img, path = "output.png")
  cat("Image saved to output.png\n")
} else {
  print("magick package not installed; cannot display image.")
}