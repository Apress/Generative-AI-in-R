# Load required Python modules using reticulate for R-Python interoperability
library(reticulate)
# Import the Python os module
os <- import("os")
# Import the PyTorch library for tensor operations
torch <- import("torch")
# Import the StyleGAN2 PyTorch implementation
stylegan <- import("stylegan2_pytorch")
# Instantiate the StyleGAN2 Generator with a specified image size and network capacity
generator <- stylegan$Generator(
  image_size = 1024, # Output image resolution (1024x1024)
  network_capacity = 16 # Controls model depth/width (affects quality and speed)
)
# Generate a random latent vector (input noise)
latent <- torch$randn(1L, 512L) # A single 512-dimensional latent vector
# Generate a synthetic image using the pretrained generator
image <- generator(latent)