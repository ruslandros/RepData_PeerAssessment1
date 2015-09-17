
## Loading and preprocessing
ActivityData <- read.table("./repdata-data-activity/activity.csv", sep=",", header=TRUE)

# remove the non complete case data

cleanData <- na.omit(ActivityData)

# get the mean of steps for cleanData
# to be used as replacement for NAs in later stage

mean(cleanData$steps)

## Number of steps taken per day

library(plyr)

# calculate the number of steps for each day

sum_Steps_Daily_Data <- ddply(cleanData, c("date"), summarise,
                      sumSteps    = sum(steps))

hist(sum_Steps_Daily_Data$sumSteps, col="red", xlab="Date", main="")

mean(sum_Steps_Daily_Data$sumStep)
median(sum_Steps_Daily_Data$sumStep)
summary(sum_Steps_Daily_Data)

## Average daily pattern

avg_Interval_Data <- ddply(cleanData, c("interval"), summarise,
                      avgSteps = mean(steps))

x1 <- avg_Interval_Data$interval
y1 <- avg_Interval_Data$avgSteps

plot(x1, y1, type="l", xlab = "interval", ylab="average steps per day")

## missing values replacement

# make a copy of the original dataset

modified_ActivityData <- ActivityData

sum(is.na(modified_ActivityData))

modified_ActivityData[is.na(modified_ActivityData[,1]),1] <- mean(cleanData$steps)

sum(is.na(modified_ActivityData))

sum_Steps_Modified_Daily_Data <- ddply(modified_ActivityData, c("date"), summarise,
                      sumSteps    = sum(steps))

hist(sum_Steps_Modified_Daily_Data$sumSteps, col="red", xlab="Date", main="")

mean(sum_Steps_Modified_Daily_Data$sumStep)
median(sum_Steps_Modified_Daily_Data$sumStep)
summary(sum_Steps_Modified_Daily_Data)

## weekdays and weekends activity pattern

wkdays <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')

modified_ActivityData$date <- as.Date(modified_ActivityData$date)

# create factor variable "day"
modified_ActivityData$day <- factor((weekdays(modified_ActivityData$date) %in% wkdays), 
                   levels=c(FALSE, TRUE), labels=c('weekend', 'weekday')) 

str(modified_ActivityData)

summary_data <- ddply(modified_ActivityData, c("interval", "day"), summarise,
                      avg    = mean(steps))

library(ggplot2)
#geom=c("line", "smooth")

qplot(interval, avg, data=summary_data, facets=.~day, geom=c("line"),
      method="lm", xlab="Interval", ylab="Avg steps", 
      main="interval vs avg steps")
                   