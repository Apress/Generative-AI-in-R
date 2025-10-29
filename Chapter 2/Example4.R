# Load plotly and ggplot2
install.packages('plotly')
library(plotly)
# Create an interactive scatter plot
p <- ggplot(df, aes(x = Age, y = Score)) +
  geom_point() +
  labs(title = 'Age vs Score')
# Convert to plotly
ggplotly(p)