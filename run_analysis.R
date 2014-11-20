#set the working directory to the base driectory for the data
setwd("C:/Users/Elizabeth/Desktop/Getting and cleaning Data/Getting-and-Cleaning-Data-Project/UCI HAR Dataset")

# setup required packages
if (!require("plyr")) {
  install.packages("plyr")
   require("plyr")
}

#Load the data 
activityLabels <-  read.table("./activity_labels.txt")
features <-  read.table("./features.txt")    
subjectTrain <-  read.table("./train/subject_train.txt")
subjectTest <-  read.table("./test/subject_test.txt")
xTrain <- read.table("./train/X_train.txt")
xTest <-  read.table("./test/X_test.txt")
yTrain <-  read.table("./train/y_train.txt")
yTest <-  read.table("./test/y_test.txt")

#combine the data
allSubjects <- rbind(subjectTest, subjectTrain)
allX <- rbind(xTest, xTrain)
allY <- rbind(yTest, yTrain)

#adjsut the names 
names(allSubjects) <- c("subject")
names(allX) <- features$V2
names(allY) <- c("activity")

#pull out the mean and the standard deviation
allX  <- allX[,grepl("mean|std", names(allX))]

data <- cbind(allSubjects, allY, allX)
data$activity <- factor(data$activity,activityLabels[[1]],activityLabels[[2]])

tidyData <- aggregate(data, by=list(data$subject, data$activity), FUN=mean)
tidyData <- subset(tidyData, select = -c(3,4) ) # drop cols "subject" and "activity"
colnames(tidyData)[1] <- "subject" # rename col 1
colnames(tidyData)[2] <- "activity" # rename col 2
tidyData <- arrange(tidyData, subject, activity)
write.table(tidyData, file="tidyDataSet.txt", row.names=FALSE)
    