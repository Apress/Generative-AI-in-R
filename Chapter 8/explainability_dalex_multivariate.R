# ---------------------------------------------------------
# 8.1_explainability_dalex_multivariate.R
# Interpreting a Multivariate Latent Generator using DALEX
# ---------------------------------------------------------
# Step 1: Install and load DALEX package
# If not installed, run: install.packages("DALEX")
library(DALEX)
# Step 2: Simulate input data (latent variables)
# ----------------------------------------------
# Here we create a multivariate input: z1, z2, z3, z4, z5
# These represent latent dimensions fed into a toy generator
set.seed(42) # For reproducibility
n <- 500 # Number of data points
# Generate 5 latent features with values between -3 and 3
z_data <- as.data.frame(matrix(runif(n * 5, min = -3, max = 3), ncol = 5))
colnames(z_data) <- paste0("z", 1:5) # Name columns z1 to z5
# Step 3: Define a multivariate generator function
# ------------------------------------------------
# This function simulates how a real generator (like a GAN) might transform latent vectors.
# It deliberately depends on some features more than others to illustrate feature importance:
  # - z1: Quadratic + linear (dominant influence)
  # - z3: Linear (moderate influence)
  # - z5: Weighted linear (weak influence)
  # - z2 and z4: Not used (low or no importance)
  toy_generator <- function(z_df) {
    with(z_df, z1^2 + 2 * z1 + z3 + 0.5 * z5) # Only z1, z3, z5  affect output
  }
# Step 4: Generate output values using the generator
# --------------------------------------------------
# This output simulates the "generated" data based on the latent inputs
x_generated <- toy_generator(z_data)
# Step 5: Wrap the model using DALEX explain()
# --------------------------------------------
# We now use DALEX to analyze the generator function.
# 'data' is the full input dataframe of latent variables.
# 'y' is the true/generated output.
# 'model' is the generator function we defined above.
explainer <- explain(
  model = toy_generator, # The black-box generator model
  data = z_data, # Dataframe of latent variables
  y = x_generated, # Generator's output
  label = "Latent Generator"
)
# Step 6: Compute permutation-based feature importance
# ----------------------------------------------------
# DALEX will shuffle each feature and measure how much the model's RMSE increases.
# Features causing a larger increase in RMSE are more important for predictions.
fi <- model_parts(explainer)
# Step 7: Visualize feature importance
# ------------------------------------
# This plot shows the importance of each latent variable (z1–z5).
# - z1 should appear most important.
# - z3 and z5 will have moderate importance.
# - z2 and z4 will have little to no importance (not used in generator).
plot(fi)
