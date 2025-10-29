# Sample generated sentences (hypothetical outputs from a model)
gen_text <- c(
  "The doctor said he will see the patient now.",
  "The doctor said he will operate soon.",
  "The nurse said she will prepare the room.",
  "The nurse said she will assist the doctor.",
  "The doctor finished his shift at the hospital.",
  "The nurse finished her shift at the hospital."
)
# Use string detection to identify pronouns and roles
library(stringr)
df <- data.frame(
  role = ifelse(str_detect(gen_text, "doctor"), "doctor", "nurse"),
  pronoun = ifelse(str_detect(gen_text, "\\bhe\\b"), "male",
                   ifelse(str_detect(gen_text, "\\bshe\\b"), "female",
                          "undetermined"))
)
print(table(df$role, df$pronoun))