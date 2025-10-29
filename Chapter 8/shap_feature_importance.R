# 8.6_shap_feature_importance.R
# Use DALEX with a valid model object to simulate SHAP-like variable importance
# Install required packages
if (!requireNamespace("DALEX", quietly = TRUE)) {
  install.packages("DALEX")
}
if (!requireNamespace("mlr", quietly = TRUE)) {
  install.packages("mlr") # optional alternative; here we use base lm
}
library(DALEX)
# Create synthetic dataset: 5 latent features
set.seed(123)
latent_df <- as.data.frame(matrix(runif(100, -1, 1), nrow = 20))
names(latent_df) <- paste0("z", 1:5)
# Simulate target using a known formula
output_vals <- with(latent_df, 1.2*z1 - 0.5*z2 + 0.8*z3 - 0.3*z4 + 0.5*z5 +
                      rnorm(20, 0, 0.1))
# Train a linear model (can also use random forest or xgboost here)
lm_model <- lm(output_vals ~ ., data = latent_df)
# Create a DALEX explainer
explainer <- explain(
  model = lm_model,
  data = latent_df,
  y = output_vals,
  label = "Linear Generator Model"
)
# Compute permutation-based variable importance (SHAP alternative)
fi <- model_parts(explainer, type = "raw", N = 100)
print(fi)
# Plot the results
plot(fi)