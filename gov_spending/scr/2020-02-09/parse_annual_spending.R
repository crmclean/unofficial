library(stringr)

treasFunds <- read.csv("data/2020-02-09/treasury_funding_since_80s.csv", stringsAsFactors = F)
treasFunds$year <- sub("-" , "", treasFunds$Period)

treasFunds <- treasFunds[grep("[0-9]",treasFunds$year),]
treasFunds$year <- str_extract(string = treasFunds$Period, "[[:digit:]]+")

yearSplit <- split(x = treasFunds, f = treasFunds$year)
annualBudget <- lapply(yearSplit, function(x) {
    outlay <- sub("r", "", x$Outlays)
    outlay <- sub(",", "", outlay)
    sum(as.numeric(outlay))
})


for(i in seq_along(annualBudget)) {
    
    if(as.integer(names(annualBudget)[i]) < 20) {
        
        if(nchar(names(annualBudget)[i]) == 1) {
            names(annualBudget)[i] <- paste0("0",names(annualBudget)[i])
        }
        
        names(annualBudget)[i] <- paste0("20",names(annualBudget)[i])
    } else {
        names(annualBudget)[i] <- paste0("19",names(annualBudget)[i])
    }
}
rm(i)


yearAnBud <- list()
for(i in seq_along(annualBudget)) {
    yearAnBud[[i]] <- data.frame(year = as.numeric(names(annualBudget)[i]), 
                                 totalFunds = annualBudget[[i]])
}
yearAnBud <- Reduce(f = rbind, yearAnBud)
#yearAnBud <- as.numeric(yearAnBud$year)
yearAnBud <- yearAnBud[order(yearAnBud$year),]

write.csv(yearAnBud, 
          file = "../../data/2020-02-09/total_an_budget_integrated.csv",
          row.names = F)
