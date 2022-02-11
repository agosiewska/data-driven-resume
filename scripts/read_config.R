library(yaml)
library(dplyr)
library(shiny)

config <- read_yaml("config.yaml")
load("./data/statistics.rda")

elements <- names(config)
show_element <-lapply(elements, function(element){
  if (! is.null(element)) TRUE else  FALSE
}) %>% 
  setNames(paste(elements, sep=""))
show_element[["data_aquired"]] <- TRUE

create_stat_div <- function(sm, title, link, favicon, statistics){
  stat_div <- if (!is.null(config[["social_media"]][[sm]])){
    sm_stats_html <- if(!is.null(statistics[[sm]])){
      sm_stats <- names(statistics[[sm]])
      
      sapply(sm_stats, function(x){
        paste(
          br(), 
          span(
            paste0(x,": ", statistics[[sm]][[x]]), 
            class="social-media-stats"
          )
        )
      }) %>%
        sapply(paste, collapse = "")
    } else {
      NULL
    }
    div(a(href=paste0(link, config[["social_media"]][[sm]]), 
          class=favicon),
        span(
          a(title, href=paste0(link, config[["social_media"]][[sm]])), 
          class="social-media-login"
        ),
        HTML(sm_stats_html)
    )
  } else {
    NULL
  }
  stat_div
} 

linkedin <- create_stat_div(
  sm = "linkedin", 
  title = config[["social_media"]][["linkedin"]],
  link = "https://www.linkedin.com/in/", 
  favicon = "fa fa-linkedin", 
  statistics = statistics
)
twitter <- create_stat_div(
  sm = "twitter", 
  title = config[["social_media"]][["twitter"]],
  link = "https://twitter.com/", 
  favicon = "fab fa-twitter", 
  statistics = statistics
)
github <- create_stat_div(
  sm = "github", 
  title = config[["social_media"]][["github"]],
  link = "https://github.com/", 
  favicon = "fa fa-github", 
  statistics = statistics
)
scholar <- create_stat_div(
  sm = "scholar", 
  title = "Google scholar",
  link = "https://scholar.google.pl/citations?user=", 
  favicon = "fa fa-graduation-cap", 
  statistics = statistics
)
cran_packages <- create_stat_div(
  sm = "cran_packages",
  title = "CRAN packages",
  link = "#", 
  favicon = "fab fa-r-project", 
  statistics = statistics
)

fork_info <- tags$a()
if (!is.null(config[["fork_info"]]) && config[["fork_info"]]) {
  fork_info <- tags$a(href="https://github.com/agosiewska/data-driven-resume", HTML("<i class='fab fa-github'></i> Fork on GitHub"))
} 

ui_element <- list(
  "photo" = div(
    img(src=config[["photo"]],  width="35%"), 
    class="sidebar-name"
  ),
  "name" = div(
    h3(config[["name"]], class="sidebar-name"), 
    class="sidebar-name",
  ),
  "social_media" = div(
    linkedin, twitter, github, scholar, cran_packages, 
    class="social-media"
  ),
  "about" = div(
    includeMarkdown(config[["about"]]), 
    class="social-media"
  ),
  "data_aquired" = div(
    p(paste("Data aquired:", statistics[["date"]])),
    class="data-aquired"
  ),
  "fork_me" = fork_info
)
