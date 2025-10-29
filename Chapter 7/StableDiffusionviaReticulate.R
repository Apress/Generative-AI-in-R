# Load reticulate package to use Python inside R
library(reticulate)
# Import Python modules
diffusers <- import("diffusers") # For loading diffusion models
torch <- import("torch") # For handling tensors and computation
# ---------------------------------------------------
# Load the pre-trained Stable Diffusion Pipeline
# ---------------------------------------------------
# Using Stability AI's model "runwayml/stable-diffusion-v1-5"
pipeline <- diffusers$StableDiffusionPipeline$from_pretrained(
  "runwayml/stable-diffusion-v1-5",
  torch_dtype = torch$float16 # Use half-precision for faster GPU   inference
)
pipeline$to("cuda") # Move the model to GPU. Use "cpu" if GPU is not available, but it will be much slower.
# ---------------------------------------------------
# Define your prompt for image generation
# ---------------------------------------------------
prompt <- "A serene watercolor painting of mountains in the style of
Studio Ghibli"
# ---------------------------------------------------
# Generate image using the diffusion pipeline
# ---------------------------------------------------
result <- pipeline(
  prompt = prompt,
  height = 512L, # Image height
  width = 512L, # Image width
  num_inference_steps = 50L, # Number of diffusion steps (higher =   better quality)
guidance_scale = 7.5 # How closely to follow the text prompt (higher = more faithful)
)
# ---------------------------------------------------
# Extract and save the generated image
# ---------------------------------------------------
image <- result$images[[1]] # Extract the first generated image (only one in this case)
image$save("output_image.png") # Save image as PNG