library(dplyr)

### We load the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

### We summarize the required information by summing all emissions per year
TotalEmissions<-NEI %>% filter(fips == 24510) %>% group_by(year) %>% summarize (Emissions=sum(Emissions))

### We plot emissions as a function of year
with(TotalEmissions,plot(year,Emissions, pch= 16, xlab= "Year",ylab = "PM2.5 emitted [tons]",
                         main = "Total PM2.5 Emissions per year in Baltimore City"))

### We add lines to connect the points
with(TotalEmissions,lines(year,Emissions,lty =2))
 