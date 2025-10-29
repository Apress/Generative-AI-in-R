# Section 4.7.2 – Neural Network-Based Models: Generative AdversarialNetworks (GANs)
# This code defines the Generator and Discriminator modules using the torch package in R.
# Install and load the torch package
install.packages("torch") # Run once
library(torch)
# Define the Generator Model
# Takes a random noise vector z and generates a synthetic 2D data point
generator <- nn_module(
  initialize = function() {
    self$fc1 <- nn_linear(10, 128)
    self$fc2 <- nn_linear(128, 256)
    self$fc3 <- nn_linear(256, 2) # Output: 2D point (x, y)
    self$relu <- nn_relu()
  },
  forward = function(z) {
    z <- self$relu(self$fc1(z))
    z <- self$relu(self$fc2(z))
    z <- self$fc3(z)
    return(z)
  }
)

# Define the Discriminator Model
# Takes a 2D input and outputs the probability of being real vs fake
discriminator <- nn_module(
  initialize = function() {
    self$fc1 <- nn_linear(2, 128)
    self$fc2 <- nn_linear(128, 1)
    self$relu <- nn_relu()
    self$sigmoid <- nn_sigmoid()
  },
  forward = function(x) {
    x <- self$relu(self$fc1(x))
    x <- self$sigmoid(self$fc2(x))
    return(x)
  }
)
