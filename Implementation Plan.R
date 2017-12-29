
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

Imp <- arrange(z, z$`UCD Application Name`, desc(z$`UCD Version Name`))

Imp1 <- Imp[!duplicated(Imp$`UCD Application Name`),]

ImpPlan <- select(Imp1, "UCD Application Name", "UCD Component Name", "UCD Version Name",
                  "App Owner/Requester", "Target Environment", "Target Machine Group",
                  "Specific Location", "ITG")
View(ImpPlan)
