# Install and load required packages
install.packages("ggplot2")
install.packages("torch")
library(ggplot2)
library(torch)
# Generate synthetic 2D dataset
set.seed(42)
num_samples <- 1000
dataset <- data.frame(
  x = rnorm(num_samples, mean = 5, sd = 2),
  y = rnorm(num_samples, mean = -3, sd = 1)
)
# Visualizing the dataset
ggplot(dataset, aes(x = x, y = y)) +
  geom_point(alpha = 0.5, color = "blue") +
  ggtitle("Synthetic 2D Data Distribution") +
  theme_minimal()
#Step 2: Model Design and Training
# Define the Generator Model
generator <- nn_module(
  initialize = function() {
    self$fc1 <- nn_linear(10, 128)
    self$fc2 <- nn_linear(128, 256)
    self$fc3 <- nn_linear(256, 2) # Output: 2D points (x, y)
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
#Training the GAN:
  # Define the Generator Model
  generator <- nn_module(
    initialize = function() {
      self$fc1 <- nn_linear(10, 128)
      self$fc2 <- nn_linear(128, 256)
      self$fc3 <- nn_linear(256, 2) # Output: 2D points (x, y)
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
# Initialize models
G <- generator()
D <- discriminator()
# Define optimizers
g_optimizer <- optim_adam(G$parameters, lr=0.001)
d_optimizer <- optim_adam(D$parameters, lr=0.001)
# Training loop
num_epochs <- 5000
batch_size <- 32
for (epoch in 1:num_epochs) {
  # Generate fake data
  z <- torch_randn(batch_size, 10) # Random noise
  fake_data <- G(z)
  # Train Discriminator
  real_data <- torch_tensor(as.matrix(dataset[sample(1:num_samples, batch_size), ]))
  real_preds <- D(real_data)
  fake_preds <- D(fake_data$detach())
  d_loss <- -(torch_mean(torch_log(real_preds)) + torch_mean(torch_log(1 -fake_preds)))
  d_optimizer$zero_grad()
  d_loss$backward()
  d_optimizer$step()
  # Train Generator
  fake_preds <- D(fake_data)
  g_loss <- -torch_mean(torch_log(fake_preds))
  g_optimizer$zero_grad()
  g_loss$backward()
  g_optimizer$step()
  # Print loss every 500 epochs
  if (epoch %% 500 == 0) {
    cat(sprintf("Epoch %d - D Loss: %.4f, G Loss: %.4f\n", epoch, d_loss$item(), g_loss$item()))
  }
}
# Generate new synthetic data from the trained Generator
generated_samples <- function(generator, num_samples = 1000) {
  z <- torch_randn(num_samples, 10)
  fake_data <- as_array(generator(z))
  data.frame(x = fake_data[,1], y = fake_data[,2])
}
# Generate and visualize the data
plot_data <- generated_samples(G, 1000)
ggplot(plot_data, aes(x = x, y = y)) +
  geom_point(alpha = 0.5, color = "red") +
  ggtitle("Generated Data from GAN") +
  theme_minimal()