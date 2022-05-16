# This script is to compare the usage of different trails over time in the same
# image
# It will work fairly simply by asking which types of data and what order the
# Objects should be put in
# This script will have the option to create simple graphs or have the 
# Option to take graphs that were created with the weather scripts to display 

# This script will read from a CSV

##############################################################
#-------------------------------------------------------------

# Import libraries
library(ggplot2)



# Find the Names of the files (4 To start Hubbard park, NB, Bike path and State House)

# Find name of first data set and import the data, then making it a DF for the graphing
# with the proper names of columns and the columns set as days

# Set name
name1 <- 'data1.csv'
# read csv
graph_data_1 <- read.csv(name1)
# convert to DF
graph_data_1 <- as.data.frame(graph_data_1)
# add a third column with day number
for (i in 1:nrow(graph_data_1)) {
  graph_data_1[i,3] <- i
}
# add col names
colnames(graph_data_1) <- c('Day', 'Count', 'Passed')

# Find name of second data set and import the data, then making it a DF for the graphing
# with the proper names of columns and the columns set as days

# Set name
name2 <- 'data2.csv'
# read csv
graph_data_2 <- read.csv(name2)
# convert to DF
graph_data_2 <- as.data.frame(graph_data_2)
# add a third column with day number
for (i in 1:nrow(graph_data_2)) {
  graph_data_2[i,3] <- i
}
# add col names
colnames(graph_data_2) <- c('Day', 'Count', 'Passed')

# Find name of third data set and import the data, then making it a DF for the graphing
# with the proper names of columns and the columns set as days

# Set name
name3 <- 'data3.csv'
# read csv
graph_data_3 <- read.csv(name3)
# convert to DF
graph_data_3 <- as.data.frame(graph_data_3)
# add a third column with day number
for (i in 1:nrow(graph_data_3)) {
  graph_data_3[i,3] <- i
}
# add col names
colnames(graph_data_3) <- c('Day', 'Count', 'Passed')

# Find name of forth data set and import the data, then making it a DF for the graphing
# with the proper names of columns and the columns set as days

# Set name
name4 <- 'data4.csv'
# read csv
graph_data_4 <- read.csv(name4)
# convert to DF
graph_data_4 <- as.data.frame(graph_data_4)
# add a third column with day number
for (i in 1:nrow(graph_data_4)) {
  graph_data_4[i,3] <- i
}
# add col names
colnames(graph_data_4) <- c('Day', 'Count', 'Passed')

# Create the 4 different graphs

##############################################################
#-------------------------------------------------------------

# Create graph 1

graph_1 <- ggplot(data = graph_data_1, mapping = aes()) + geom_line(x = 'Count', y = 'Passed') +
  geom_point(x = 'Count', y = 'Passed')


# Create graph 2

graph_2 <- ggplot(data = graph_data_2, mapping = aes()) + geom_line(x = 'Count', y = 'Passed') +
  geom_point(x = 'Count', y = 'Passed')


# Create graph 3

graph_3 <- ggplot(data = graph_data_3, mapping = aes()) + geom_line(x = 'Count', y = 'Passed') +
  geom_point(x = 'Count', y = 'Passed')


# Create graph 4

graph_4 <- ggplot(data = graph_data_4, mapping = aes()) + geom_line(x = 'Count', y = 'Passed') +
  geom_point(x = 'Count', y = 'Passed')

# Make the graphs connect together
##############################################################
#-------------------------------------------------------------

final_graph  <- multiplot(graph_1, graph_2) 
