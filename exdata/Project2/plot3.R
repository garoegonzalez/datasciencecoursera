library(dplyr)
library(ggplot2)

### We load the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

### We summarize the required information by summing all emissions per year and we pass the data frame to 
### be plotted
NEI %>% filter(fips == 24510) %>% group_by(year,type) %>% summarize (Emissions=sum(Emissions)) %>% 
  mutate(type = as.factor (type)) %>%
    ggplot (aes(x= year, y= Emissions, color = type)) + geom_line(size = 1.2) + geom_point(size =4) +
    ylab("PM2.5 emitted [tons]") + xlab("Year") +
    ggtitle ("PM2.5 type emissions per year in Baltimore City") +
    theme(axis.text=element_text(size=14),
        axis.title=element_text(size=16,face="bold"),
        title=element_text(size=20,face="bold"))
