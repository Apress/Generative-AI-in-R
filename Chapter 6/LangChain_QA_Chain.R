# 6.2: LangChain_QA_Chain.R
# 1. Load necessary libraries
if (!requireNamespace("text", quietly = TRUE)) install.packages("text")
if (!requireNamespace("openai", quietly = TRUE)) install.packages("openai")
if (!requireNamespace("RcppAnnoy", quietly = TRUE)) install.
packages("RcppAnnoy")
library(text)
library(openai)
library(RcppAnnoy)
# 2. Define a simple vector store builder
build_vector_store <- function(docs) {
  embeddings <- textEmbedModel(docs, model = "all-mpnet-base-v2")
  index <- AnnoyAngular$new(ncol(embeddings))
  for (i in seq_along(docs)) index$addItem(i, embeddings[i, ])
  index$build(n_trees = 10)
  list(index = index, embeddings = embeddings, docs = docs)
}
# 3. Retrieve top-k documents for a given query
retrieve_context <- function(query, store, k = 2) {
  q_embed <- textEmbedModel(query, model = "all-mpnet-base-v2")
  ids <- store$index$getNNsByVector(q_embed, k)
  store$docs[ids]
}
# 4. Define a prompt template with memory
build_prompt <- function(query, context, memory = NULL) {
  full_context <- paste(context, collapse = " ")
  mem <- if (!is.null(memory)) paste("Past Context:\n", memory) else ""
  paste(
    mem,
    "\n\nQuery:", query,
    "\n\nRelevant Information:\n", full_context,
    "\n\nAnswer:"
  )
}
# 5. Define a wrapper for OpenAI LLM call
query_llm <- function(prompt_text, model = "gpt-4") {
  response <- create_chat_completion(
    model = model,
    messages = list(
      list(role = "system", content = "You are a helpful assistant."),
      list(role = "user", content = prompt_text)
    )
  )
  response$choices[[1]]$message$content
}
# 6. Simulate an end-to-end LangChain-like QA pipeline
langchain_simulation <- function(user_query, vector_store, memory = NULL) {
  context <- retrieve_context(user_query, vector_store)
  prompt <- build_prompt(user_query, context, memory)
  answer <- query_llm(prompt)
  cat("User Query:\n", user_query, "\n\nGenerated Answer:\n", answer, "\n")
  return(answer)
}
# 7. Example usage
docs <- c(
  "The daily withdrawal limit on MaxSavers account is $1000.",
  "No monthly fees apply on MaxSavers accounts.",
  "Minimum age to open MaxSavers is 18 years."
)
store <- build_vector_store(docs)
# Simulated memory (optional)
memory_log <- "The user previously asked about account types and fees."
# Run QA chain
langchain_simulation("Can I withdraw 2000 from my MaxSavers?", store,
                     memory = memory_log)