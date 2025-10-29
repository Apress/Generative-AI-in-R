# Ch02_insdplyr.R
# Installing dplyr
install.packages("dplyr")
# Loading the package
library(dplyr)
# Example of data manipulation using dplyr
df <- data.frame(Name = c("Alice", "Bob", "Charlie"), Age = c(25, 30, 35))
df_filtered <- df %>% filter(Age > 25)
print(df_filtered)
