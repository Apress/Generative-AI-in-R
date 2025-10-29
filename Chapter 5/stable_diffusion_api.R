# stable_diffusion_api.R
# Load required library
library(httr)
# Define the POST request to Hugging Face Stable Diffusion API
response <- POST(
  url = "https://api-inference.huggingface.co/models/CompVis/stablediffusion-v1-4",
  add_headers(Authorization = "Bearer <your_token_here>"), # Replace with your HF token
  body = list(inputs = "a futuristic city skyline at sunset"),
  # Text prompt
  encode = "json"
)
# Parse and save the image output from the raw response
img <- content(response, "raw")
writeBin(img, "output.png")
cat("Image successfully saved as output.png\n")