## app.R ##
library(shiny)
library(shinydashboard)

source("./scripts/timeline_plot.R")



server <- function(input, output) {

  output$plot_timeline <- renderPlot({
    timeline_plot
  })
}
