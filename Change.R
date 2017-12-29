rm(list=ls())
library(readxl)
SAP_BO <- read_excel("C:/Users/sridhar.upadhya/Desktop/R/SAP BO.xlsx")
View(SAP_BO)

A <- data.frame(SAP_BO)
library(dplyr)
B <- data.frame(A$Change.ID, A$Coordinator, A$Environment, A$Req.date, A$Status)
C <- filter(B,B$A.Status != 'Completed' & B$A.Status != 'Cancelled' & B$A.Req.date == 1)
View(C)
Final <- unique(C[,1:5])
View(Final)

