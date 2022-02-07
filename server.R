## app.R ##
library(shiny)
library(shinydashboard)
library(dplyr)

source("./scripts/timeline_plot.R")
source("./scripts/read_config.R")


server <- function(input, output) {
  
  rv <- reactiveValues(selected_type = "technologies")
  observeEvent(input[["timeline_click"]],{
    rv[["selected_type"]] <-tolower(input[["timeline_click"]][["panelvar1"]])
  })
  
  timeline_rv <- reactive({
    validate(
      need(length(input[["plot_checkbox"]])>0,
           message="Please select at least one category.")
    )
    timeline %>%
      filter(type %in% input[["plot_checkbox"]])
  })
  
  output[["plot_timeline"]] <- renderPlot({
    mutate(timeline_rv(), type = factor(type, 
                                   levels = levels(type), 
                                   labels = toTitleCase(levels(type)))
    ) %>%
      ggplot(aes(x = time, y = name, group = name)) +
      geom_line(position=position_dodge2(width = 1.5), size = 2) +
      facet_wrap(~ type, ncol = 1, scales = "free") +
      labs(x="", y="") + 
      scale_x_date(limits = c(min(timeline[["time"]]) - 1, max(timeline[["time"]]) + 1 ), expand = c(0.02,0.05,0,0.05)) +
      theme_bw(base_size = 11) +
      theme(panel.border = element_blank(),
            strip.background = element_blank(),
            strip.text = element_text(hjust = 0, size=12), 
            axis.text.y = element_text(size = 10),
            axis.text.x = element_text(size = 10)
      ) 
  })
  
  output[["dynamic_plot"]] <- renderUI({
    validate(
      need(length(input[["plot_checkbox"]])>0,
           message="Please select at least one category.")
    )
    plotOutput(
      "plot_timeline", 
      height = 150 * length(input[["plot_checkbox"]]),
      click = "timeline_click"
    )
  })
  
  output[["text_panel"]] <- renderUI({
    panel_name <- rv[["selected_type"]]
    includeMarkdown(
      config[["panels"]][[panel_name]]
    )
  })
}
