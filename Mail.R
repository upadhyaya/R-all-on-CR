 library(RDCOMClient)
 OutApp <- COMCreate("Outlook.Application")
 outmail = OutApp$CreateItem(0)
 outmail[["To"]] = "sridhar.upadhya@accenture.com"
 outmail[["subject"]] = "some subject"
 outmail[["body"]] <- "hello"
 outmail$Send()

 class(RemReqs)
 li <- as.list(RemReqs)
 li
 