# 8.7_iml_feature_importance.R
# Using the iml package for model-agnostic feature importance (Integrated
with DALEX idea)
# Install required packages
if (!requireNamespace("iml", quietly = TRUE)) {
  install.packages("iml")
}
if (!requireNamespace("mlr", quietly = TRUE)) {
  install.packages("mlr")
}
library(iml)
library(mlr)
# Prepare simulated latent data
set.seed(123)
latent_df <- as.data.frame(matrix(runif(100, -1, 1), nrow = 20))
names(latent_df) <- paste0("z", 1:5)
output_vals <- with(latent_df, 1.5*z1 - 0.7*z2 + 0.4*z3 + rnorm(20,
                                                                0, 0.1))
# Create a regression task and train a model (using random forest)
task <- makeRegrTask(data = cbind(latent_df, output_vals), target =
                       "output_vals")
learner <- makeLearner("regr.rpart") # Use "regr.randomForest" if randomForest installed
model <- train(learner, task)
# Create Predictor object for iml
predictor <- Predictor$new(
  model = model,
  data = latent_df,
  y = output_vals
)
# Compute feature importance via permutation
fi <- FeatureImp$new(predictor, loss = "mse")
# Plot importance
plot(fi)