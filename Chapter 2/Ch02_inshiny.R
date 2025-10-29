# Ch02_inshiny.R
# Load necessary libraries
library(shiny)
library(ggplot2)
library(plotly)
# Sample dataset
df <- data.frame(
  Name = c("Alice", "Bob", "Charlie", "David", "Eva"),
  Age = c(25, 30, 35, 40, 45),
  Score = c(85, 90, 95, 80, 88)
)
# Define UI for the dashboard
ui <- fluidPage(
  titlePanel("Interactive Dashboard: Age vs Score"),
  sidebarLayout(
    # Sidebar panel for inputs
    sidebarPanel(
      sliderInput(
        "ageInput",
        "Select Age Range:",
        min = min(df$Age),
        max = max(df$Age),
        value = c(min(df$Age), max(df$Age))
      )
    ),
    # Main panel for displaying outputs
    mainPanel(
      plotlyOutput("scatterPlot") # Output plot will be displayed here
    )
  )
)
# Define server logic
server <- function(input, output) {
  # Reactive expression to filter data based on slider input
  filteredData <- reactive({
    df[df$Age >= input$ageInput[1] & df$Age <= input$ageInput[2], ]
  })
  # Render the scatter plot using plotly
  output$scatterPlot <- renderPlotly({
    gg <- ggplot(filteredData(), aes(x = Age, y = Score, text = Name)) +
      geom_point(size = 4) +
      labs(title = "Age vs Score", x = "Age", y = "Score") +
      theme_minimal()
   
    ggplotly(gg, tooltip = "text")
  })
}
# Run the Shiny app
shinyApp(ui = ui, server = server)