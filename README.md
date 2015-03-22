# Cse3ProjectAssignment
=========================================================
Data Scientist Course 3 Data Cleaning Project Assignment
=========================================================

This assignment is based on the data collected through a previous experiment known as Human Activity Recognition Using Smartphones Dataset.  The experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 

For each record it is provided:
======================================
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.
- A 66-feature vector with mean and standard deviation information derived.
 
In this assignment, an R script was written to combine the train and test data sets.  This is followed by tidying the data and analysing the average of the mean and standard deviation of the measurements collected from each volunteer (now known as a subject) for each activity they carried out.

The following describes the steps of tidying the data:

1.  Read train data sets and assemble the measurements taken, participants and activities into a train dataframe. The measurements data has 561 columns corresponding to the total number of measurements shared in the feature.txt file. Both the participants and activities data has a column of data each. Putting all the data together will result a dataframe of 563 columns.  The first 561 columns correspond to the measurements data while the 562nd column represents the activity type and the 563rd column represents the subject.

2.  As described in the previous step, to apply the same treatment to the test data sets. Putting all the data together will result a dataframe of 563 columns. The first 561 columns correspond to the measurements data while the 562nd column represents the activity type and the 563rd column represents the subject.

3.  Combine both the test and train data sets into a single dataframe.  This dataframe is known as the overall dataframe set and named "overall.data".

4.  Read the features.txt data to analyse the types of measurements that were taken and to identify those with.  Filter out only the mean and standard deviation of each measurement captured and store the indices returned in a vector known as "features.mean.std.indices". This vector of indices is then used to extract the required mean and standard measurements by subsetting from the overall data set. In addition, the columns for both the activity and subject are also extracted. The subsequent dataframe created is known as "overall.data.mean.std".

5.  Based on the "features.mean.std.indices" vector in the previous step, to extract only the related measurements from the features dataframe created in the previous step known as "features.label". The result is a vector of character, "mean.std.labels", of the features required for the mean and standard deviation. To make the variables readable:
- remove the "()"
- replace "std" with "standard.deviation"
- replace "-" with "."
- replace "Mag" with "Magnitude"
- replace first "f" in each measurement with "frequency"
- replace first "t" in each measurement with "time"

Apply the "mean.std.labels" to provide descriptive column names to the "overall.data.mean.std" dataframe.

6.  Read the activity_labels.txt to construct a dataframe of 2 columns. The first column contains activity ID while second activity description. This activity_labels dataframe is merged with the "overall.data.mean.std" dataframe to obtain descriptive activity data. This completes the process of tidying the data set provided for both train and test sets.

7.  To create a second independent tidy data set from the combined data set, the data sets were grouped by each subject and activity with the corresponding measurements averaged. The resultant dataframe was ordered by subject and written into a file called "Cse3ProjWorkResult.txt". 
