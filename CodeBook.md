# CodeBook

## Data Source

* Authors / Owners:
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto. 
Smartlab - Non Linear Complex Systems Laboratory 
DITEN - UniversitÃ  degli Studi di Genova, Genoa I-16145, Italy. 
activityrecognition '@' smartlab.ws 
www.smartlab.ws

* Original data: <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

* Original description of the dataset: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

## Data Set Information

**Human Activity Recognition Using Smartphones Data Set**

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

## The Data

### For each record it is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

### The dataset includes the following files:

* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 


## Work / Transformation details

### Loading test, training and subject data for X and Y axis.

The data set has been stored in the `UCI HAR Dataset/` directory.
The function `read.table` is used to load the data to the R environment, the activities and the subject of both test and training datasets.

```
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
```

### Loading activity labels and features

The activity labels and features are loaded with the function `read.table`

```
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

features <- read.table("./UCI HAR Dataset/features.txt")[,2]
```

### Assigning names to X axis datasets

The features obtained in the step before are used as names for the X axis datasets

```
names(X_test) <- features
names(X_train) <- features
```

### Extracting only the measurements on the mean and standard deviation for each measurement.

In the features dataset are extracted the position of the measurements on the mean and standard deviation using the function `grepl` , and then this positions are used to filter de X axis datasets

```
pos_meanstd <- grepl("mean|std", features)
X_test <- X_test[,pos_meanstd]
X_train <- X_train[,pos_meanstd]
```


### Assigning descriptive activity names to Y axis and subject datasets

Using the activity_label dataset are assigned the names to Y axis and subject datasets

```
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"
```

### Binding and merging Test and Train data

* Using the function `cbind` are binded the subject, y and X dataset for both test and training data.

* Using the function `rbind` are binded both Test and Training final datasets.

```
test_data <- cbind(as.data.table(subject_test), y_test, X_test)
train_data <- cbind(as.data.table(subject_train), y_train, X_train)
final_data <- rbind(test_data, train_data)
```

### Creating the tidy dataset
* First are set the labels to use as ID for the melt dataset
* Then with the function `setdiff` are found the label to use a measure.
* Using the function `melt` the dataset is summarized by the labels used as ID,
* Using the function `dcast` the dataset is created with the average of each variable for each activity and each subject.

```
labels_1 <- c("subject", "Activity_ID", "Activity_Label") 
labels_2 <- setdiff(colnames(final_data), labels_1) 
final_data_2 <- melt(final_data, id = labels_1, measure.vars = labels_2)
final_data_tidy <-dcast(final_data_2, subject + Activity_Label ~ variable, mean)
```


## Requirements to use  ```run_analysis.R``` 

* Require ```reshapre2``` and ```data.table``` libraries.
* The data set has to be stored in the `UCI HAR Dataset/` directory.



