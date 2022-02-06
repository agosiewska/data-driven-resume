## ui.R ##
library(shinydashboard)

source("./scripts/read_config.R")
load("./data/statistics.rda")

dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    br(),
    conditionalPanel(
      condition=show_element[["photo"]],
      ui_element["photo"]
    ),
    conditionalPanel(
      condition=show_element[["name"]],
      ui_element[["name"]]
    ),
    conditionalPanel(
      condition=show_element[["social_media"]],
      ui_element[["social_media"]]
    ),
    br(),
    conditionalPanel(
      condition=show_element[["about"]],
      ui_element[["about"]]
    ),
    br(),
    conditionalPanel(
      condition = show_element[["scholar"]],
    )
  ),
  dashboardBody(
    fluidRow(
      box(plotOutput("plot_timeline", height = 250))
    )
  )
)