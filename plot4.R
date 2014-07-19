library(foreign)
remove(list=ls())


## Your working directory should contain the original downloaded zip file
if ( !"exdata_data_household_power_consumption.zip"   %in%   list.files(getwd())) 
  stop("exdata_data_household_power_consumption.zip  file is missing in your working directory !!!")



# Read the data and perform some munging
tempdata <- read.table(unz("exdata_data_household_power_consumption.zip", 
                        "household_power_consumption.txt"), 
                    header = T,
                    colClasses = "character",
                    sep = ";")

names(tempdata) <- tolower(names(tempdata))
tempdata$date <- as.Date(tempdata$date, format = "%d/%m/%Y")


# Only keep dates required
idata <- subset(tempdata, 
                        tempdata$date >= as.Date("2007/02/01") &
                          tempdata$date <= as.Date("2007/02/02"))


# Recode all missing data coded as "?"
idata$global_active_power   <- ifelse(idata$global_active_power == "?", "NA", idata$global_active_power)
idata$global_reactive_power <- ifelse(idata$global_reactive_power == "?", "NA", idata$global_reactive_power)
idata$voltage               <- ifelse(idata$voltage == "?", "NA", idata$voltage)
idata$global_intensity      <- ifelse(idata$global_intensity == "?", "NA", idata$global_intensity)
idata$sub_metering_1 <- ifelse(idata$sub_metering_1 == "?", "NA", idata$sub_metering_1)
idata$sub_metering_2 <- ifelse(idata$sub_metering_2 == "?", "NA", idata$sub_metering_2)
idata$sub_metering_3 <- ifelse(idata$sub_metering_3 == "?", "NA", idata$sub_metering_3)

idata$datetime <- paste(as.character(idata$date), idata$time, set = " ")
idata$datetime <- as.POSIXct(idata$datetime)


# plot datetime vs energy sub metering
png(filename = "./ExData_Plotting1/plot4.png", 
    height = 480, 
    width = 480, 
    units = "px", 
    bg = "white")

par(mfrow = c(2,2), cex = 0.8)

## plot in RC(1, 1)
plot(idata$datetime, idata$global_active_power, 
     main = " ",
     ylab = "Global Active Power (kilowatts)",
     xlab = " ",
     lty = 1, 
     type = "l")

## plot in RC(1, 2)
plot(idata$datetime, idata$voltage, 
     main = " ",
     ylab = "voltage",
     xlab = "datetime",
     lty = 1,
     type = "l")

## plot in RC(2, 1)
plot(idata$datetime, idata$sub_metering_1, 
     main = " ",
     ylab = "Energy sub metering",
     xlab = " ",
     lty = 1,
     type = "l")
lines(idata$datetime, idata$sub_metering_2, col="red")
lines(idata$datetime, idata$sub_metering_3, col="blue")

legend("topright",
       legend = c("sub_metering_1", "sub_metering_2", "sub_metering_3"),
       col = c("black", "red", "blue"),
       bty = "n",
       lty = 1)

## plot in RC(2, 2)
plot(idata$datetime, idata$global_reactive_power, 
     main = " ",
     ylab = "Global_reactive_power",
     xlab = "datetime",
     lty = 1,
     type = "l")

dev.off()


## cleanup
remove(list=ls())
