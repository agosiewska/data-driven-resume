library(scholar)
library(cranlogs)
library(rjson)
library(dplyr)


source("./scripts/read_config.R")

statistics <- list()

if (!is.null(config[["social_media"]][["scholar"]])) {
  
  id <- config[["social_media"]][["scholar"]]
  citations <- get_citation_history(id)
  no_citations <- sum(citations[["cites"]])
  publications <- get_publications(id)
  no_publications <- nrow(publications)
  statistics[["scholar"]] <- list(
    citations = no_citations,
    publications = no_publications
  )
}


if (!is.null(config[["social_media"]][["cran_packages"]])) {
  cran_downloads <- cran_downloads(
    packages = config[["social_media"]][["cran_packages"]],
    from = "2013-01-01" 
  )
  
  statistics[["cran_packages"]] <- list(
    packages = length(config[["social_media"]][["cran_packages"]]),
    downloads= format(sum(cran_downloads[["count"]]), big.mark = " ")
  )
  
}


get_github_stars <- function(repo){
  if (!is.na(repo)) {
    github_url <- paste0("https://api.github.com/repos/", repo)
    data <- fromJSON(file=github_url)
    github_stars <- data[["stargazers_count"]]
  } else {
    github_stars <- "-"
  }
  github_stars
}
user_stars <- function(user){
  github_url <- paste0("https://api.github.com/users/", user, "/repos")
  data <- fromJSON(file=github_url)
  sapply(data, function(x){
    if (!x[["fork"]]) {
      x[["stargazers_count"]]
    } else {
      0
    }
  }) %>%
    sum()
}

if (!is.null(config[["social_media"]][["github"]])) {
  additional_stars <- sapply(
    config[["social_media"]][["outside_github_stars"]], 
    function(x){
      Sys.sleep(abs(rnorm(1)))
      get_github_stars(x)
    }) %>%
    sum()
  user_stars <- user_stars(config[["social_media"]][["github"]])
  statistics[["github"]] <- list(
    stars = additional_stars + user_stars
  )
}

statistics[["date"]] <- Sys.time()

save(statistics, file = "./data/statistics.rda")