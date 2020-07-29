# Getting and Cleaning Data Course Project

## Files

This repository contains the following files:

1. run_analysis.R - the R script that download and process the data
2. tidy_dataset.txt - the data generate by the script, containing a tidy_data with the average of each variable in the dataset
3. codebook.md - the codebook describing the dataset and the modifications performed

## The run_analysis.R script

1. Checks if the dataset is available locally, if it isn't, downloads and unzips it;
2. Reads the train and test data;
3. Extracts only the measurements on the mean and standard deviation for each measurement;
4. Merges train and test data;
5. Sets descriptive names to the activity feature;
6. Merges the features (X), target (y) and subject data
7. Sets descreptive names for the features
8. Creates the tidy_dataset.txt, containing a tidy_data with the average of each variable in the dataset

