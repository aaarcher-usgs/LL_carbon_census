#' #Effect of the Spring Burn on Understory Biomass and Diversity
#' 
#' description
#' 


getwd()
bsdata<- (read.csv("Raw_Data/Biomass_Sorting_Data.csv"))

head(bsdata)

#' Calculate biomass weight

bsdata$biomass_wt <- (bsdata$dried_wt - bsdata$bag_wt)

#' Select prairie plots from data

prairie_plots<- c(2,5,11,15,16,20,18,21,23,24,25,27)
prairie_data<- bsdata[bsdata$plot%in%prairie_plots,]

#' Select subplots to create total biomass
#' We tried cbind (error stated missing function) and merge (not correct output)
#'error:cannot find function "%>%"
#'From Friday...
prairie_data$plot_subplot<- paste(prairie_data$plot,prairie_data$subplot,sep = '_')
prairie_data$biomass_total<-aggregate(prairie_data$biomass_wt,list(prairie_data$plot_subplot),sum)
library(plyr)
x%>%
  group_by(prairie_data$subplot)%>%
  summarise(sum(prairie_data$biomass_wt))
#' Tried on August 13, 2018
summarise(group_by(prairie_data,prairie_data$subplot),sum(prairie_data$biomass_wt,na.rm=TRUE))

#' We could not save the biomass total into data, but it shows in console when the data is run.
#' Renamed variable below 
library(plyr)
ddply(prairie_data,.(plot_subplot),summarize,Var=sum(biomass_wt))
#'The final attempt before giving up on Friday is below.
prairie_data$biomass_total<- aggregate(prairie_data$biomass_wt,list(sum))
