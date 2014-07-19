library(foreign)
par(mfrow = c(1,1), cex = 0.8)
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


# plot the histogam global_active_power
png(filename = "./ExData_Plotting1/plot1.png", 
    height = 480, 
    width = 480, 
    units = "px", 
    bg = "white")

hist(as.numeric(idata$global_active_power), 
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     breaks = "Sturges",
     right = TRUE,
     col = "red" )

dev.off()


## cleanup
remove(list=ls())
