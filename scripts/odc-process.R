# load prerequisite libraries
prereqs<-c("tidyverse", "plyr", "dplyr", "lubridate")
lapply(prereqs, require, character.only = TRUE)

# adjust this to point to where your data input csv files reside
setwd("/Users/stephan/Documents/code/opendatacam-statistics/input")

# read all csv files  from input/ subir into a dataframe called odcCounts
odcCounts <- ldply(list.files(), read.csv, header=FALSE)

# assign meaningful column names
colnames(odcCounts) <- c("frameId",
  "timestamp",
  "counterId",
  "objectClass",
  "objectId",
  "bearing",
  "direction",
  "angleWithCountingLine")

# split timestamp data using lubridate - check https://lubridate.tidyverse.org for docs
odcCounts <- mutate(odcCounts,
  dayOfWeek = wday(timestamp),
  date = date(timestamp),
  weekdaylong = strftime(date,'%A'),
  weekdayshort = strftime(date,'%a'),
  ymdhms = ymd_hms(timestamp),
  month = month(timestamp),
  week = week(timestamp),
  quarter = quarter(timestamp),
  hourOfDay = hour(ymdhms))

# print table which objects occured how often - be amazed
table(odcCounts['objectClass'])

# create a new dataframe limited to typical road users
odcCountsRoadUsers <- subset(odcCounts,
  objectClass == "bicycle" |
  objectClass == "bus" |
  objectClass == "car" |
  objectClass == "motorbike" |
  objectClass == "person" |
  objectClass == "truck" )

# write all csv data into single file
write.table(odcCountsRoadUsers, file = "odcCountsRoadUsers.csv",
             sep = ",", row.names = F, col.names = F)

# show distribution of road users
odcCountsRoadUsers %>%
  group_by(objectClass) %>%
  dplyr::summarise(n = n()) %>%
  mutate(Freq = n/sum(n)) %>%
  arrange(desc(Freq))
