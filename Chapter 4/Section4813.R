# Section 4.8.1.3 – Evaluation Metrics: Perceptual Path Length (PPL)
# This function simulates PPL by measuring output variation for latent perturbations.
# Simulated latent vectors
z1 <- rnorm(10)
z2 <- z1 + rnorm(10, mean = 0, sd = 0.1) # Slightly perturbed
# Simulated GAN generator outputs (e.g., as 10D features)
G_z1 <- rnorm(10)
G_z2 <- rnorm(10)
# Compute PPL: norm of output change over latent change
ppl <- sum((G_z1 - G_z2)^2) / sum((z1 - z2)^2)
print(ppl)
