
##Validates Change tickets with Migration list entries for the below 
##   - Status of all the open change tickets
##   - Number of Applications for a specific version matches with the number of rows in Remedy list
##   - Environment present in Migration list is 'P' then UCD Environment name should have Prod. V to have MO, D to have Perf

## Author: Sridhar Upadhya
## Date: 25-10-2017

setwd("C:/Users/sridhar.upadhya/Desktop/R")

rm(list=ls())
library(readxl)
library(xlsx)
library(dplyr)
library(data.table)
library(lubridate)

## Read Migration list file
Migration <- read_excel("C:/Users/sridhar.upadhya/Desktop/R/Migration list.xlsx")

## Pick todays date and get the month from it, to filter Mig list for production version month
date <- Sys.Date()
x <- month(date)

if (x == 1){
  z <- Migration %>% filter(grepl("Jan", Migration$`Production Version`))
} else if (x == 2){
  z <- Migration %>% filter(grepl("Feb", Migration$`Production Version`))
} else if (x == 3){
  z <- Migration %>% filter(grepl("Mar", Migration$`Production Version`))
} else if (x == 4){
  z <- Migration %>% filter(grepl("Apr", Migration$`Production Version`))
} else if (x == 5){
  z <- Migration %>% filter(grepl("May", Migration$`Production Version`))
} else if (x == 6){
  z <- Migration %>% filter(grepl("Jun", Migration$`Production Version`))
} else if (x == 7){
  z <- Migration %>% filter(grepl("Jul", Migration$`Production Version`))
} else if (x == 8){
  z <- Migration %>% filter(grepl("Aug", Migration$`Production Version`))
} else if (x == 9){
  z <- Migration %>% filter(grepl("Sep", Migration$`Production Version`))
} else if (x == 10){
  z <- Migration %>% filter(grepl("Oct", Migration$`Production Version`))
} else if (x == 11){
  z <- Migration %>% filter(grepl("Nov", Migration$`Production Version`))
} else {
  z <- Migration %>% filter(grepl("Dec", Migration$`Production Version`))
}

MigUniqApp <- unique(z$`UCD Application Name`)

## Read Change request extract
SAP <- read_excel("C:/Users/sridhar.upadhya/Desktop/R/DevOps Change_Task report.xlsx")

## Select required columns 
SAP1 = select(SAP, "Change ID", "Coordinator Org", "Change Coordinator", "Environment", 
              "Scheduled Start Date", "Summary", "Impacted Department", "Status", "Submitter",
              "Submit Date", "Requested By - Customer Name", "Product Name", "Task Id", 
              "UCD_Application_Name", "UCD_Process_Name", "UCD_Environment_Name")

SAP2 = filter(SAP1, SAP1$`Coordinator Org` == "Claim IT" & 
                    SAP1$`Impacted Department` == "Dev Ops" & 
                    SAP1$Status != "Completed" &
                    SAP1$Status != "Cancelled")

#Remove blanks and duplicates
SAPFinal <- as.data.frame(SAP2[rowSums(is.na(SAP2)) == 0,]) 
RemReq <- unique(SAPFinal$UCD_Application_Name)

#Count of applications missing change requests
MissNum <- length(MigUniqApp) - length(RemReq)

#Find missing applications
Mig <- setdiff(MigUniqApp, RemReq)
Rem <- setdiff(RemReq, MigUniqApp)
max.len = max(length(Mig), length(Rem))
x = c(Mig, rep("", max.len - length(Mig)))
y = c(Rem, rep("",max.len - length(Rem)))
MissingCR <- data.frame(x,y)
names(MissingCR) <- c("Application Missing CR", "Applications missing in Migration List")

#Write the missing rows to an excel sheet
file.remove("C:/Users/sridhar.upadhya/Desktop/R/MissingCR.xlsx")
write.xlsx(MissingCR, file = "C:/Users/sridhar.upadhya/Desktop/R/MissingCR.xlsx")

#Add the number of applications missing the CR
Miss <- data.frame("Number of applications which is missing CR", MissNum)


## Environment mapping with Migration list and Remedy

MigEnv1 <- select(z, "UCD Application Name", "Target Environment")
MigEnv <- arrange(MigEnv1, MigEnv1$`UCD Application Name`, MigEnv1$`Target Environment`)

RemReqs <- select(SAPFinal, "UCD_Application_Name", "UCD_Environment_Name")

RemEnvi <- RemReqs %>% filter(!grepl("Prod", RemReqs$UCD_Environment_Name))
names(RemEnvi) = c("Application Names", "Environment name incorrect")

#Write to an excel sheet
wb = createWorkbook()
sheet = createSheet(wb, "Missing CR")
addDataFrame(MissingCR, sheet = sheet, row.names = FALSE)
addDataFrame(Miss, sheet = sheet, startRow = (nrow(MissingCR) + 3), col.names = FALSE,
             row.names = FALSE)
sheet = createSheet(wb, "Incorrect Environment")
addDataFrame(RemEnvi, sheet = sheet, row.names = FALSE)
saveWorkbook(wb, file = "C:/Users/sridhar.upadhya/Desktop/R/MissingCR.xlsx" )
