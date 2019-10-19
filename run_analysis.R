library(dplyr)
library(tidyr)

##Load Raw Data 
TestData <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE) 
TrainData <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE) 

##Load Variable Name Information
Features_Labels <- read.table("UCI HAR Dataset/features.txt", header = FALSE) 
Activity_Labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE) 
TestActivity <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE) 
TrainActivity <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE) 
TestSubject <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE) 
TrainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE) 

##Merge Datasets
RawData <- bind_rows(TestData, TrainData)
Activity <- bind_rows(TestActivity, TrainActivity)
Subject <- bind_rows(TestSubject, TrainSubject)

##Read & Apply Descriptive Variable Names as Column Headers
names(Subject)<-c("SubjectID")
names(RawData)<-Features_Labels[, 2]
names(Activity)<-c("Activity")
rm(TestData, TrainData, TestActivity, TrainActivity, TestSubject, TrainSubject)

##Abandoned - Results in Rlang error due to duplicate column names
##Extract Mean & Standard Deviation Columns
##StdMean <- select(RawData, contains("mean", "std"))

##Extract Mean & Standard Deviation Columns
StdMean <- grep("mean|std", Features_Labels[, 2])
Extracted <- RawData[, StdMean]
names(Extracted) <- Features_Labels[StdMean, 2]
names(Extracted) <- gsub("\\(|\\)", "", names(Extracted))

##Label & Merge Descriptive Activity Labels
Activity_Labels[,2] = gsub("_", " ", tolower(as.character(Activity_Labels[,2])))
Activity[,1] <- Activity_Labels[Activity[,1],2]

##Generates Cleaned-up Data with Descriptive Variable Names
CleanedData <- cbind(Subject, Activity, Extracted)
rm(Activity, Activity_Labels, Extracted, Features_Labels, RawData, Subject)
write.table(CleanedData, "CleanedData.txt")

##Generates Summarized Data by Subject and Activity
TidyData <- aggregate(. ~SubjectID + Activity, CleanedData, mean)
TidyData <- TidyData[order(TidyData$SubjectID, TidyData$Activity),]
write.table(TidyData, "TidyData.txt")
