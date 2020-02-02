#!/usr/local/bin/Rscript

setwd("~/Documents/unofficial/gov_spending/data/2020-01-31/FY2020_All_Assistance_Full_20200110/")
curFiles <- "FY2020_All_Assistance_Full_20200111_4.csv"
#curFiles <- file.path("cur_files", list.files("cur_files/"))
yearData <- sub("_All.*", "", basename(curFiles))[1]

allFunding <- list()
for(i in seq_along(curFiles)) {
	
	curFile <- read.csv(curFiles[i])
	
	## agencies donating the money
	## awarding_agency_name
	head(curFile)
	
	## money money money
	## total_funding_amount
	
	agencySpending <- curFile[,c("awarding_agency_name","total_funding_amount")]
	
	agencySpending$total_funding_amount <-  as.numeric(agencySpending$total_funding_amount)
	
	moneyPerAgency <- lapply(split(agencySpending, 
	f = agencySpending$awarding_agency_name), function(x) {
		sum(x$total_funding_amount)
	})
	
	output <- unlist(moneyPerAgency)
	allFunding[[i]] <- data.frame(names(output), output)

	rm(curFile)
	
}
allFunding <- Reduce(f = rbind, x = allFunding)

allFunding <- lapply(split(allFunding, 
                               f = allFunding$names.output.), function(x) {
                                   sum(x$output)
                               })

allFunding <- Reduce(f = rbind, x = allFunding)

write.csv(allFunding, file = paste0(yearData, ".csv"), row.names = F)

