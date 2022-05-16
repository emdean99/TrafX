# This script is to compare the usage of different trails over time in the same
# image
# It will work fairly simply by asking which types of data and what order the
# Objects should be put in
# This script will have the option to create simple graphs or have the 
# Option to take graphs that were created with the weather scripts to display 

# This script will read from a CSV

##############################################################
#-------------------------------------------------------------

# Find the Names of the files (4 To start Bike path, Hubbard park, NB and Road)

# Find name of first data set and import

name1 <- 'data1'

graph_data_1 <- read.csv(name1)

# Find name of second data set and import

name2 <- 'data2'

graph_data_2 <- read.csv(name2)

# Find name of third data set and import

name3 <- 'data3'

graph_data_3 <- read.csv(name3)

# Find name of forth data set and import

name4 <- 'data4'

graph_data_4 <- read.csv(name4)

# Create the 4 different graphs

##############################################################
#-------------------------------------------------------------

# Create graph 1

graph_1 <- ggplot2(data = graph_data_1, mapping = aes()) + geom_line(x =, y = ) +
  geom_point(x =, y = )


# Create graph 2

graph_2 <- ggplot2(data = graph_data_2, mapping = aes()) + geom_line(x =, y = ) +
  geom_point(x =, y = )



# Create graph 3

graph_3 <- ggplot2(data = graph_data_3, mapping = aes()) + geom_line(x =, y = ) +
  geom_point(x =, y = )



# Create graph 4

graph_4 <- ggplot2(data = graph_data_4, mapping = aes()) + geom_line(x =, y = ) +
  geom_point(x =, y = )

# Make the graphs connect together
##############################################################
#-------------------------------------------------------------
