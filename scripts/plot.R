library(tidyverse)
library(lubridate)

setwd("/Users/stephan/Documents/code/opendatacam-statistics/input")

data <-
  "odcCountsRoadUsers.csv" %>%
  read_csv(col_names = FALSE) %>%
  transmute(
    frameId = X1,
    objectClass = X4,
    time = X2
  )

data

odcRoadUsersAggregated <-
  data %>%
  mutate(
    weekday = wday(time, label = TRUE),
    hour = hour(time),
    date = date(time)
  ) %>%
  count(weekday, date, hour) %>%
  # average e.g over all mondays
  group_by(weekday, hour) %>%
  summarise(n = mean(n))

odcRoadUsersAggregated


odcRoadUsersAggregated %>%
  ggplot(aes(hour, n)) +
  geom_col() +
  facet_wrap(~weekday)
