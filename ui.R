## ui.R ##
library(shinydashboard)
library(markdown)
library(dashboardthemes)
library(shinycssloaders)

source("./scripts/read_config.R")
source("./shiny_theme.R")
load("./data/statistics.rda")


tagList(
  tags$head(
    includeCSS("styles.css")
  ),
  customTheme,
  dashboardPage( title=config[["name"]],
    
    dashboardHeader(title="Resume"),
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
            label="Click on the plot to change the content of right panel.",
            choices=c(
              "Competences" = "competences",
              "Industry" = "industry",
              "Education" = "education",
              "Academia" = "academia",
              "Community" = "community"
            ),
            selected = c("competences", "industry"),
            inline=TRUE
          ),
          withSpinner(uiOutput("dynamic_plot")),
          title="Career timeline"
        ),
        box(
          withSpinner(uiOutput("text_panel")),
          class="box-details"
        )
      )
    )
  ),
)