# 6.3: LangChain_AgentSim.R
# Simulated LangChain-style agent that chooses tools dynamically
# Uses simple keyword logic for routing (can be expanded)
# 1. Simulate a calculator tool
simple_calculator <- function(expression) {
  tryCatch({
    result <- eval(parse(text = expression))
    paste("The result is", result)
  }, error = function(e) {
    "I couldn't calculate that."
  })
}
# 2. Decision logic: choose which tool to invoke
route_query <- function(query) {
  if (grepl("\\d+\\s*[+\\-*/]\\s*\\d+", query)) {
    return("calculator")
  } else if (grepl("withdraw|account|limit|fee", tolower(query))) {
    return("retrieval")
  } else {
    return("llm")
  }
}
# 3. Agent simulation combining calculator, retriever, and LLM
agent_simulation <- function(query, vector_store, memory = NULL) {
  selected_tool <- route_query(query)
  cat("Selected tool:", selected_tool, "\n")
  if (selected_tool == "calculator") {
    return(simple_calculator(query))
  } else if (selected_tool == "retrieval") {
    context <- retrieve_context(query, vector_store)
    prompt <- build_prompt(query, context, memory)
    return(query_llm(prompt))
  } else {
    prompt <- build_prompt(query, context = NULL, memory)
    return(query_llm(prompt))
  }
}
# 4. Test case
docs <- c(
  "MaxSavers daily withdrawal limit is $1000.","There are no monthly fees on this account.",
  "Minimum age for MaxSavers account is 18."
)
store <- build_vector_store(docs)
# Simulated examples
cat("\nExample 1: Account question\n")
cat(agent_simulation("What is the withdrawal limit on MaxSavers?",
                     store), "\n")
cat("\nExample 2: Math tool call\n")
cat(agent_simulation("What is 75 + 20 * 2?", store), "\n")
cat("\nExample 3: General LLM call\n")
cat(agent_simulation("Tell me about the Indian Constitution.", store), "\n")

