#neuralnet_iris.R
#Install neuralnet package
install.packages("neuralnet")
library(neuralnet)
# Scale the data
scaled_iris <- as.data.frame(scale(iris[, -5]))
scaled_iris$Species <- iris$Species
# Train a neural network model
nn_model <- neuralnet(Species ~ Sepal.Length + Sepal.Width + Petal.Length +
                        Petal.Width, data = scaled_iris, hidden = 3)
# Plot the neural network
plot(nn_model)
