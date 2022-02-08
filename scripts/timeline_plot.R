library(ggplot2)
library(lubridate)
library(dplyr)
library(tidyr)
library(tools)

source("./scripts/read_config.R")

timeline <- read.csv2(config[["timeline"]]) %>% 
  mutate(start = dmy(start), 
         end = as_date(ifelse(end == "Present", as_date(Sys.time()), dmy(end)))) %>% {
           rbind(filter(., type %in% c("technologies", "community")) %>%
                   arrange(desc(start)),
                 filter(., !(type %in% c("technologies", "community"))) %>%
                   arrange(start))
         } %>%
  pivot_longer(col=c(start, end), names_to = "start_end", values_to = "time" ) %>% 
  mutate(name = factor(name, levels = unique(name)),
         type = factor(type, levels=c("technologies", "industry", "academia", "community"))) %>%
  mutate(name = factor(name, labels = gsub('(.{1,33})(\\s|$)', '\\1\n', levels(name)))) 

