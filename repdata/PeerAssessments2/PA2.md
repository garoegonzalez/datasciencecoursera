# Storms destruction analysis base on NOAA database
## Synopsis

This report presents the analysis performed on the NOAA Storm database. The database has stored storms information between 1950 and 2011. The report is divided in four sections, a first section where the environment is set. Then a second section presents the loading and the processing of the data. Processed data where number of fatalities, injuries and damage costs are plot as a function of event type. Finally, it is concluded from the results that tornados are the most deadly and costly event types.

### Environment setting


```r
suppressMessages (library (dplyr))
library (ggplot2)
```

### Data Procesing 

We download the data, if not already in the working directory, and we load into a local data frame {dplyr}. Notice that to avoid problems with the https protocol we remove the "s" to http and add download with the mode ="wb".


```r
NOAAFileName <- "repdata_data_StormData.csv.bz2"
if (!file.exists(NOAAFileName)) {
     dataUrl <- "http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
     download.file(dataUrl, NOAAFileName,mode = "wb")
}
NOAAdata <- tbl_df(read.csv(NOAAFileName, stringsAsFactors = FALSE, na.strings = "?"))
```

With the loaded data we summarize the count of fatalities and injuries per event type. We also sum the economic damage considering the crop and property damage. We order them as a function of fatalities to properly visualize the results.


```r
Summarized_data<- NOAAdata %>%
     mutate (EVTYPE = as.factor(EVTYPE)) %>% 
     group_by (EVTYPE) %>% 
     summarize (FATALITIES = sum(FATALITIES), INJURIES = sum(INJURIES), 
                DAMAGE = sum(PROPDMG) +sum (CROPDMG) ) 
Summarized_data<-Summarized_data %>% arrange (desc(FATALITIES))
Summarized_data
```

```
## Source: local data frame [985 x 4]
## 
##            EVTYPE FATALITIES INJURIES    DAMAGE
##            (fctr)      (dbl)    (dbl)     (dbl)
## 1         TORNADO       5633    91346 3312276.7
## 2  EXCESSIVE HEAT       1903     6525    1954.4
## 3     FLASH FLOOD        978     1777 1599325.1
## 4            HEAT        937     2100     961.2
## 5       LIGHTNING        816     5230  606932.4
## 6       TSTM WIND        504     6957 1445168.2
## 7           FLOOD        470     6789 1067976.4
## 8     RIP CURRENT        368      232       1.0
## 9       HIGH WIND        248     1137  342014.8
## 10      AVALANCHE        224      170    1623.9
## ..            ...        ...      ...       ...
```

### Results

From the process data, we obtain the top 10 events with cause most fatalities.

```r
## We order the level of the EVTYPE factor to properly plot it
Summarized_data$EVTYPE <- 
     factor(Summarized_data$EVTYPE, 
            levels=unique(as.character(Summarized_data$EVTYPE)) )

ggplot (data=Summarized_data[1:10,] ,aes(x = EVTYPE, y = FATALITIES)) + 
     geom_histogram(stat = "identity") + 
     theme(axis.text.x=element_text(angle=90, vjust=0.5, size=10)) +
     xlab ("Event type") + ggtitle ("Top 10 Fatality events")
```

![](PA2_files/figure-html/unnamed-chunk-4-1.png) 

We do the same exercise and obtain the top ten events that cause most injuries.

```r
## We order the level of the EVTYPE factor to properly plot it
Summarized_data<-Summarized_data %>% arrange (desc(INJURIES))
Summarized_data$EVTYPE <- 
     factor(Summarized_data$EVTYPE, 
            levels=unique(as.character(Summarized_data$EVTYPE)) )

ggplot (data=Summarized_data[1:10,] ,aes(x = EVTYPE, y = INJURIES)) + 
     geom_histogram(stat = "identity") + 
     theme(axis.text.x=element_text(angle=90, vjust=0.5, size=10)) +
     xlab ("Event type") + ggtitle ("Top 10 Injury events")
```

![](PA2_files/figure-html/unnamed-chunk-5-1.png) 

We finally analyze the cost damage per storm event type by summing crop and property damages. 

```r
## We order the level of the EVTYPE factor to properly plot it
Summarized_data<-Summarized_data %>% arrange (desc(DAMAGE))
Summarized_data$EVTYPE <- 
     factor(Summarized_data$EVTYPE, 
            levels=unique(as.character(Summarized_data$EVTYPE)) )

ggplot (data=Summarized_data[1:10,] ,aes(x = EVTYPE, y = DAMAGE / 10^6)) + 
     geom_histogram(stat = "identity") + 
     theme(axis.text.x=element_text(angle=90, vjust=0.5, size=10)) +
     xlab ("Event type") + ylab ("Economic damage [bln. US Dollar]") +
     ggtitle ("Top 10 Economic Damage events")
```

![](PA2_files/figure-html/unnamed-chunk-6-1.png) 

## Conclusions
From the results we can conclude that from the storms recorded in the NOAA database, the tornado related events show the larger fatality and injury numbers. In addition, 
tornados are the events that cause larger economic damages.

