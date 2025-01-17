---
title: "CodeBook"
output: html_document
sub: I think the .Rmd file looks better, but this is what the class requested.
---

## Script Step-by-Step

run_analysis.R transforms the raw data into tidy and summarized data.

1. The script reads in all the necessary data, including testing, training, subject, features, and activity.
TestData - contains the data from X_test.txt
TrainData - contains the data from X_train.txt 
Features_Labels - contains the data from features.txt
Activity_Labels - contains the data from activity_labels.txt
TestActivity - contains the data from y_test.txt
TrainActivity - contains the data from y_train.txt
TestSubject - contains the data from subject_test.txt
TrainSubject - contains the data from subject_train.txt

```{r cars}
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
```

2. The script merges the data.
RawData - combines the data from TestData and TrainData
Activity - combines the data from TestActivity and TrainActivity
Subject - combines the data from TestSubject and TrainSubject

```{r cars}
##Merge Datasets
RawData <- bind_rows(TestData, TrainData)
Activity <- bind_rows(TestActivity, TrainActivity)
Subject <- bind_rows(TestSubject, TrainSubject)
```

3. The script reads and applies descriptive variable names as column headers from features.txt, 
and removes the unnecessary variables. 

```{r cars}
##Read & Apply Descriptive Variable Names as Column Headers
names(Subject)<-c("SubjectID")
names(RawData)<-Features_Labels[, 2]
names(Activity)<-c("Activity")
rm(TestData, TrainData, TestActivity, TrainActivity, TestSubject, TrainSubject)
```

4. The script extracts the columns containing mean and standard deviation measurements, 
excluding other measurements from the analysis. The activity numbers are substituted with labels 
from the activity_labels.txt and invalid characters "()" are removed from the column names.
StdMean - temp holder of the Mean and Standard Deviation in Features_Labels
Extracted - contains the subset of Mean and Standard Deviation information from RawData

```{r cars}
##Extract Mean & Standard Deviation Columns
StdMean <- grep("mean|std", Features_Labels[, 2])
Extracted <- RawData[, StdMean]
names(Extracted) <- Features_Labels[StdMean, 2]
names(Extracted) <- gsub("\\(|\\)", "", names(Extracted))

##Label & Merge Descriptive Activity Labels
Activity_Labels[,2] = gsub("_", " ", tolower(as.character(Activity_Labels[,2])))
Activity[,1] <- Activity_Labels[Activity[,1],2]
```

5. The script generates a CleanedData.txt file containing all the data from Subject, Activity, 
and the Extracted RawData, grouped by subject and activity. Then removes the unnecessary variables. 
CleanedData - contains all the data from Subject, Activity, and the Extracted RawData

```{r cars}
##Generates Cleaned-up Data with Descriptive Variable Names
CleanedData <- cbind(Subject, Activity, Extracted)
rm(Activity, Activity_Labels, Extracted, Features_Labels, RawData, Subject)
write.table(CleanedData, "CleanedData.txt")
```

6. The script generates a TidyData.txt file containing a summary of the CleanedData, 
grouped by subject and activity with the mean of every measurement column.
TidyData - contains the summarized data from CleanedData

```{r cars}
##Generates Summarized Data by Subject and Activity
TidyData <- aggregate(. ~SubjectID + Activity, CleanedData, mean)
TidyData <- TidyData[order(TidyData$SubjectID, TidyData$Activity),]
write.table(TidyData, "TidyData.txt")
```

Each line in run_analysis.R is commented. Reference the file for more information on this process.

## Column Names in CleanedData.txt and TidyData.txt

SubjectID - The id of the experiment participant.
Activity - The name of the activity that the measurements correspond to, like LAYING or WALKING.

All of the following fields represent the mean of recorded data points for the given subject and activity. 
The detailed description of the different measurement types can be found in the features_info.txt file 
included in the data zip file.

tBodyAcc_mean_X
tBodyAcc_mean_Y
tBodyAcc_mean_Z
tGravityAcc_mean_X
tGravityAcc_mean_Y
tGravityAcc_mean_Z
tBodyAccJerk_mean_X
tBodyAccJerk_mean_Y
tBodyAccJerk_mean_Z
tBodyGyro_mean_X
tBodyGyro_mean_Y
tBodyGyro_mean_Z
tBodyGyroJerk_mean_X
tBodyGyroJerk_mean_Y
tBodyGyroJerk_mean_Z
tBodyAccMag_mean
tGravityAccMag_mean
tBodyAccJerkMag_mean
tBodyGyroMag_mean
tBodyGyroJerkMag_mean
fBodyAcc_mean_X
fBodyAcc_mean_Y
fBodyAcc_mean_Z
fBodyAccJerk_mean_X
fBodyAccJerk_mean_Y
fBodyAccJerk_mean_Z
fBodyGyro_mean_X
fBodyGyro_mean_Y
fBodyGyro_mean_Z
fBodyAccMag_mean
fBodyAccJerkMag_mean
fBodyGyroMag_mean
fBodyGyroJerkMag_mean
tBodyAcc_std_X
tBodyAcc_std_Y
tBodyAcc_std_Z
tGravityAcc_std_X
tGravityAcc_std_Y
tGravityAcc_std_Z
tBodyAccJerk_std_X
tBodyAccJerk_std_Y
tBodyAccJerk_std_Z
tBodyGyro_std_X
tBodyGyro_std_Y
tBodyGyro_std_Z
tBodyGyroJerk_std_X
tBodyGyroJerk_std_Y
tBodyGyroJerk_std_Z
tBodyAccMag_std
tGravityAccMag_std
tBodyAccJerkMag_std
tBodyGyroMag_std
tBodyGyroJerkMag_std
fBodyAcc_std_X
fBodyAcc_std_Y
fBodyAcc_std_Z
fBodyAccJerk_std_X
fBodyAccJerk_std_Y
fBodyAccJerk_std_Z
fBodyGyro_std_X
fBodyGyro_std_Y
fBodyGyro_std_Z
fBodyAccMag_std
fBodyAccJerkMag_std
fBodyGyroMag_std
fBodyGyroJerkMag_std


## Additional Information

Detailed information on the experiment and the data can be found in the README.txt and features_info.txt files 
included in the experiment data zip file or find more information on the dataset homepage.
