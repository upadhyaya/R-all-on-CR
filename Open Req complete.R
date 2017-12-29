## Code to extract all the open Change requests from SAP BO
## Author : Sridhar Upadhya K
## Date: 26-10-2017

setwd("C:/Users/sridhar.upadhya/Desktop/R")

rm(list=ls())
library(readxl)
library(dplyr)
library(data.table)

## Read Change request extract
SAP <- read_excel("C:/Users/sridhar.upadhya/Desktop/R/DevOps Change_Task report.xlsx")

## Select required columns 
SAP1 = select(SAP, "Change ID", "Environment", "Scheduled Start Date", "Summary", 
              "Status", "Requested By - Customer Name",
              "Coordinator Org", "Impacted Department")

SAP2 = filter(SAP1, SAP1$`Coordinator Org` == "Claim IT" & 
                SAP1$`Impacted Department` == "Dev Ops" & 
                SAP1$Status != "Completed" & SAP1$Status != "Cancelled")

UniqRequests <- as.data.frame(unique(SAP2[,1:6]))

name="sridhar.upadhya"
pwd= "Dublin)*("
send.mail(from = "sridhar.upadhya@accenture.com",
          to = "sridhar.upadhya@accenture.com",
          subject = "Testing mailer app",
          body = "Hello baby, I love seeing you",
          #encoding = "iso-8859-1",
          html = TRUE, inline = FALSE, smtp = list(host.name = "smtp-mail.outlook.com", 
                                                   port=587,
                                                   user.name= name,
                                                   password= pwd, STARTTLS=TRUE),
          authenticate = FALSE, 
          send = TRUE, attach.files = NULL, debug = TRUE)

library(xtable)
print.xtable(xtable(UniqRequests),type="html", sanitize.text.function = function(x){x})

kable(UniqRequests, caption = "Test table", fixed=TRUE, align = c("l"), type="html")



