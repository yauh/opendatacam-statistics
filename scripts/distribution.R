# if packages are not available, install once by uncommenting these lines
#install.packages("tidyverse")
#install.packages("plyr")

# plyr enables reading multple csv files as source
library(plyr)

# tidayverse allows data cleanup, specifically lubridate
library(lubridate)

# adjust this to point to where your data input csv files reside
setwd("/Users/stephan/Documents/code/opendatacam-statistics/input")

# read all csv files into the dataframe called odcCounts
odcCounts <- ldply(list.files(), read.csv, header=FALSE)

# assign meaningful column names
colnames(odcCounts) <- c("frameId", "timestamp", "counterId", "objectClass", "objectId", "bearing", "direction", "angleWithCountingLine")

# cleanup timestamp format using lubridate - check https://lubridate.tidyverse.org for docs
odcCounts <- mutate(odcCounts,
  dayOfWeek = wday(timestamp),
  ymdhms = ymd_hms(timestamp),
  month = month(timestamp),
  week = week(timestamp),
  quarter = quarter(timestamp),
  hourOfDay = hour(ymdhms))

# simple first plot
countsByHour <- table(odcCounts$hourOfDay)
barplot(countsByHour,
  names.arg=rownames(tab0),
  xlab="Day of week",
  ylab="Count")
