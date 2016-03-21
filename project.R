#Load the datasets

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

test <- read.table("UCI HAR Dataset/test/X_test.txt")
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Merges the training and the test sets to create one data set

train3 <- cbind(trainActivities, trainSubjects, train)
test3 <- cbind(testActivities, testSubjects, test)
train_test <- rbind(train3, test3)

#Uses descriptive activity names to name the activities in the data set

features[,2] <- as.character(features[,2])
activityLabels[,2] <- as.character(activityLabels[,2])
activityLabels <- factor(train_test[,1], labels = activityLabels[,2])
train_test[,1] <- activityLabels

#Appropriately labels the data set with descriptive variable names

colnm <- c("activity","subject",features[,2])
colnames(train_test) <- colnm

#Extracts only the measurements on the mean and standard deviation for each measurement

selectedcol <- grep(".*mean.*|.*std.*", colnm)
selectedtable <- train_test[,c(1,2,selectedcol)]

#creates a data set with the average of each variable for each activity and each subject
library(reshape2)
summary <- melt(selectedtable, id = c("subject","activity"))
summarymn <- dcast(summary, subject + activity ~ variable, mean)

write.table(summarymn, "tidy.txt", row.names = FALSE, quote = FALSE)




