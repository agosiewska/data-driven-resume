library(ggplot2)
library(lubridate)
library(dplyr)
library(tidyr)


timeline <- read.csv2("./data/timeline.csv") %>% 
  mutate(start = dmy(start), 
         end = as_date(ifelse(end == "Present", as_date(Sys.time()), dmy(end)))) %>% {
           rbind(filter(., type=="technologies") %>%
                   arrange(desc(start)),
                 filter(., type != "technologies") %>%
                   arrange(start))
         } %>%
  pivot_longer(col=c(start, end), names_to = "start_end", values_to = "time" ) %>% 
  mutate(name = factor(name, levels = unique(name)),
         type = factor(type, levels=c("industry", "technologies", "academia", "community")))


