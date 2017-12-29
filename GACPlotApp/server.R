#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library("readxl")
library("ggplot2")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  GAC <- read_excel("C:/Users/sridhar.upadhya/Desktop/R/GAC sheet.xlsx")
  GAC$Month <- factor(GAC$Month, levels = c("Jan", "Feb", "Mar","Apr", "May", "Jun",
                                            "Jul","Aug","Sep",
                                            "Oct","Nov","Dec"))
  App <- c(rep("GAC", 12), rep("Nexus", 12))
  
  output$distPlot <- renderPlot({
    
    # draw the histogram with the specified number of bins
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    ggplot(data=GAC, aes(Month, Apps))+
      geom_bar(stat = "identity", aes(fill=App), position = "dodge" )+
      xlab("Months") + ylab("Application count")+
      ggtitle("GAC v/s Nexus")
    
  })
  
})
