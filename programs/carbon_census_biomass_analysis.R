#' #Effect of the Spring Burn on Understory Biomass and Diversity
#' 
#' description
#' 


getwd()
bsdata<- (read.csv("Raw_Data/Biomass_Sorting_Data.csv"))

head(bsdata)
#' Calculate biomass weight
bsdata$biomass_wt <- (bsdata$dried_wt - bsdata$bag_wt)

#' Create data format for analysis
