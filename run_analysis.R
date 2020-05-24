# coursera Johns Hopkins Data Science specialisation, course 3 assignment
library(readr)
library(dplyr)

## combining test and train, giving columns descriptive names, and attaching 
## subject ID to the resulting dataframe

# assuming the data is located in the original directory 

tmp <- read_table2("./UCI HAR Dataset/features.txt", col_names = FALSE)
act <- read_table2("./UCI HAR Dataset/activity_labels.txt", col_names = FALSE)

filetestX <- "./UCI HAR Dataset/test/X_test.txt"
filetrainX <-"./UCI HAR Dataset/train/X_train.txt"

Xtest <- read_table2(filetestX, col_names = FALSE)
subj <- read_table2("./UCI HAR Dataset/test/subject_test.txt", col_names = FALSE)
activity <- read_table2("./UCI HAR Dataset/test/y_test.txt", col_names = FALSE)
colnames(Xtest) <- tmp$X2
Xtest$testORtrain <- 'test'   # just in case the origin subset is required
Xtest$subject <- subj$X1
Xtest$activity <- activity$X1

Xtrain <- read_table2(filetrainX, col_names = FALSE)
subj <- read_table2("./UCI HAR Dataset/train/subject_train.txt", col_names = FALSE)
activity <- read_table2("./UCI HAR Dataset/train/y_train.txt", col_names = FALSE)
colnames(Xtrain) <- tmp$X2
Xtrain$testORtrain <- 'train'
Xtrain$subject <- subj$X1
Xtrain$activity <- activity$X1


dat <- rbind(Xtest,Xtrain)
# converting activity to factor with appropriate labels
dat$activity <- factor(dat$activity, levels=c(1,2,3,4,5,6), labels=act$X2)

## averaging over subject and activity
# Extracts only the measurements on the mean and standard deviation for each measurement
ix <- grep("*-mean()*|*-std()*|subject|activity",colnames(dat))

# grouping by subject and activity before calculating mean of all remaining columns
dat_ave <- dat[,ix] %>% group_by(activity, subject)  %>% summarize_all(mean)
