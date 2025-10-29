# Load dplyr
install.packages('dplyr')
library(dplyr)
# Create a sample dataset
df <- data.frame(Name = c('Alice', 'Bob', 'Charlie', 'David', 'Eva'),
                 Age = c(25, 30, 35, 40, 45),
                 Score = c(85, 90, 95, 80, 88))
# Filter rows where Age is greater than 30
df_filtered <- df %>% filter(Age > 30)
print(df_filtered)
# Summarize the average Score
avg_score <- df %>% summarize(average_score = mean(Score))
print(avg_score)
```