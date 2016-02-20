library(shiny)
library(googleVis)
library(devtools)

# Source my datasets .csv from Google Analytics)
bubble_data=read.csv("data/R_Data_Bubble.csv", header = T, sep = ",")
country_data=read.csv("data/R_Data_Country.csv", header = T, sep = ",")
table_data=read.csv("data/R_Data_Table.csv", header = T, sep = ",")

#Reconstruct - VISITS
visits<-head(bubble_data,-1)
colnames(visits)<- tolower(colnames(visits))
str(visits)
colnames(visits)<- c("medium", "deviceCategory", "sessions", "viewspersession", "revenuepertransaction" )
visits$sessions <- as.numeric(visits$sessions)
visits$viewspersession <- as.numeric(visits$viewspersession)
visits$revenuepertransaction <- as.numeric(visits$revenuepertransaction)



#Reconstruct - Geo

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


# Define server logic 
shinyServer(function(input, output, sessions){
  
  output$dashboard <- renderGvis({
    
    # Make a Bubble Chart to see Medium Performance
    mediumDevice <- subset(visits, deviceCategory==input$radio)
    Bubble <- gvisBubbleChart(mediumDevice, idvar="medium", 
                              xvar="sessions", yvar="viewspersession",
                              colorvar="medium", sizevar="revenuepertransaction",
                              options=list( 
                                title="Medium Performance (Revenue = Size of the Bubble)",
                                vAxis="{title: 'Views per Sessions'}",
                                hAxis="{title: 'Sessions'}",
                                width=500, height=300,
                                legend = 'none'))
  
    
    #Column Bars
    mediumsessions <- subset(bubble_data, deviceCategory==input$radio)
    Bar = gvisColumnChart(mediumsessions, xvar = "medium", yvar = "viewspersession", options=list(title="User View Per Session",legend="none",width=500, height=300))
    
    
    #Geo Data
    countriesDevice<- subset(countries, deviceCategory==input$radio)
    Geo_Map <- gvisGeoChart(countriesDevice, "country", "users",
                      options = list(title="Users by Country",
                                     width=500, height=400,
                                     legend = 'none'))
    
    
    #Table with user percentages per Region
    usersregions <- subset(table_data, Device==input$radio)
    Table = gvisTable(usersregions,  
                      options=list(
                        page="enable",
                        title="Breakout of % of Users in Spain by Region",
                        width=500, height=400))
    
  
    D12 <- gvisMerge(Bar,Bubble, horizontal=TRUE)
    
    D34 <- gvisMerge(Geo_Map,Table, horizontal=TRUE)
    
    D1234<- gvisMerge(D12,D34, horizontal=FALSE)
    
       })
  
})
