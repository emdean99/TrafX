# This script will download all current data for a specific tracker 
# Location, detect the data range, download the data from the range 
# From Visual Crossing and then export a set of graphs comparing the
# Data range



# First The Data will import the data into the working environment from 
# the tracker


#Get the name of the tracker

tracker_name <- "HBDIR"

#Get the file type

data_type <- ".csv"

#Combine for file name

file_name <- paste(tracker_name, data_type, sep = "")

#Read the CV data and assign it to a variable

count_data <- read.csv2(file_name)
