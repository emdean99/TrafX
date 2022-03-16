# This script will download all current data for a specific tracker 
# Location, detect the data range, download the data from the range 
# From Visual Crossing and then export a set of graphs comparing the
# Data range

# This data pulls from the documents folder, make sure that your CSV is
#Named right and in the documents folder
#-------------------------------------------------------------


# First The Data will import the data into the working environment from 
# the tracker
#-------------------------------------------------------------


# Load Libraries
library(tidyselect)
library(ggplot2)


# Get the name of the tracker

tracker_name <- "HBDIR"

# Get the file type

data_type <- ".csv"

# Combine for file name

file_name <- paste(tracker_name, data_type, sep = "")

# Read the CV data and assign it to a variable

count_data <- read.csv2(file_name)

# Get the times at which the data was collected
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

