# Ch02_insggplot.R
# Installing ggplot2
install.packages("ggplot2")
# Loading the package
library(ggplot2)
# Example of creating a scatter plot using ggplot2
df <- data.frame(Name = c("Alice", "Bob", "Charlie"), Age = c(25, 30, 35),
                 Score = c(85, 90, 95))
ggplot(df, aes(x = Age, y = Score)) + geom_point() + labs(title = "Age
vs Score")

