## app.R ##
library(shiny)
library(shinydashboard)
library(dplyr)

source("./scripts/timeline_plot.R")



server <- function(input, output) {
  
  output[["plot_timeline"]] <- renderPlot({
    validate(
      need(length(input[["plot_checkbox"]])>0,
      message="Please select at least one category.")
    )
    timeline %>%
      filter(type %in% input[["plot_checkbox"]]) %>%
      ggplot(aes(x = time, y = name, group = name)) +
      geom_line(position=position_dodge2(width = 1.5)) +
      facet_wrap(~ type, ncol = 1, scales = "free_y") +
      labs(x="", y="")
  })
  output[["dynamic_plot"]] <- renderUI({
    plotOutput("plot_timeline", height = 100 * length(input[["plot_checkbox"]]))
  })

}
