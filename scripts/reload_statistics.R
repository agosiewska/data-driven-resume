library(scholar)
source("./scripts/read_config.R")

if (!is.null(config[["scholar"]])) {
  
  id <- config[["scholar"]]
  citations <- get_citation_history(id)
  no_citations <- sum(citations[["cites"]])
  publications <- get_publications(id)
  no_publications <- nrow(publications)
  div()
  statistics <- list(no_citations = no_citations,
                     no_publications = no_publications,
                     gh_stars = 0,
                     pkgs_downloads=0)
  
  save(statistics, file = "./data/statistics.rda")
}