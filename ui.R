## ui.R ##
library(shinydashboard)
library(markdown)


source("./scripts/read_config.R")
load("./data/statistics.rda")
tagList(
  tags$head(
    includeCSS("styles.css")
  ),
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
        condition = show_element[["data_aquired"]],
        ui_element[["data_aquired"]]
      )
    ),
    dashboardBody(
      fluidRow(
        box(
          checkboxGroupInput(
            "plot_checkbox", 
            label="Click on panel to see more details",
            choices=c(
              "Industry" = "industry",
              "Technologies" = "technologies",
              "Academia" = "academia",
              "Community" = "community"
            ),
            selected = c("industry", "technologies"),
            inline=TRUE
          ),
          uiOutput("dynamic_plot"),
          title="Career timeline"
        )
      )
    )
  ),
  tags$footer(HTML("Developed by <a href='https://github.com/agosiewska'>@agosiewska</a>"), 
              align = "right", 
              class="footer")
)