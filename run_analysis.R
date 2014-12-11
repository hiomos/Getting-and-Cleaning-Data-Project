# Coded by Heverth Osorio 
# run_analysis.R
# Date: 20/12/2014
# Please put the data in your default working directory

# Create one R script called run_analysis.R that does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Loading required libraries
library("reshape2")
library("data.table") # Used to merge the data with DCAST function

# Loading test, train and subject data for X and Y axis.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Loading activity labels and activity data
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Loading and extracting the col names from features.txt
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Assinging names to X axis datasets
names(X_test) <- features
names(X_train) <- features

# Extracting only the measurements on the mean and standard deviation for each measurement.
pos_meanstd <- grepl("mean|std", features)
X_test <- X_test[,pos_meanstd]
X_train <- X_train[,pos_meanstd]

# Assingning descriptive activity names to Y axis datasets
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Binding and merging Test and Train data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)
train_data <- cbind(as.data.table(subject_train), y_train, X_train)
final_data <- rbind(test_data, train_data)

# Creating tidy dataset
labels_1 <- c("subject", "Activity_ID", "Activity_Label") # Used as ID
labels_2 <- setdiff(colnames(final_data), labels_1) # Used to indetify the data to melt
final_data_2 <- melt(final_data, id = labels_1, measure.vars = labels_2)
final_data_tidy <-dcast(final_data_2, subject + Activity_Label ~ variable, mean)

# Writting the table to txt file
write.table(final_data_tidy, file = "./tidy.txt", row.name=FALSE )