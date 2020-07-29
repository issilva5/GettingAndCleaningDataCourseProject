library(dplyr)

dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
rawData <- "Dataset.zip"

# Check if the zipped dataset exists, if doesn't downloads it
if(!file.exists(rawData)) download.file(dataUrl, rawData)

# Unzip the dataset, and save the extracted data in dataset directory
if (!file.exists("UCI HAR Dataset")) unzip(rawData)

# Reading the data
features <- read.table("UCI HAR Dataset/features.txt")[, 2]
Xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)

Xtest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)

names(Xtrain) <- features
names(Xtest) <- features
toExtract <- sort(c(grep("(mean)", names(Xtrain)), grep("(std)", names(Xtrain))))

# Extracting only the measurements on the mean and standard deviation for each measurement
Xtrain <- Xtrain[, toExtract]
Xtest <- Xtest[, toExtract]

# Merging the train and test data
X <- rbind(Xtrain, Xtest)
y <- rbind(ytrain, ytest)
subject <- rbind(subjectTrain, subjectTest)
names(y) <- c("code")
names(subject) <- c("subject")

# Setting the activity to a descriptive name
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activities) <- c("code", "label")
y <- y %>% mutate(activityLabel = activities$label[code]) %>% select(activityLabel)

# Merging features (X), target (y) and subject data
data <- cbind(X, y, subject)

# Setting descreptive names for the columns
names(data) <- sub("^t", "time", names(data))
names(data) <- sub("^f", "frequency", names(data))
names(data) <- sub("(mean)", "Mean", names(data))
names(data) <- sub("(std)", "Std", names(data))
names(data) <- gsub("-", "", names(data))
names(data) <- gsub("\\(", "", names(data))
names(data) <- gsub("\\)", "", names(data))
data$subject <- as.factor(data$subject)

# Creating a tidy_data with the average of each variable for each activity and each subject.
tidyData <- data %>% group_by(subject, activityLabel) %>% summarise_all(mean)
write.table(tidyData, "tidy_dataset.txt", row.names = FALSE, quote = FALSE)
