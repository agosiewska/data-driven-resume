library(yaml)
library(dplyr)
library(shiny)
config <- read_yaml("config.yaml")

elements <- names(config)
show_element <-lapply(elements, function(element){
  if (! is.null(element)) {
    TRUE
  } else {
    FALSE
  } 
}) %>% 
  setNames(paste(elements, sep=""))

config[["about"]] <- paste("<ul style='list-style-type:none; padding-left: 0;'>",
                           paste(
                             lapply(config[["about"]], function(x){paste0("<li style='margin: 0 0 5px 0;'>", x, "</li>")}), 
                             collapse=" "),
                           "</ul>")

github <- if (!is.null(config[["social_media"]][["github"]])){
  a(href=paste0("https://github.com/", config[["social_media"]][["github"]]), 
    class="fa fa-github")  
} else {
  NULL
}

linkedin <- if (!is.null(config[["social_media"]][["linkedin"]])) {
  a(href=paste0("https://www.linkedin.com/in/", config[["social_media"]][["linkedin"]]), 
    class="fa fa-linkedin")
} else {
  NULL
}
ui_element <- list(
  "photo" = div(img(src=config[["photo"]],  width="35%"), 
                style="text-align: center;"),
  "name" = div(h3(config[["name"]]), 
               style="text-align: center;"),
  "social_media" = div(github, linkedin, style="text-align: center;"),
  "about" = div(HTML(config[["about"]]), style="margin-left:15px;")
)
