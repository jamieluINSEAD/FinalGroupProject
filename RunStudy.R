
# Project Name: DASHBOARD FOR WEB ANALYTICS INSIGHTS:

rm(list = ls( ))

######################################################################

# THESE ARE THE PROJECT PARAMETERS NEEDED TO GENERATE THE REPORT

# When running the case on a local computer, modify this in case you saved the files in a different directory 
# set local directory in R to folder with the following downloaded files (server.R, ui.R, data, doc and my_app folders)


################################################
# Now run (source) everything below this line

#clears current working enviroment.
rm(list = ls( ))

#this loads the R packages neeeded

install.packages("shiny")
install.packages("googlevis")
install.packages("devtools")

library(shiny)
library(googleVis)
library(devtools)


# this loads the data files: DO NOT EDIT THIS LINE

bubble_data=read.csv("data/R_Data_Bubble.csv", header = T, sep = ",")
country_data=read.csv("data/R_Data_Country.csv", header = T, sep = ",")
table_data=read.csv("data/R_Data_Table.csv", header = T, sep = ",")


 # this reconstructs the data files to develop the charts
#Reconstruct - VISITS
visits<-head(bubble_data,-1)
colnames(visits)<- tolower(colnames(visits))
str(visits)
colnames(visits)<- c("medium", "deviceCategory", "sessions", "viewspersession", "revenuepertransaction" )
visits$sessions <- as.numeric(visits$sessions)
visits$viewspersession <- as.numeric(visits$viewspersession)
visits$revenuepertransaction <- as.numeric(visits$revenuepertransaction)



#Reconstruct - GeoMap

countries<-head(country_data,-1)
colnames(countries)<- c("deviceCategory", "country","ga.users", "users")
countries$users <- as.numeric(as.character(countries$users))

#Reconstruct - TABLE
tables<-head(table_data,-1)
colnames(tables)<- tolower(colnames(tables))
str(tables)
colnames(tables)<- c("Region", "Users", "Percent")
tables$Users <- as.numeric(tables$Users)
tables$Percent <- as.numeric(tables$Percent)

  
# now run the app
runApp("my_app")  