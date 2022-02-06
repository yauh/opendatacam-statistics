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
colnames(odcCounts) <- c("frameId",
  "timestamp",
  "counterId",
  "objectClass",
  "objectId",
  "bearing",
  "direction",
  "angleWithCountingLine")

# cleanup timestamp format using lubridate - check https://lubridate.tidyverse.org for docs
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

# create a subset of the data with only cars, trucks, busses, motorbikes, and bicycles
odcCountsOnlyVehicles <- subset(odcCounts,
  objectClass == "bicycle" |
  objectClass == "bus" |
  objectClass == "car" |
  objectClass == "motorbike" |
  objectClass == "truck" )

# if you need a data frame with only car observations
#odcCountsOnlyCars <- subset(odcCounts, objectClass=="car")
# if you need a data frame excluding all the cars
#odcCountsNoCars <- subset(odcCounts, objectClass!="car")


# simple first plot
countsByHour <- table(odcCountsOnlyVehicles$hourOfDay)
barplot(countsByHour,
  names.arg=rownames(countsByHour),
  xlab="Hour of Day",
  ylab="Count")

# distinguish between object classes as well
countsByClass <- with(odcCountsOnlyVehicles,table(objectClass,hourOfDay))
barplot(countsByClass,
  beside=TRUE,
  col=c("green","orange","blue","black","red"),
  xlab="Hour of Day",
  ylab="Count",
  legend.text=rownames(countsByClass),
  args.legend=list(x="topleft"))
