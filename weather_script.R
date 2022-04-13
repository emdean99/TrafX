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
# When doing this it is important to first copy and paste the data into the web 
# Browser. I am not sure exactly why, maybe it makes the webpage for you to go
# to at a later date
# Make sure the tempurature is proper and by hourly or daily before running

weather <- read.csv('https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/retrievebulkdataset?&key=GVED83F4SV56PXKZRE6V8Z4GJ&taskId=519c9988392756d556ef5b554ce86ad6&zip=false')

# Now that we have the data remove the hours before the trackers start time
# from the data frame
# do this using a for loop which removes the top 17 rows for every column 
# MAKE SURE TO ONLY RUN ONCE OTHERWISE IT KEEPS OFFSETTING THE DATA
# AND THE DATA NEEDS TO BE REINITIATED


for (i in (start_hour-1)) {
  weather <- weather[-c(1:(start_hour)), ]
}


# Pull out Important Information from the massive data frame for Temperature Data
##############################################################
#-------------------------------------------------------------

# First pull out temperature data using a for loop and set it as its own DF 

temp_data <- data.frame(1:nrow(weather), weather[,3])

# Change the names to be easily graph able

colnames(temp_data) <- c('Passed', 'Temp')


# Graph the Temp Data on the same table
##############################################################
#-------------------------------------------------------------

# Create the count graph

count_graph <- ggplot(data = count_data1,
       mapping = aes(x = Passed, y = Count)) + 
         geom_point() + geom_line() 

# Create the temp graph over time graph

temp_graph <- ggplot(data = temp_data,
                     mapping = aes(x= Passed, y = Temp)) + 
  geom_line() + 
  geom_point()

# Create the complete graph

temp_count_graph <- ggplot(data = NULL) + 
  geom_line(data = count_data1, mapping = aes(x = Passed, y = Count, color = 'red')) + 
  geom_line(data = temp_data, mapping = aes(x = Passed, y = Temp, color = 'blue')) +
  geom_smooth(data = count_data1, mapping = aes(x = Passed, y = Count), method = lm) +
  geom_smooth(data = temp_data, mapping = aes(x=Passed, y=Temp), method = lm) +
  labs(x = 'Hours since tracking start',
       y = 'Count/Temp',
       title = 'Trail usage Vs Montpeliers tempurature') +
  theme_bw()



# Pull out Important Information from the massive data frame for Precipitation Data
##############################################################
#-------------------------------------------------------------

# Pull out from the weather data the total precipitation

precip_data <- data.frame(1:nrow(weather), weather[,11])

colnames(precip_data) <- c('Passed', 'Precip_total')


# Create a graph for count and precip data
##############################################################
#-------------------------------------------------------------

# Create graph for precip data


precip_graph <- ggplot(data = precip_data, mapping = aes(Passed, Precip_total)) +
  geom_point() +
  geom_line()

# Create a graph combining precip and count data

precip_count_graph <- ggplot(data = NULL) + 
  geom_line(data = count_data1, mapping = aes(x = Passed, y = Count, color = 'red')) + 
  geom_line(data = precip_data, mapping = aes(x = Passed, y = Precip_total, color = 'blue')) +
  geom_smooth(data = count_data1, mapping = aes(x = Passed, y = Count), method = lm) +
  geom_smooth(data = precip_data, mapping = aes(x=Passed, y=Precip_total), method = lm) +
  labs(x = 'Hours since tracking start',
       y = 'Count/Temp',
       title = 'Trail usage Vs Montpeliers precipitation') +
  theme_bw()

# Create final graph with the most information without overloading the information
##############################################################
#-------------------------------------------------------------

# pull out conditions for color grading the points in the graph

condition_data <- data.frame(Condition = weather[,30])

# add the relevant weather data to a combined dataframe that can be used

relevent_weather <- data.frame(c(temp_data, precip_data, condition_data))


# Create a graph combining temperature, precipitation and Count data
# Show the points of trail usage, with the discrete category of conditions
# being the color of the points on either temp or 

overall_weather_graph <- ggplot(data = NULL) + 
  geom_line(data = count_data1, mapping = aes(x = Passed, y = Count, color = 'red')) + 
  geom_line(data = temp_data, mapping = aes(x = Passed, y = Temp, color = 'blue')) +
  geom_point(data = relevent_weather, mapping = aes(x = Passed, y = Temp, size = Precip_total, color = Condition)) +
  geom_smooth(data = count_data1, mapping = aes(x = Passed, y = Count), method = lm) +
  geom_smooth(data = temp_data, mapping = aes(x=Passed, y=Temp), method = lm) +
  labs(x = 'Hours since tracking start',
       y = 'Count/Temp',
       title = 'Trail usage Vs Montpeliers Weather conditions') +
  theme_bw()





# Print Graphs
##############################################################
#-------------------------------------------------------------


# Print Count
print(count_graph)

# Print Temp
print(temp_graph)

# Print Precip
print(precip_graph)

# Print Combined Precip and Count
print(precip_count_graph)

# Print Combined Temp and Count
print(temp_count_graph)

# Print Combined Temp, Precip and Count 
print(overall_weather_graph)
