# ------------------------------------------------------------
# 8.2_attention_heatmap.R
# Visualizing Transformer attention using HuggingFace (PyTorch-only) in R
# ------------------------------------------------------------
# Load reticulate for R-Python interoperability
if (!requireNamespace("reticulate", quietly = TRUE)) install.
packages("reticulate")
library(reticulate)
# Set your working Python virtual environment
use_virtualenv("YOUR PYTHON WORKING ENVIRONMENT", required = TRUE)
# (Optional: install torch + transformers if not already installed)
# py_install(c("transformers", "torch"), pip = TRUE)
# Import Python libraries
transformers <- import("transformers")
torch <- import("torch")
# Load pretrained T5 model (PyTorch-based) with attentions enabled
model_class <- transformers$T5ForConditionalGeneration
model <- model_class$from_pretrained("t5-small", output_attentions = TRUE)
# Load tokenizer
tokenizer <- transformers$AutoTokenizer$from_pretrained("t5-small")
# Define translation prompt
text <- "translate English to German: The cat sits on the mat."
# Tokenize input text into PyTorch tensors
input_tokens <- tokenizer$call(text, return_tensors = "pt")
# Generate translation with attention output
output <- model$generate(
  input_ids = input_tokens$input_ids,
  return_dict_in_generate = TRUE,
  output_attentions = TRUE
)
# Get cross-attention from last decoder layer, head 0
cross_attn <- output$cross_attentions[[length(output$cross_attentions)]]
attn_matrix <- as.array(cross_attn[1, 1, , ]) # [batch, head, tgt, src]
# Decode input and output token strings for axis labeling
input_ids <- as.integer(input_tokens$input_ids[1, ]$tolist())
decoded_input <- tokenizer$convert_ids_to_tokens(input_ids)
output_ids <- as.integer(output$sequences[1, ]$tolist())
decoded_output <- tokenizer$convert_ids_to_tokens(output_ids)
# Prepare attention matrix as a data frame
if (!requireNamespace("reshape2", quietly = TRUE)) install.
packages("reshape2")
library(reshape2)
attn_df <- melt(attn_matrix)
names(attn_df) <- c("OutputToken", "InputToken", "Weight")
attn_df$InputToken <- factor(decoded_input[attn_df$InputToken], levels =
                               decoded_input)
attn_df$OutputToken <- factor(decoded_output[attn_df$OutputToken], levels =
                                decoded_output)
# Plot attention heatmap using ggplot2
if (!requireNamespace("ggplot2", quietly = TRUE)) install.
packages("ggplot2")
library(ggplot2)
ggplot(attn_df, aes(x = InputToken, y = OutputToken, fill = Weight)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "white", high = "#005f9e") +
  labs(
    title = "Cross-Attention Heatmap (T5-small)",
    x = "Input Tokens",
    y = "Generated Output Tokens",
    fill = "Attention Weight"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))