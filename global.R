#source dataset from UsingR package
require(UsingR)
data <- babies

# uncomment in case UsingR package is not available from shinyapps.io
#write.table(data, "./UsingR.babies.txt", row.names=FALSE, sep="\t")
#data <- read.table("./UsingR.babies.txt", header=TRUE, sep="\t", colClasses = "numeric")

#clean-up and translate data
data$week <- trunc((data$date - min(data$date))/7)
data$id <- paste("baby_", data$id, sep="")
data$smoke[data$smoke == 0] <- "never"
data$smoke[data$smoke == 1] <- "smokes now"
data$smoke[data$smoke == 2] <- "until current pregnancy"
data$smoke[data$smoke == 3] <- "once did, not now"
data$smoke[data$smoke == 9] <- "unknown"
data$ed[data$ed == 0] <- "less than 8th grade"
data$ed[data$ed == 1] <- "8th-12th grade"
data$ed[data$ed == 2] <- "HS graduate"
data$ed[data$ed == 3] <- "HS + trade"
data$ed[data$ed == 4] <- "HS + college"
data$ed[data$ed == 5] <- "College graduate"
data$ed[data$ed == 6] <- "Unclear"

# for future use because google bubble chart does not support categorical variables
#data$ded[data$ded == 0] <- "less than 8th grade"
#data$ded[data$ded == 1] <- "8th-12th grade"
#data$ded[data$ded == 2] <- "HS graduate"
#data$ded[data$ded == 3] <- "HS + trade"
#data$ded[data$ded == 4] <- "HS + college"
#data$ded[data$ded == 5] <- "College graduate"
#data$ded[data$ded == 6] <- "Unclear"
#data$race[data$race %in% c(1:5)] <- "white"
#data$race[data$race == 6] <- "mexican"
#data$race[data$race == 7] <- "black"
#data$race[data$race == 8] <- "asian"
#data$race[data$race == 9] <- "mixed"

#subset data to remove values for 'unknown'
data_w <- data[data$dwt != 999,]
data_w <- data_w[data_w$wt1 != 999,]
data_a <- data[data$age != 99,]
data_a <- data_a[data_a$dage != 99,]
#data_e <- data[data$ed != 9,]
#data_e <- data_e[data_e$ded != 9,]
data_h <- data[data$ht != 99,]
data_h <- data_h[data_h$dht != 99,]
#data_r <- data[data$race != 99,]
#data_r <- data_r[data_r$drace != 99,]

# Use global max/min for axes so the view window stays constant as the user interacts with the charts
xlim_w <- 
    list(
      min = min(as.integer(data_w$wt1), as.integer(data_w$dwt)) - 5, #70
      max = max(as.integer(data_w$dwt), as.integer(data_w$wt1)) + 5  #260  
    )
ylim_w <- xlim_w

xlim_a <-
    list(
      min = min(as.integer(data_a$age), as.integer(data_a$dage)) - 5, #10 
      max = max(as.integer(data_a$dage), as.integer(data_a$age)) + 5  #60  
    )
ylim_a <- xlim_a

xlim_h <- 
    list(
      min = min(as.integer(data_h$ht), as.integer(data_h$dht)) - 5, #50 
      max = max(as.integer(data_h$dht), as.integer(data_h$ht)) + 5  #100
    )     
ylim_h <- xlim_h