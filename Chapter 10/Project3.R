library(text2vec)
# Sample documents (could be loaded from files or any source)
docs <- c(
  "R is a programming language for statistical computing and graphics.",
  "Generative adversarial networks (GANs) pit two neural networks against
each other to produce realistic data.",
  "The capital of France is Paris.",
  "The **reticulate** package allows R to interface with Python."
)
# Create an iterator and vocabulary
it_docs <- itoken(docs, progressbar = FALSE)
vocab <- create_vocabulary(it_docs) %>% prune_vocabulary(term_count_min = 2)
vectorizer <- vocab_vectorizer(vocab)
# Use Tf-idf for weighting important terms
dtm <- create_dtm(it_docs, vectorizer)
tfidf <- TfIdf$new()
dtm_tfidf <- fit_transform(dtm, tfidf)
# dtm_tfidf is a document-term matrix with TF-IDF weights.
# We will use row vectors from this as document embeddings.
doc_embeddings <- as.matrix(dtm_tfidf)
rownames(doc_embeddings) <- paste0("Doc", 1:nrow(doc_embeddings))
# Load required package
library(text2vec)
# User query
query <- "What is a GAN?"
# Vectorize the query using the same vocabulary and tfidf model
it_query <- itoken(query, progressbar = FALSE)
query_dtm <- create_dtm(it_query, vectorizer)
query_tfidf <- transform(query_dtm, tfidf)
query_vec <- as.matrix(query_tfidf)
# Compute cosine similarity between query and each doc
library(Matrix)
cosine_sim <- sim2(x = doc_embeddings, y = query_vec, method = "cosine",
                   norm = "l2")
cosine_sim
# Identify the top document
best_idx <- which.max(cosine_sim)
best_doc <- docs[best_idx]
cat("Top retrieved document:\n", best_doc)
library(reticulate)
# Import the HuggingFace transformers Python library
transformers <- import("transformers")
# Initialize a question-answering pipeline using a pretrained DistilBERT model fine-tuned on SQuAD
qa_pipeline <- transformers$pipeline(
  task = "question-answering",
  model = "distilbert-base-cased-distilled-squad"
)
# Define the input: question from earlier + the most relevant document returned from retrieval
qa_input <- dict(
  question = query, # e.g., "What is a GAN?"
  context = best_doc # e.g., "Generative adversarial networks (GANs) pit two neural networks..."
)
# Run the pipeline to get the answer from the context
result <- qa_pipeline(qa_input)
# Print the predicted answer (text span from the context)
print(result$answer)
