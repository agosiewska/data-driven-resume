library(yaml)
library(dplyr)
library(shiny)
config <- read_yaml("config.yaml")
load("./data/statistics.rda")

elements <- names(config)
show_element <-lapply(elements, function(element){
  if (! is.null(element)) {
    TRUE
  } else {
    FALSE
  } 
}) %>% 
  setNames(paste(elements, sep=""))

config[["about"]] <- paste(
  "<ul style='list-style-type:none; padding-left: 0;'>",
  paste(
    lapply(config[["about"]], 
           function(x){
             paste0(
               "<li style='margin: 0 0 5px 0;'>", 
               x, 
               "</li>"
             )
           }), 
    collapse=" "),
  "</ul>"
)

create_stat_div <- function(sm, title, link, favicon, statistics){
  stat_div <- if (!is.null(config[["social_media"]][[sm]])){
    sm_stats_html <- if(!is.null(statistics[[sm]])){
      sm_stats <- names(statistics[[sm]])
      
      sapply(sm_stats, function(x){
        paste(
          br(), 
          span(
            paste0(x,": ", statistics[[sm]][[x]]), 
            style="padding-left:30px;"
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
          style="padding-left: 5px;"
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
  link = "", 
  favicon = "fab fa-r-project", 
  statistics = statistics
)


ui_element <- list(
  "photo" = div(img(src=config[["photo"]],  width="35%"), 
                style="text-align: center;"),
  "name" = div(h3(config[["name"]]), 
               style="text-align: center;"),
  "social_media" = div(linkedin, twitter, github, scholar, cran_packages, style="text-align: left;margin-left:15px"),
  "about" = div(HTML(config[["about"]]), style="margin-left:15px;")
)
