# Load ggplot2
install.packages('ggplot2')
library(ggplot2)
# Scatter plot of Age vs. Score
ggplot(df, aes(x = Age, y = Score)) +
  geom_point() +
  labs(title = 'Age vs Score', x = 'Age', y = 'Score') +
  theme_minimal()