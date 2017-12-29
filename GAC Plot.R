
rm(list=ls())

library("readxl")
library("ggplot2")

GAC <- read_excel("C:/Users/sridhar.upadhya/Desktop/R/GAC sheet.xlsx")
GAC$Month <- factor(GAC$Month, levels = c("Jan", "Feb", "Mar","Apr", "May", "Jun", "Jul","Aug","Sep",
                                "Oct","Nov","Dec"))
App <- c(rep("GAC", 12), rep("Nexus", 12))

GACPlot <- ggplot(data=GAC, aes(Month, Apps))+
  geom_bar(stat = "identity", aes(fill=App), position = "dodge" )+
  xlab("Months") + ylab("Application count")+
  ggtitle("GAC v/s Nexus")
  
GACPlot


