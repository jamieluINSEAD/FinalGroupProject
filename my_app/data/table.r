library(shiny)
library(googleVis)
library(devtools)

# Source my datasets .csv from Google Analytics)
project_data=read.csv("data/Worten Data.csv", header = T, sep = ",")
bubble_data=read.csv("data/Worten Data_Bubble.csv", header = T, sep = ",")
table_data=read.csv("data/Worten Data_Table.csv", header = T, sep = ",")

#Reconstruct - VISITS
visits<-head(bubble_data,-1)
colnames(visits)<- tolower(colnames(visits))
str(visits)
colnames(visits)<- c("medium", "deviceCategory", "sessions", "viewspersession", "revenuepertransaction" )
visits$sessions <- as.numeric(visits$sessions)
visits$viewspersession <- as.numeric(visits$viewspersession)
visits$revenuepertransaction <- as.numeric(visits$revenuepertransaction)

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
                                title="Medium Performance (Revenue per transaction = Size of the Bubble)",
                                vAxis="{title: 'Views per Sessions'}",
                                hAxis="{title: 'Sessions'}",
                                width=500, height=300,
                                legend = 'none'))
    
    
    #Column Bars
    mediumsessions <- subset(bubble_data, deviceCategory==input$radio)
    Bar = gvisColumnChart(mediumsessions, xvar = "medium", yvar = "viewspersession", 
                          options=list(
                          title="Views Per Session by Medium",
                          width=500, height=300,
                          legend = 'none'))
    
    D12 <- gvisMerge(Bar,Bubble, horizontal=TRUE)
    
    D12
    
    #Table with user percentages per Region
    usersregions <- subset(table_data, Device==input$radio)
    Table = gvisTable(usersregions,  
                          options=list(
                            page="enable",
                            title="Breakout of % of Users in Spain by Region",
                            width=500, height=300))
    
    
  })
  
})
