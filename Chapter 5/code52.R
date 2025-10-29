# Load the 'reticulate' library to call Python modules from R
library(reticulate)
# Activate your Python virtual environment that has PyTorch and other dependencies
use_virtualenv("r-reticulate", required = TRUE)
# Import essential Python modules into the R environment
os <- import("os") # OS utilities for path handling
torch <- import("torch") # PyTorch for loading the modeland tensors
PIL <- import("PIL.Image") # Python Imaging Library for loading images
np <- import("numpy") # NumPy for numerical operations
cv2 <- import("cv2") # OpenCV for image saving
torchvision <- import("torchvision.transforms") # For image preprocessing pipelines
# Load a pretrained CycleGAN model (e.g., Horse → Zebra translation)
# Note: Update 'model_path' to the actual path where the model .pth file is saved
model_path <- "path/to/pytorch_cycle_gan/pretrained/horse2zebra.pth"
# Load the PyTorch model (map_location="cpu" makes it compatible with CPUbased systems)
generator <- torch$load(model_path, map_location = "cpu")
# Switch the generator model to evaluation mode to disable dropout/batchnorm updates
generator$eval()
# Define the preprocessing pipeline:
# 1. Resize the image to 256x256 pixels
# 2. Convert it to a PyTorch tensor
# 3. Normalize pixel values to [-1, 1] for compatibility with GANs
transform <- torchvision$transforms$Compose(list(
  torchvision$transforms$Resize(256),
  torchvision$transforms$ToTensor(),
  torchvision$transforms$Normalize(
    mean = c(0.5, 0.5, 0.5),
    std = c(0.5, 0.5, 0.5)
  )
))
# Load the input image using PIL (e.g., a photo of a horse)
# Make sure 'horse.jpg' exists in your working directory
img <- PIL$Image$open("horse.jpg")
# Apply preprocessing and add a batch dimension (unsqueeze(0))
input_tensor <- transform(img)$unsqueeze(0)
# Run inference: Translate the horse image to zebra using the CycleGAN
generator
# Disable gradient tracking since we're in inference mode
with(torch$no_grad(), {
  fake_img <- generator(input_tensor) # Forward pass through generator
})
# Postprocess the output tensor to convert it back to an image:
# 1. Remove batch dimension using 'squeeze'
# 2. Permute tensor dimensions from [C, H, W] to [H, W, C] for image
compatibility
# 3. Scale values from [-1, 1] back to [0, 255] and convert to uint8
fake_img_np <- fake_img$squeeze()$permute(c(1L, 2L, 0L))$numpy()
fake_img_np <- ((fake_img_np + 1) / 2 * 255)$astype("uint8")
# Save the translated zebra image using OpenCV
cv2$imwrite("translated_zebra.jpg", fake_img_np)
# Print success message in the R console
cat("Translated image saved to translated_zebra.jpg\n")