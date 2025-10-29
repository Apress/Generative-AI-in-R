# Section 4.8.1.4 – Evaluation Metrics: Inception Score (IS)
# This mock function demonstrates IS computation based on entropy principles.
# Simulated probabilities for generated images across classes
p_yx <- matrix(runif(100, 0, 1), nrow = 10) # 10 images × 10 classes
p_yx <- p_yx / rowSums(p_yx)
# Marginal distribution
p_y <- colMeans(p_yx)
# Compute IS (KL divergence + exponential)
kl_divs <- rowSums(p_yx * log(p_yx / matrix(p_y, nrow = 10, ncol = 10,
                                            byrow = TRUE)))
IS <- exp(mean(kl_divs))
print(IS)
