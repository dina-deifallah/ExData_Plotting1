## This is the R code used to generate one of the required plots, plot2, for
## the data set in the flat file household_power_consumption.txt. 

# -----------------------------------------------------------
# Step 1: Loading packages
# -----------------------------------------------------------

library(dplyr)
library(lubridate) # I am using the lubridate package here because for me
# it is more flexible than the base date/time functions

# -----------------------------------------------------------
# Step 2: Reading data, Setting "?" to NA and subsetting
# -----------------------------------------------------------

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
hpc <- read.table(unz(temp, "household_power_consumption.txt") , sep = ";" , header = TRUE)
unlink(temp)
hpc <- mutate(hpc , Time = dmy_hms(paste(hpc$Date, hpc$Time)), Date = dmy(Date))
hpc[ ,3:9]<- data.frame(sapply(hpc[,3:9] , 
                               function(x){x[ as.character(x) == "?" ] <- NA; as.factor(x)}))
hpc_sub <- subset(hpc , Date == ymd("2007-02-01") | Date == ymd("2007-02-02") )
# now the data frame hpc_sub contains the data we need on the two specified dates
remove(hpc)  # removing the original complete data frame to free memory 

# -----------------------------------------------------------
# Step 3: Drawing plot 2 (Global Active Power in kwatt over time )
# -----------------------------------------------------------

plot(hpc_sub$Time , as.numeric(as.character(hpc_sub$Global_active_power)) , type = "l" , 
     xlab = "", ylab = "Global Active Power (kilowatts)")

# -----------------------------------------------------------
# Step 4:Copying the plot to a png image "plot2.png"
# -----------------------------------------------------------

dev.copy(png,'plot2.png' , width = 480 , height = 480 , units = "px")
dev.off()
