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
shannon_data<- bsdata[bsdata$plot%in%prairie_plots,]
shannon_data$plot_subplot<- paste(shannon_data$plot,shannon_data$subplot, sep='_')

shannon_data$biomass_total<-sum(shannon_data$plot_subplot,shannon_data$biomass_wt)

