# Load reticulate to interface with Python
library(reticulate)
# Import the PyTorch FID module (make sure it's installed in your Python environment)
fid <- import("pytorch_fid")
# Compute FID score using directories containing real and generated images
fid_score <- fid$calculate_fid_given_paths(paths = c("real_images", "generated_images"), # Update these paths as  per your directory structure
  batch_size = 50, # Batch size for processing images
  device = "cpu", # Use 'cuda' if GPU is available
  dims = 2048 # Dimension of features from InceptionV3 (default = 2048)
)
# Display the FID score
cat("FID Score:", fid_score, "\n")