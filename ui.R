## ui.R ##
library(shinydashboard)
library(markdown)
library(dashboardthemes)

source("./scripts/read_config.R")
source("./shiny_theme.R")
load("./data/statistics.rda")


tagList(
  tags$head(
    includeCSS("styles.css")
  ),
  customTheme,
  dashboardPage(
    
    dashboardHeader(title="Data-driven resume"),
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
            label="Click on the timeline to see more details about each area.",
            choices=c(
              "Technologies" = "technologies",
              "Industry" = "industry",
              "Academia" = "academia",
              "Community" = "community"
            ),
            selected = c("technologies", "industry"),
            inline=TRUE
          ),
          uiOutput("dynamic_plot"),
          title="Career timeline"
        ),
        box(
          uiOutput("text_panel")
        )
      )
    )
  ),
  tags$footer(HTML("Developed by <a href='https://github.com/agosiewska'>@agosiewska</a>"), 
              align = "right", 
              class="footer")
)