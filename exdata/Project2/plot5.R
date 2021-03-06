library(dplyr)
library(ggplot2)

### We load the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

### We select the SCC numbers that coint the word Vehicle/vehicle in its SCC.Level.Two descriptor
SCC_vehicule <- SCC[which(grepl("[Vv]ehicles",SCC$SCC.Level.Two)),"SCC"]

### We select entries that have a SCC that corresponds to a SCC vehicle code
NEI %>% filter(SCC %in% SCC_vehicule, fips == 24510 ) %>%  group_by(year) %>% summarize (Emissions=sum(Emissions)) %>%
  ggplot (aes(x= year, y= Emissions)) + geom_line(size = 1.2) + geom_point(size =4) +
  ylab("Vehicles related PM2.5 emitted [tons]") + xlab("Year") +
  ggtitle ("PM2.5 vehicles related emissions per year in Baltimore City") +
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=16,face="bold"),
        title=element_text(size=20,face="bold"))