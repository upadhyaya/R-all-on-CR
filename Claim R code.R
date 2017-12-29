rm(list=ls())
library(readxl)
library(dplyr)

## Read Migration list file
Migration <- read_excel("C:/Users/sridhar.upadhya/Desktop/R/Migration list.xlsx")

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

SAP5 <- SAP3 %>% filter(grepl("CM_", SAP.UCD_Application_Name)) # Pick Claim apps which starts from CM_
#Issue - Adhoc tasks and ITOC requests are not coming up

## Set of open Change requests (Issue - User oses_prod is being used by other teams hence we are getting other open requests also)
OpenRequests <- data.frame(unique(SAP3[,1:5]))

## Filter to get open Migration requests from Migration list entries
MigrationReq <- data.frame(filter(Migration, Migration$`Migration Status` == 'Move Request' | Migration$`Migration Status` == 'ART Move Request'))


