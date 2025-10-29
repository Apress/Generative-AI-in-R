# === STEP 1: Load reticulate and set Python environment ===
library(reticulate)
# Define and activate your clean virtual environment
env_name <- "textenv"
# Use the environment (after R session restart)
use_virtualenv(env_name, required = TRUE)
# OPTIONAL: Verify which Python is being used
# py_config()
# === STEP 2: Install required Python packages (if not already done) ===
# Only run once per machine or if environment is new
required_pkgs <- c("torch", "transformers", "sentence-transformers",
                   "huggingface_hub","nltk")
py_install(packages = required_pkgs, envname = env_name, pip = TRUE)
# === STEP 3: Load R Libraries ===
library(text) # For sentence embedding
library(RcppAnnoy) # For Approximate Nearest Neighbors
library(openai) # To call OpenAI LLMs
# === STEP 4: Set your OpenAI API key ===
Sys.setenv(OPENAI_API_KEY = "YOUR API KEY")
# === STEP 5: Prepare your knowledge base ===
docs <- c(
  "MaxSavers account daily withdrawal limit is $1000.",
  "MaxSavers accounts have no monthly fees.",
  "Customer must be 18+ to open MaxSavers account."
)
doc_ids <- seq_along(docs)
# === STEP 6: Embed documents using BERT ===
doc_emb_obj <- textEmbed(texts = docs, model = "bert-base-uncased")
doc_embeddings <- doc_emb_obj$texts$texts_d2 # Extract numeric matrix
# === STEP 7: Build Annoy index ===
annoy_idx <- new(AnnoyAngular, ncol(doc_embeddings))
for (i in doc_ids) {
  annoy_idx$addItem(i - 1, doc_embeddings[i, ]) # Annoy uses 0-based index
}
annoy_idx$build(n_trees = 10)
# === STEP 8: Process user query and embed ===
query <- "What is the daily withdrawal limit on my MaxSavers savings account?"
query_emb_obj <- textEmbed(texts = query, model = "bert-base-uncased")
query_embedding <- as.numeric(query_emb_obj$texts$texts_d2)
# === STEP 9: Retrieve top-K relevant documents ===
top_k <- 2
retrieved_ids <- annoy_idx$getNNsByVector(query_embedding, n = top_k)
relevant_docs <- docs[retrieved_ids + 1] # Convert back to R indexing
# === STEP 10: Construct RAG prompt ===
prompt <- paste0(
  "Question: ", query, "\n\n",
  "Relevant Context:\n", paste(relevant_docs, collapse = " "), "\n\n",
  "Answer:"
)
# === STEP 11: Query OpenAI LLM ===
response <- create_chat_completion(
  model = "gpt-4",
  messages = list(
    list(role = "system", content = "You are a helpful assistant."),
    list(role = "user", content = prompt)
  )
)
# === STEP 12: Output the response ===
cat("LLM Response:\n", response$choices[[1]]$message$content, "\n")