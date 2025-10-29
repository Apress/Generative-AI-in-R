# Section 4.6 – Energy-Based Models: Restricted Boltzmann Machines (RBMs)
# This example demonstrates how to train a basic RBM using the 'deepnet'package in R.
# Install and load the required package
install.packages("deepnet") # Run once
library(deepnet)
# Generate random training data: 100 samples, each with 10 features
train_x <- matrix(runif(100 * 10), nrow = 100, ncol = 10)
# Create random binary labels (not used directly for RBM, but useful for extensions)
train_y <- sample(0:1, 100, replace = TRUE)
# Train a Restricted Boltzmann Machine with:
# - 5 hidden units
# - 100 training epochs
# - learning rate of 0.1
rbm <- rbm.train(train_x, hidden = 5, numepochs = 100, learningrate = 0.1)
# Print the trained RBM model object
print(rbm)
