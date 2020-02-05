#!/usr/local/bin/Rscript

govLines <- readLines("../../data/2020-02-02/Agency_AID_table.txt")

govLines <- lapply(strsplit(govLines, split = "\\\t"), function(x) t(data.frame(x)))

govLines <- Reduce(f = rbind, x = govLines)
govLines <- as.data.frame(govLines)
govLines[,1] <- as.integer(govLines[,1])

govLines <- lapply(split(govLines, f = govLines[,2]), function(x) x[1,])
govLines <- Reduce(f = rbind, x = govLines)

write.csv(x = govLines, file = "../../data/2020-02-05/agency_aid_keys.csv", row.names = F)