## action_date_fiscal_year -- year when award was given
## total_obligated_amount -- amount rewarded
## cfda_title -- description of program name
## award_description -- description of the award
## assistance_award_unique_key -- grant ID number
## period_of_performance_start_date -- start poitn of performance period
## period_of_performance_current_end_date -- end point of performance period
## action_date -- when the grant was rewarded

## here is an idea. lets see how the amounts behind the cfda title change over
## time... Key thing here is to avoid overcounting for multi-year grants...
    ## current idea for that might be to average by the total % of time within
    ## in the year the grant might be intact
    ## secondly, I need to check for grants occuring within multiple years.

## total_obligated_amount -- this does not change across the time the grant is
## active 

## helper functions to aquire days
nye <- function(year) {
    return(as.Date(paste0(year,"-12-31")))
}

nyd <- function(year) {
    return(as.Date(paste0(year,"-01-01")))
}

## grouping grant data together

allFiles <- list.files("data/2020-02-08/")
for(i in seq_along(allFiles)) {
    
    allGrants <- read.csv(file.path("data/2020-02-08/", 
                                    allFiles[i]), 
                          stringsAsFactors = F)
    allGrants <- allGrants[,c("total_obligated_amount",
                     "assistance_award_unique_key",
                     "cfda_title",
                     "period_of_performance_start_date",
                     "period_of_performance_current_end_date")]
    
    if(i == 1) {
        comboGrant <- allGrants
    } else {
        comboGrant <- rbind(comboGrant, allGrants)
        comboGrant <- comboGrant[!duplicated(comboGrant$assistance_award_unique_key),]
        comboGrant <- comboGrant[comboGrant$total_obligated_amount > 0,]
    }
    rm(allGrants)
}
rm(i)



## outer dataframe containing fields to store - initialize with number of grants
grantDf <- data.frame(GrantID = character(length = nrow(comboGrant)), 
                      start = character(length = nrow(comboGrant)), 
                      end = character(length = nrow(comboGrant)),
                      "2012" = integer(length = nrow(comboGrant)),
                      "2013" = integer(length = nrow(comboGrant)),
                      "2014" = integer(length = nrow(comboGrant)),
                      "2015" = integer(length = nrow(comboGrant)),
                      "2016" = integer(length = nrow(comboGrant)),
                      "2017" = integer(length = nrow(comboGrant)),
                      "2018" = integer(length = nrow(comboGrant)),
                      "2019" = integer(length = nrow(comboGrant)),
                      "2020" = integer(length = nrow(comboGrant)),
                      desc = character(length = nrow(comboGrant)),
                      stringsAsFactors = F)

## looping through grants
for(j in seq_len(nrow(comboGrant))) {
    
    ## storing information about grant
    grantDf$GrantID[j] <- comboGrant$assistance_award_unique_key[j]
    grantDf$start[j] <- comboGrant$period_of_performance_start_date[j]
    grantDf$end[j] <- comboGrant$period_of_performance_current_end_date[j]
    grantDf$desc[j] <- comboGrant$cfda_title[j]
    
    if(grantDf$start[j] == "" | grantDf$end[j] == 0) {
        next
    }
    
    ## parcing the percent of funds contributing over a specific year
    start <- as.Date(comboGrant$period_of_performance_start_date[j])
    end <- as.Date(comboGrant$period_of_performance_current_end_date[j])
    
    grantLength <- difftime(time2 = start, time1 = end, units = "days")
    
    year <- 2012
    percentYear <- list()
    counter <-  1
    while(year <= format(end, "%Y")) {
        if(year < format(start,"%Y")) {
            year <- year + 1
            next
        } else if(year == format(start,"%Y")) {
            yearTime <- difftime(time2 = start, time1 = nye(year), units = "days")
        } else if(year == format(end, "%Y")) {
            yearTime <- difftime(time1 = end, time2 = nyd(year))
        } else {
            yearTime <- difftime(nye(year), nyd(year), units = "days")
        }
        
        percentYear[[counter]] <- data.frame(percentYear = as.double(yearTime)/as.double(grantLength),
                                             year = year)
        counter <- counter + 1 
        year <- year + 1
    }
    
    if(length(percentYear) == 0) {
        next
    }
    
    percentYear <- lapply(percentYear, function(x) {
        x$totalFunding <- x$percentYear*comboGrant$total_obligated_amount[j]
        return(x)
    })
    
    percentYear <- Reduce(f = rbind, x = percentYear)
    
    ## storing per year averaged finance data
    for(k in seq_len(nrow(percentYear))) {
        grantDf[j,grep(percentYear$year[k], colnames(grantDf))] <- percentYear$totalFunding[k]
    }
    
}

## removing rows that have no $$ measures
keepRows <- rowSums(grantDf[,grep(pattern = "20", x = colnames(grantDf))]) > 0
grantDf <- grantDf[keepRows,]

write.csv(x = grantDf, file = "../../data/2020-02-09/EPA_summarized_data.csv", row.names = F)
