# e1071_iris2.R
# Install e1071 package
install.packages("e1071")
library(e1071)
# Train an SVM model
svm_model <- svm(Species ~ ., data = iris, kernel = "radial")
# Print the model summary
print(svm_model)
