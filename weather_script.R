# This script will download all current data for a specific tracker 
# Location, detect the data range, download the data from the range 
# From Visual Crossing and then export a set of graphs comparing the
# Data range

# This data pulls from the documents folder, make sure that your CSV is
# Named right and in the documents folder

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

# make sure all count data is as numeric

count_data1[,3] <- as.numeric(count_data1[,3])

# verify it is as numeric using the first row as a test

is.numeric(count_data1[1,3])

# add an hour since start time column

count_data1 <- cbind(count_data1, 1:nrow(count_data1))

#Change the column names to represent the information that they hold

colnames(count_data1) <- c('Date', 'Hour', 'Count', 'Passed')

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
##############################################################
#-------------------------------------------------------------


# Download the data from visual crossing weather. The date and time gotten above
# can be used to select a location and time frame from data

weather <- read.csv('https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/montpelier%2520vermont/2021-03-28/2021-04-12?include=hours&key=NEVVZ6BDLFDNDBMTUR4Y3RA3S&options=preview&contentType=csv')

# When doing this it is important to first copy and paste the data into the web 
# Browser. I am not sure exactly why, maybe it makes the webpage for you to go
# to at a later date


# Pull out Important Information from the massive data frame for usage
##############################################################
#-------------------------------------------------------------

# First pull out temperature data using a for loop and set it as its own DF 

temp_data <- data.frame(1:nrow(weather), weather[,3])

# Change the names to be easily graphable

colnames(temp_data) <- c('Passed', 'Temp')


# Graph the Data on the same table
##############################################################
#-------------------------------------------------------------

# Create the count graph

count_graph <- ggplot(data = count_data1,
       mapping = aes(x = Passed, y = Count)) + 
         geom_point() + geom_line() 

# Create the temp graph over time graph

temp_graph <- ggplot(data = temp_data,
                     mapping = aes(x= Passed, y = Temp)) + geom_line() + geom_point()

# Create the complete graph

temp_count_graph <- ggplot(data = NULL) + 
  geom_line(data = count_data1, mapping = aes(x = Passed, y = Count)) + 
  geom_line(data = temp_data, mapping = aes(x = Passed, y = Temp))

# Print Graphs
##############################################################
#-------------------------------------------------------------


# Print Count
print(count_graph)

# Print Temp
print(temp_graph)

# Print Combined
print(temp_count_graph)
