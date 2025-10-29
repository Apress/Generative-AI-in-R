# Ch02_insdatar.R
# Installing data.table
install.packages("data.table")
# Loading the package
library(data.table)
# Example of using data.table for large data manipulation
dt <- data.table(Name = c("Alice", "Bob", "Charlie"), Age = c(25, 30, 35))
dt_filtered <- dt[Age > 25]
print(dt_filtered)
