# This script will download all current data for a specific tracker 
# Location, detect the data range, download the data from the range 
# From Visual Crossing and then export a set of graphs comparing the
# Data range

# This data pulls from the documents folder, make sure that your CSV is
#Named right and in the documents folder
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


# Get the name of the tracker

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


#Change the column names to represent the information that they hold

colnames(count_data1) <- c('Date', 'Hour', 'Count')



# Get the times at which the data was collected
##############################################################
#-------------------------------------------------------------


# Get the Start time as a variable

start_time <- count_data[1,]


# Find number of rows in the data frame to assign that variable

row_number <- nrow(count_data)

# Assign the end time as a variable

end_time <- count_data[row_number,]

# Combine both times into a single string and print

print(paste("Start time =", start_time, "End Time=", end_time, sep=" "))



# Get the weather information for that time



weather <- read.csv('https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/montpelier%2520vermont/2021-04-28/2021-05-14?include=fcst%2Cobs%2Chistfcst%2Cstats%2Chours&key=NEVVZ6BDLFDNDBMTUR4Y3RA3S&options=preview&contentType=json')

