## This is the R code used to generate one of the required plots, plot3, for
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
# Step 3: Drawing plot 3 (Energy sub-metering over time )
# -----------------------------------------------------------

plot(hpc_sub$Time , as.numeric(as.character(hpc_sub$Sub_metering_1)) , col = "black" , type = "l" 
     , xlab = "", ylab = "Energy sub metering")
# the next two plots will be drawn using R command lines to avoid overwritting the first plot
lines(hpc_sub$Time , as.numeric(as.character(hpc_sub$Sub_metering_2)) , col = "red")
lines(hpc_sub$Time , as.numeric(as.character(hpc_sub$Sub_metering_3)) , col = "blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), lty = c(1,1,1)
       , cex = 0.8)

# -----------------------------------------------------------
# Step 4:Copying the plot to a png image "plot3.png"
# -----------------------------------------------------------

dev.copy(png,'plot3.png' , width = 480 , height = 480 , units = "px")
dev.off()
