# ============================================================
# File: basic_transformer.R
# Minimal Transformer Encoder model in R using keras & tensorflow
# ============================================================

library(keras)
library(tensorflow)

# ------------------------------------------------------------
# Positional Encoding
# ------------------------------------------------------------
positional_encoding <- function(sequence_length, d_model) {
  position <- matrix(1:sequence_length, nrow = sequence_length, ncol = d_model)
  i <- matrix(rep(0:(d_model - 1), each = sequence_length), nrow = sequence_length)
  
  angle_rates <- 1 / (10000 ^ (i / d_model))
  angle_rads <- position * angle_rates
  
  angle_rads[, seq(1, d_model, by = 2)] <- sin(angle_rads[, seq(1, d_model, by = 2)])
  angle_rads[, seq(2, d_model, by = 2)] <- cos(angle_rads[, seq(2, d_model, by = 2)])
  
  return(tf$constant(angle_rads, dtype = "float32"))
}

# ------------------------------------------------------------
# Scaled Dot-Product Attention
# ------------------------------------------------------------
scaled_dot_product_attention <- function(Q, K, V, mask = NULL) {
  matmul_qk <- tf$matmul(Q, K, transpose_b = TRUE)
  dk <- tf$cast(tf$shape(K)[-1], tf$float32)
  scaled_attention_logits <- matmul_qk / tf$sqrt(dk)
  
  if (!is.null(mask)) {
    scaled_attention_logits <- scaled_attention_logits + (mask * -1e9)
  }
  
  attention_weights <- tf$nn$softmax(scaled_attention_logits, axis = -1)
  output <- tf$matmul(attention_weights, V)
  return(output)
}

# ------------------------------------------------------------
# Multi-Head Attention Layer
# ------------------------------------------------------------
multi_head_attention <- function(d_model, num_heads) {
  # Native R assertion
  if (d_model %% num_heads != 0) {
    stop("d_model must be divisible by num_heads.")
  }
  depth <- d_model / num_heads
  
  layer_lambda(
    f = function(x, mask = NULL) {
      Q <- x[[1]]
      K <- x[[2]]
      V <- x[[3]]
      
      WQ <- layer_dense(units = d_model)
      WK <- layer_dense(units = d_model)
      WV <- layer_dense(units = d_model)
      WO <- layer_dense(units = d_model)
      
      Q_proj <- WQ(Q)
      K_proj <- WK(K)
      V_proj <- WV(V)
      
      attn_output <- scaled_dot_product_attention(Q_proj, K_proj, V_proj, mask)
      return(WO(attn_output))
    }
  )
}

# ------------------------------------------------------------
# Transformer Encoder Layer
# ------------------------------------------------------------
encoder_layer <- function(d_model, num_heads, dff, dropout_rate = 0.1) {
  layer_lambda(
    f = function(x, training = TRUE) {
      mha <- multi_head_attention(d_model, num_heads)
      attn_output <- mha(list(x, x, x))
      attn_output <- layer_dropout(rate = dropout_rate)(attn_output, training = training)
      
      out1 <- layer_add()(list(x, attn_output))
      
      ffn <- keras_model_sequential() %>%
        layer_dense(units = dff, activation = "relu") %>%
        layer_dense(units = d_model)
      
      ffn_output <- ffn(out1)
      ffn_output <- layer_dropout(rate = dropout_rate)(ffn_output, training = training)
      out2 <- layer_add()(list(out1, ffn_output))
      
      return(out2)
    }
  )
}

# ------------------------------------------------------------
# Transformer Model
# ------------------------------------------------------------
transformer_model <- function(sequence_length, d_model, num_heads, dff,
                              num_layers, vocab_size, dropout_rate = 0.1) {
  
  inputs <- layer_input(shape = c(sequence_length))
  embedding <- layer_embedding(input_dim = vocab_size, output_dim = d_model)(inputs)
  pos_encoding <- positional_encoding(sequence_length, d_model)
  embedded_input <- embedding + pos_encoding
  
  x <- embedded_input
  for (i in seq_len(num_layers)) {
    x <- encoder_layer(d_model, num_heads, dff, dropout_rate)(x)
  }
  
  outputs <- layer_dense(units = vocab_size, activation = "softmax")(x)
  
  model <- keras_model(inputs = inputs, outputs = outputs)
  model %>% compile(
    optimizer = "adam",
    loss = "sparse_categorical_crossentropy",
    metrics = c("accuracy")
  )
  return(model)
}

# ------------------------------------------------------------
# Test Build
# ------------------------------------------------------------
sequence_length <- 20
d_model <- 128
num_heads <- 4
dff <- 512
num_layers <- 2
vocab_size <- 10000
dropout_rate <- 0.1

model <- transformer_model(sequence_length, d_model, num_heads, dff, num_layers, vocab_size, dropout_rate)
summary(model)
