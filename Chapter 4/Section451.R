# Section 4.5.1 – Bayesian Networks
# This code creates and visualizes a simple Bayesian Network using the 'bnlearn' package in R.
# Install and load the required package
install.packages("bnlearn") # Run once to install
library(bnlearn)
# Define a simple Bayesian Network structure using a model string
# Here: X → Y → Z (X influences Y, which in turn influences Z)
dag <- model2network("[X][Y|X][Z|Y]")
# Visualize the Bayesian Network structure
plot(dag)
