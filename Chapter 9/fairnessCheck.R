library(fairmodels)
library(DALEX)
# Suppose `synthetic_data` is our generated tabular data and it has similar structure to original.
# For demonstration, use the built-in 'german' credit data as a stand-in for synthetic data:
  data("german") # german credit data, has 'Sex' and 'Risk' (good/bad loan)
head(german) # inspect data columns (Sex, Age, Job, Housing, Risk, etc.)
# Fit a simple model on the data (e.g., logistic regression predicting Risk)
model <- glm(Risk ~ ., data = german, family = binomial)
y_numeric <- as.numeric(german$Risk) - 1 # convert factor to 0/1 numeric outcome
# Create a DALEX explainer for the model
explainer <- DALEX::explain(model, data = german[,-1], y = y_numeric, label =
                              "LogisticModel")
# Use fairness_check to evaluate bias with Sex as protected attribute
(privileged = "male")
fobject <- fairness_check(explainer, protected = german$Sex, privileged =
                            "male")
print(fobject)
plot(fobject)