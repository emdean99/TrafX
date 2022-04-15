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

tracker_name <- "HBDIRD2"

# Get the file type

data_type <- ".csv"

# Combine for file name

file_name <- paste(tracker_name, data_type, sep = "")

# Read the CV data and assign it to a variable

count_dataD <- read.csv2(file_name)


# Create a new variable for the newly created data frame with 2 columns for
# The three columns of data

##############################################################
#-------------------------------------------------------------


count_dataD1 <- data.frame(matrix(nrow = nrow(count_dataD), ncol = 2))


# Try using a recursive function to set each column to an individual string for 
# modification
# This will use the stringr library to use regular expressions to extract the 
# 3 different variables and set them as different columns in the recursive 
# Function


# Extract the data and set it as the first column using regular expressions from stringr


for(i in 1:nrow(count_dataD)) {
  count_dataD1[i , 1] <- str_extract_all(count_dataD[i , 1], '\\d+\\-\\d+\\-\\d+') 
}


# Extract the count data and set it as the third column using regular expressions from stringr
# This one is a little harder because to extract the comma needs to be used otherwise the \\d+
# has no way of distinguishing from other groups 
# to mitigate this I am going to first use \\,\\d+ to extract the command and number
# then I will use \\d+ on that variable to extract the number

for(i in 1:nrow(count_dataD)) {
  count_dataD1[i , 2] <- str_extract_all(str_extract_all(count_dataD[i , 1], '\\,\\d+'),
                                        '\\d+')
}

# make sure all count data is as numeric

count_dataD1[,2] <- as.numeric(count_dataD1[,2])

# verify it is as numeric using the first row as a test

is.numeric(count_dataD1[1,2])

# add an hour since start time column

count_dataD1 <- cbind(count_dataD1, 1:nrow(count_dataD1))

# Change the column names to represent the information that they hold

colnames(count_dataD1) <- c('Date', 'Count', 'Passed')


# Import the weather data and get it in usable forms
##############################################################
#-------------------------------------------------------------

# import the main weather table csv
weatherD <- read.csv('https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/retrievebulkdataset?&key=NEVVZ6BDLFDNDBMTUR4Y3RA3S&taskId=5f7e951c394f26d126e4ea00373ab151&zip=false')

# collect the average temp data, precip and condition
# into a data frame and set colnames

releventD <- data.frame(1:nrow(weatherD), weatherD[,5], weatherD[,11], weatherD[,30])

colnames(releventD) <- c('Passed', 'Temp', 'Precip', 'Condition')

# Make the graphs
##############################################################
#-------------------------------------------------------------

# Make graph of count and temp

count_final <- ggplot(data= NULL, mapping = aes()) +
  geom_line(data = count_dataD1, mapping = aes(x = Passed, y = Count)) + 
  geom_line(data = releventD, mapping = aes(x= Passed, y = Temp)) +
  geom_point(data = releventD, mapping = aes(x= Passed, y = Temp, size = Precip, color = Condition)) +
  labs(x = 'Days', y = 'Count/AverageTemp', title = 'Days Passed Vs Trail usage and Conditions') +
  theme_bw()




# Print the Graphs
##############################################################
#-------------------------------------------------------------

print(count_final)
