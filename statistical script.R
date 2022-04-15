# This script will run an anova on the weather data with the count data for 
# hourly and also daily values (wondering if night might be problem)
##############################################################
#-------------------------------------------------------------

# First, Get the count data and the weather data in the same DF

# Get the name of the tracker
# This will be the filename you want to import

tracker_name <- "HBDIRD2"

# Get the file type

data_type <- ".csv"

# Combine for file name

file_name <- paste(tracker_name, data_type, sep = "")

# Read the CV data and assign it to a variable

count_dataA <- read.csv2(file_name)


# Create a new variable for the newly created data frame with 2 columns for
# The three columns of data

##############################################################
#-------------------------------------------------------------


count_dataA1 <- data.frame(matrix(nrow = nrow(count_dataA), ncol = 2))


# Try using a recursive function to set each column to an individual string for 
# modification
# This will use the stringr library to use regular expressions to extract the 
# 3 different variables and set them as different columns in the recursive 
# Function


# Extract the data and set it as the first column using regular expressions from stringr


for(i in 1:nrow(count_dataA)) {
  count_dataA1[i , 1] <- str_extract_all(count_dataA[i , 1], '\\d+\\-\\d+\\-\\d+') 
}


# Extract the count data and set it as the third column using regular expressions from stringr
# This one is a little harder because to extract the comma needs to be used otherwise the \\d+
# has no way of distinguishing from other groups 
# to mitigate this I am going to first use \\,\\d+ to extract the command and number
# then I will use \\d+ on that variable to extract the number

for(i in 1:nrow(count_dataA)) {
  count_dataA1[i , 2] <- str_extract_all(str_extract_all(count_dataA[i , 1], '\\,\\d+'),
                                         '\\d+')
}

# make sure all count data is as numeric

count_dataA1[,2] <- as.numeric(count_dataA1[,2])

# verify it is as numeric using the first row as a test

is.numeric(count_dataA1[1,2])

# add an hour since start time column

count_dataA1 <- cbind(count_dataA1, 1:nrow(count_dataA1))

# Change the column names to represent the information that they hold

colnames(count_dataA1) <- c('Date', 'Count', 'Passed')


# Import Weather data and create the data frame for the analysis
##############################################################
#-------------------------------------------------------------

weather = read.csv('https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/retrievebulkdataset?&key=NEVVZ6BDLFDNDBMTUR4Y3RA3S&taskId=5f7e951c394f26d126e4ea00373ab151&zip=false')

# Pull out the important information and add it to the count and add it on the count data information

stats_weather <- releventD <- data.frame(1:nrow(weatherD), count_dataA1[,2], weatherD[,5], weatherD[,11], weatherD[,30])

# Set colnames

colnames(stats_weather) <- c('Days', 'Count', 'Tempurature', 'Precipitation', 'Conditions')


# Statistical Section
##############################################################
#-------------------------------------------------------------

summary(stats_weather)

# Run a one way anova with precipitation and count


