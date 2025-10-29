# Simple BLEU-like metric in pure R
simple_bleu <- function(reference, candidate) {
  ref <- unlist(reference)
  cand <- unlist(candidate)
  overlap <- sum(cand %in% ref)
  precision <- overlap / length(cand)
  brevity_penalty <- min(1, exp(1 - length(ref) / length(cand)))
  bleu <- brevity_penalty * precision
  return(bleu)
}

reference <- list(c("this", "is", "a", "test"))
candidate <- list(c("this", "is", "test"))
bleu_score <- simple_bleu(reference, candidate)
print(bleu_score)
