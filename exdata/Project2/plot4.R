library(dplyr)
library(ggplot2)

### We load the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#SCC <- tbl_df(SCC)
### We select the SCC numbers that coint the word Coal/coal in its EI.Sector descriptor
SCC_coal <- SCC[which(grepl("[Cc]oal",SCC$EI.Sector)),"SCC"]

### We select entries that have a SCC that corresponds to a SCC coal code
NEI %>% filter(SCC %in% SCC_coal ) %>%  group_by(year) %>% summarize (Emissions=sum(Emissions)) %>% 
  ggplot (aes(x= year, y= Emissions)) + geom_line(size = 1.2) + geom_point(size =4) +
  ylab("Coal related PM2.5 emitted [tons]") + xlab("Year") +
  ggtitle ("PM2.5 coal related emissions per year in United States") +
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=16,face="bold"),
        title=element_text(size=20,face="bold"))
