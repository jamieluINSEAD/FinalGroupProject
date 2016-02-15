library(shiny)
library(googleVis)
library(devtools)

# Source my datasets .csv from Google Analytics)

work_data=read.csv("data/Worten_Data_4.csv")



#setup

visits = data.frame(work_data$Device, work_data$Pageviews,work_data$Sessions, work_data$TransRev)
colnames(visits)<- c("device", "pageviews","sessions","revenue")
str(visits)
visits$sessions <- as.numeric(visits$sessions)
visits$pageviews <- as.numeric(visits$pageviews)
visits$revenue = as.numeric(visits$revenue)

channels = data.frame(work_data$Device, work_data$Users,work_data$Sessions, work_data$TransRev)
colnames(channels)<- c("device", "users","sessions","revenue")
channels$sessions <- as.numeric(channels$sessions)




# CLEANING




# Define server logic 
shinyServer(function(input,output){
    
  output$dashboard<- renderPlot({
    
    # Make a Line Chart with primary axis for Sessions and secondary axis for Signups
    dataDevice<- data.frame(visits$device,visits$pageviews,visits$sessions, visits$revenue,input$radio)
    Line2axis <- gvisLineChart(dataDevice, "visits", c("sessions","revenue"),
                           options=list(
                             series="[{targetAxisIndex: 0},
                                 {targetAxisIndex:1}]",
                             vAxes="[{title:'Sessions'}, {title:'Signups'}]", 
                             title="Visits & Revenue",
                             width=500, height=300
                           ))
    
    # Make a Bubble Chart to see Channels Performance
        channelsDevice<- data.frame(channels$revenue, channels$sessions, channels$device)
    Bubble <- gvisBubbleChart(channelsDevice, idvar="channel", 
                            xvar="sessions", yvar="device",
                            colorvar="channel", sizevar="revenue",
                            options=list( 
                              title="Channels Performance (Revenue = Size of the Bubble)",
                              vAxis="{title: 'Users'}",
                              hAxis="{title: 'Sessions'}",
                              width=500, height=300,
                              legend = 'none'))
    
  })
  
})
