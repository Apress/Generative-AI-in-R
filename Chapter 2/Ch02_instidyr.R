# Ch02_instidyr.R
# Installing tidyr
install.packages("tidyr")
# Loading the package
library(tidyr)
# Example of reshaping data using tidyr

df_wide <- data.frame(Name = c("Alice", "Bob"), Math = c(80, 90), Science =
                        c(85, 95))
df_long <- pivot_longer(df_wide, cols = c(Math, Science), names_to =
                          "Subject", values_to = "Score")
print(df_long)
