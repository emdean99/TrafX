# This script does the weather_script duties but it does them for daily totals
# This script will download all current data for a specific tracker 
# Location, detect the data range, download the data from the range 
# From Visual Crossing and then export a set of graphs comparing the
# Data range

# This data pulls from the working directory, make sure that your CSV is
# Named right and in the proper working directory

##############################################################
#-------------------------------------------------------------


# First The Data will import the data into the working environment from 
# the tracker

##############################################################
#-------------------------------------------------------------


# Load Libraries
library(tidyselect)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(stringr)
# color packages
library(viridis)


# Get the name of the tracker
# This will be the filename you want to import

tracker_name <- "HBDIR"

# Get the file type

data_type <- ".csv"

# Combine for file name

file_name <- paste(tracker_name, data_type, sep = "")

# Read the CV data and assign it to a variable

count_data <- read.csv2(file_name)


# Create a new variable for the newly created data frame with 3 columns for
# The three columns of data

##############################################################
#-------------------------------------------------------------


count_data1 <- data.frame(matrix(nrow = nrow(count_data), ncol = 3))


# Try using a recursive function to set each column to an individual string for 
# modification
# This will use the stringr library to use regular expressions to extract the 
# 3 different variables and set them as different columns in the recursive 
# Function


# Extract the data and set it as the first column using regular expressions from stringr


for(i in 1:nrow(count_data)) {
  count_data1[i , 1] <- str_extract_all(count_data[i , 1], '\\d\\/\\d+\\/\\d+') 
}

# Extract the hour of the day and set at the second column using regular expressions from stringr

for(i in 1:nrow(count_data)) {
  count_data1[i , 2] <- str_extract_all(count_data[i , 1], '\\d+\\:\\d+') 
}

# Extract the count data and set it as the third column using regular expressions from stringr
# This one is a little harder because to extract the comma needs to be used otherwise the \\d+
# has no way of distinguishing from other groups 
# to mitigate this I am going to first use \\,\\d+ to extract the command and number
# then I will use \\d+ on that variable to extract the number

for(i in 1:nrow(count_data)) {
  count_data1[i , 3] <- str_extract_all(str_extract_all(count_data[i , 1], '\\,\\d+'),
                                        '\\d+')
}

# make sure all count data is as numeric

count_data1[,3] <- as.numeric(count_data1[,3])

# verify it is as numeric using the first row as a test

is.numeric(count_data1[1,3])

# add an hour since start time column

count_data1 <- cbind(count_data1, 1:nrow(count_data1))

# Change the column names to represent the information that they hold

colnames(count_data1) <- c('Date', 'Hour', 'Count', 'Passed')


# last, get the start time of the first collection by hour
# This will be used to subtract that many from the start time
# in the weather data.
# This is because the weather data starts at 00:00 and we want it to not be out
# of sync at all with the start of the count data
# To do this we extract the string from the count data dataframe and 
# make sure that it is an unlisted integer for later 

start_hour <- unlist(as.integer(str_extract_all(str_extract_all(count_data1[1,2], '\\d\\d\\:'), '\\d+')))
