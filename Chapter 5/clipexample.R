# Load required library
library(reticulate)
# Import the CLIP module (assumes CLIP is installed in Python environment)
clip <- import("clip")
# Load a pretrained CLIP model (ViT-B/32)
clip_model <- clip$load("ViT-B/32")
# Define the prompt and the path to the image file
prompt <- "A child playing in snow"
image_path <- "snow_image.jpg" # Ensure this image exists in your working directory
# Compute similarity score between image and text prompt
score <- clip_model$similarity(image_path, prompt)
# Display the score
print(score)