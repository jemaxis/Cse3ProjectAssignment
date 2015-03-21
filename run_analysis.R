# You should create one R script called run_analysis.R that does the following. 
# 1.Merges the training and the test sets to create one data set. 
# 2.Extracts only the measurements on the mean and standard deviation 
# for each measurement.
# 3.Uses descriptive activity names to name the activities in the data set. 
# 4.Appropriately labels the data set with descriptive variable names. 
# 5.From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

setwd("C:\\Rassignment\\Cse3Project\\UCI HAR Dataset")

##== Part 1: Merge training and test data sets into one. ==== ##

# -- TO obtain training activity --
# -- Get Training Activity 
df_train_activity <-read.delim(".\\train\\Y_train.txt",header=F)
# str(df_train_activity)
# head(df_train_activity)
# tail(df_train_activity)
# as.character(df_train_activity)
# grep("\n",activity.train.labelled$V2)

#-- Get Train subjects
df_train_subjects <- read.delim(".\\train\\subject_train.txt",header=F)
# dim(df_train_subjects)
# head(df_train_subjects)

# GET training data set.
##====Unable to read fixed width file for all 561 variables due to limitation of
#memory. Need to change buffersize to 200 to cope with the load. =====
# df_train_set <- read.fwf(file=".\\train\\X_train.txt",widths=rep(16,561),header=F,buffersize=200)
df_train_set <- read.table(file=".\\train\\X_train.txt",header=F) ##More efficient way
dim(df_train_set)
names(df_train_set)

#Complete training data set by adding activity subjects
overall.training.data <- cbind(df_train_set,df_train_activity,df_train_subjects)

#=== Overall training data set assembled

# -- Get test activity -- 
df_test_activity <-read.delim(".\\test\\Y_test.txt",header=F)
dim(df_test_activity)
str(df_test_activity)

# -- Get test subjects --
df_test_subjects <- read.delim(".\\test\\subject_test.txt",header=F)
dim(df_test_subjects)
str(df_test_subjects)

# -- Get test measurements data set --
# df_test_set <- read.fwf(file=".\\test\\X_test.txt",widths=rep(16,561),header=F, buffersize = 250)
df_test_set <- read.table(file=".\\test\\X_test.txt",header=F)
dim(df_test_set) 
str(df_test_set)

# -- Combine all parts of test data
overall.test.data <- cbind(df_test_set,df_test_activity,df_test_subjects)
dim(overall.test.data)
str(overall.test.data)

# -- Combine both test and train data
# colnames(overall.training.data)
# colnames(overall.test.data)
overall.data <- rbind(overall.test.data,overall.training.data)
# dim(overall.data)

## === Part 1 Completed =========  
# "overall.training.data" contains all test and train data sets.
## =====================

# Part 2: =============
# Extracts only the measurements on the mean and standard deviation 
# for each measurement. 
# =====================

# -- Obtain list of activity features --
df_features <- read.table("features.txt",header=F) # 561 feature variables
# str(df_features)
# tail(df_features,n=20)
features.label <- df_features$V2
# str(features.label)
# head(features.label)
# tail(features.label)

# -- Identify fields with the mean and standard measurements --
# -- To identify feature variables with char "-mean(" or "-std(" --
features.mean.std.indices <- grep("-mean\\(|-std\\(",features.label)
# length(grep("-mean\\(|-std\\(",features.label))

# -- To also include columns for activity type and subject (cols 562,563)
overall.data.mean.std <- overall.data[,c(features.mean.std.indices,562,563)] 
# dim(overall.data.mean.std)
# head(overall.data.mean.std,n=1)
# tail(overall.data.mean.std,n=1)

# === Part 2 completed: 
# "overall.data.mean.std" contains only measurements of
# mean and std for each measurement.
# ==== 

# === Part 3 & 4: ========
# Use descriptive activity names to name the activities in the data set. 
# ====================

# --- Obtain activity labels ---
activity_labels <- read.table("activity_labels.txt",header=F)
head(activity_labels)
str(activity_labels)
names(activity_labels)[1]

#-- Apply measurement labels on combined datat set --
# --To obtain training variables --
mean.std.labels <- as.character(features.label[features.mean.std.indices])
names(overall.data.mean.std)[1:66] <- mean.std.labels
# names(overall.data.mean.std)

#-- Apply meaningful labels to last 2 columns representing activity and subjects
names(overall.data.mean.std)[c(67,68)] <- c("activity","subject.ID")
# names(overall.data.mean.std)
# dim(overall.data.mean.std)
# names(overall.data.mean.std)
# factor(overall.data.mean.std$activity)
# factor(overall.data.mean.std$subject.ID)
# head(overall.data.mean.std,n=1)

grep("activity",names(overall.data.mean.std))

#-- Update activity ids with actual activity description
data.label <- merge(overall.data.mean.std,activity_labels,by.x=names(overall.data.mean.std)[67],by.y=names(activity_labels)[1], )
# dim(data.label)
# names(data.label)
# head(data.label,n=1)
#-- To remove unrequired activity id and to rename activity description column
overall.data.label <- data.label[c(2:69)]
# dim(overall.data.label)
# names(overall.data.label)
names(overall.data.label)[68] <- "activity"
# str(overall.data.label[68])
# names(overall.data.label)
# head(overall.data.label,n=1)

##=== Completed Part 3 and 4 ==========

##=== Part 5: =======
# create a second, independent tidy data set 
# with the average of each variable for each activity and each subject
# =======================


# factivity <- factor(overall.data.label$activity)
# fsubjectID <- factor(overall.data.label$subject.ID)
# results<-aggregate(x=overall.data.label,by=list(group.subjectID=fsubjectID,group.activity=factivity),FUN=numcolwise(mean),na.rm=T)
# dim(results)
# names(results)
# final.results <- results[1:68]
# final.results.ordered <- final.results[order(final.results$group.subjectID),]

# -- Better way to do it --
library('plyr')
final.results <- ddply(overall.data.label, .(subject.ID,activity),numcolwise(mean))
dim(final.results)
names(final.results)
final.results.ordered <- final.results[order(final.results$subject.ID),]
# ==== Part 5 Completed =========

# === Output the result ====
write.table(final.results.ordered,"Cse3ProjWorkResult.txt",row.name=F)