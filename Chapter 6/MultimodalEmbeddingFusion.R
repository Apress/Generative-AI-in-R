#Listing 6.8.1: MultimodalEmbeddingFusion.R
# Simulating early fusion of two modality embeddings in R
# Simulate text and image embeddings
text_embed <- runif(512, -1, 1)
image_embed <- runif(512, -1, 1)
# Concatenate and normalize
fused_vector <- c(text_embed, image_embed)
fused_vector <- fused_vector / sqrt(sum(fused_vector^2))
cat("Fused vector of length:", length(fused_vector), "\n")