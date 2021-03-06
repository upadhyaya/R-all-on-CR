
## Code to compare Migration list apps with Change ticket apps to make sure all applications 
## have changes created.. Final sheets - SAPFinal, MigrationFinal and OpenRequests

rm(list=ls())
library(readxl)
library(dplyr)
library(lubridate)

## Read Migration list file
Migration <- read_excel("C:/Users/sridhar.upadhya/Desktop/R/Migration list.xlsx")

## Filter to get open Migration requests from Migration list entries
MigrationReq <- data.frame(filter(Migration, Migration$`Migration Status` == 'Move Request' | 
                                    Migration$`Migration Status` == 'ART Move Request'))


## Pick todays date and get the month from it, to filter Mig list for production version month
date <- Sys.Date()
x <- month(date)

if (x == 1){
  z <- MigrationReq %>% filter(grepl("Jan", MigrationReq$Production.Version))
} else if (x == 2){
  z <- MigrationReq %>% filter(grepl("Feb", MigrationReq$Production.Version))
} else if (x == 3){
  z <- MigrationReq %>% filter(grepl("Mar", MigrationReq$Production.Version))
} else if (x == 4){
  z <- MigrationReq %>% filter(grepl("Apr", MigrationReq$Production.Version))
} else if (x == 5){
  z <- MigrationReq %>% filter(grepl("May", MigrationReq$Production.Version))
} else if (x == 6){
  z <- MigrationReq %>% filter(grepl("Jun", MigrationReq$Production.Version))
} else if (x == 7){
  z <- MigrationReq %>% filter(grepl("Jul", MigrationReq$Production.Version))
} else if (x == 8){
  z <- MigrationReq %>% filter(grepl("Aug", MigrationReq$Production.Version))
} else if (x == 9){
  z <- MigrationReq %>% filter(grepl("Sep", MigrationReq$Production.Version))
} else if (x == 10){
  z <- MigrationReq %>% filter(grepl("Oct", MigrationReq$Production.Version))
} else if (x == 11){
  z <- MigrationReq %>% filter(grepl("Nov", MigrationReq$Production.Version))
} else {
  z <- MigrationReq %>% filter(grepl("Dec", MigrationReq$Production.Version))
}

## Migration list sorted based on Application name, component name and version name
MigrationFinal <- data.frame(z[order(z$UCD.Application.Name, z$UCD.Component.Name, z$UCD.Version.Name),])


## Read Change request extract
SAP <- read_excel("C:/Users/sridhar.upadhya/Desktop/R/DevOps Change_Task report.xlsx")

## Select required columns 
SAP1 <- data.frame(SAP$`Change ID`, SAP$Environment, SAP$`Scheduled Start Date`, SAP$Status,
                   SAP$Submitter, SAP$`Task Id`, SAP$UCD_Application_Name, SAP$UCD_Process_Name,
                   SAP$UCD_Environment_Name, SAP$UCD_Snapshot_Name)

## Filter for Claim team members
SAP2 <- data.frame(filter(SAP1, SAP1$SAP.Submitter == 'oses_prod'  |
                            SAP1$SAP.Submitter == 'ppushpam'  | SAP1$SAP.Submitter == 'araichur' |
                            SAP1$SAP.Submitter == 'rdogra' ))

## Filter for Open requests
SAP3 <- data.frame(filter(SAP2, SAP2$SAP.Status != 'Closed' & SAP2$SAP.Status != 'Completed' & SAP2$SAP.Status != 'Cancelled' ))

SAP4 <- data.frame(SAP3[rowSums(is.na(SAP3)) == 0,])  # Eliminate blank application names

SAPFinal <- SAP3 %>% filter(grepl("CM_", SAP.UCD_Application_Name)) # Pick Claim apps which starts from CM_
#Issue - Adhoc tasks and ITOC requests are not coming up

## Set of open Change requests (Issue - User oses_prod is being used by other teams hence we are getting other open requests also)
OpenRequests <- data.frame(unique(SAP3[,1:5]))

