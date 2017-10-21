setwd("C:/Users/Deborah/Desktop/Estudo/Coursera - Data Science/3. Getting and Cleaning Data/UCI HAR Dataset")

# Project - You should create one R script called run_analysis.R that does the following.

########################## STEP 1 ############################
# 1. Merges the training and the test sets to create one data set.

# Save all file into data frames
features <- read.table("features.txt",sep=" ")
activity <- read.table("activity_labels.txt",sep=" ")

subject_test<-read.table("./test/subject_test.txt",sep=" ")
subject_train<-read.table("./train/subject_train.txt",sep=" ")

y_test<-read.table("./test/y_test.txt",sep=" ")
x_test<-read.table("./test/X_test.txt")
y_train<-read.table("./train/y_train.txt",sep=" ")
x_train<-read.table("./train/X_train.txt")

x_data <-rbind(x_test,x_train)
y_data <-rbind(y_test,y_train)
subject_data <-rbind(subject_test,subject_train)


########################## STEP 2 ############################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# Create a subset that contains features with "mean" or "std" in description
mean_std <- grepl(".*mean.*|.*std.*|.*Mean.*|.*Std.*",features[,2])
x_data_filter <- x_data[,mean_std]



########################## STEP 3 ############################
# 3. Uses descriptive activity names to name the activities in the data set
names(activity) <- c("id_activity","activity")
y_data[,1] <- activity[y_data[,1],2]


########################## STEP 4 ############################
# 4. Appropriately labels the data set with descriptive variable names.
names(features) <- c("id_feature","feature")
names(y_data) <- c("activity")
names(subject_data) <- c("subject")
names(x_data_filter) <- features$feature[mean_std]

# Consolidate all data in one data frame
data_filter<-cbind(subject_data,y_data,x_data_filter)
colnames(data_filter) <- tolower(colnames(data_filter))

data_filter$activity <- as.factor(data_filter$activity)
data_filter$subject <- as.factor(data_filter$subject)


########################## STEP 5 ############################
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject.
average_data <- aggregate(data_filter, by=list(activity = data_filter$activity, subject=data_filter$subject), mean)

# Remove columns with NA
average_data[,4] = NULL
average_data[,3] = NULL

write.table(average_data, "average_data.txt", row.name=FALSE)






