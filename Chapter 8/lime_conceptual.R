# 8.6_lime_conceptual.R
# Conceptual simulation of LIME using dummy perturbations and
output weights
# Load libraries
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
library(ggplot2)
library(dplyr)
# Simulate perturbed inputs and corresponding outputs
perturbations <- paste0("P", 1:5)
predicted_scores <- c(0.8, 0.5, 0.3, 0.9, 0.6)
weights <- c(0.6, 0.2, -0.1, 0.7, 0.3)
# Create a data frame
df_lime <- data.frame(
  Perturbation = perturbations,
  Prediction = predicted_scores,
  Weight = weights
)
# Plot: Feature Weight vs Perturbation + Model Output Trend
ggplot(df_lime, aes(x = Perturbation)) +
  geom_bar(aes(y = Weight), stat = "identity", fill = "steelblue",
           width = 0.5) +
  geom_line(aes(y = Prediction, group = 1), color = "darkorange",
            size = 1.2) +
  geom_point(aes(y = Prediction), color = "darkorange", size = 3) + labs(title = "LIME Conceptual Explanation",
    y = "Weight / Prediction",
    x = "Perturbed Inputs"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_y_continuous(sec.axis = sec_axis(~., name = "Prediction (Line)"))