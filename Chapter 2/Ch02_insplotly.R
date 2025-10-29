# Ch02_insplotly.R
# Installing plotly package
install.packages("plotly")
# Loading the plotly library
library(plotly)
# Sample data
df <- data.frame(Name = c("Alice", "Bob", "Charlie"), Age = c(25, 30, 35),
                 Score = c(85, 90, 95))
# Creating a scatter plot using ggplot2 and converting it to plotly
p <- ggplot(df, aes(x = Age, y = Score)) +
  geom_point() +
  labs(title = "Age vs Score")
# Converting to an interactive plot
ggplotly(p)

