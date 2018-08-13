#' # Effect of Spring Burn on Understory Biomass & Diversity
#' 
#' description
#' 
#' ## Header
remove(list=ls())
library(reshape)
library(ezknitr)
library(knitr)

#' ## Load data
#' 
#' Load biomass table
bsdata <- read.csv("data/Raw_Data/Biomass_Sorting_Data.csv")
head(bsdata)

#' ## Step 1: Calculate total biomass by subplot
#' 
#' Calculate biomass weight
bsdata$biomass_wt <- (bsdata$dried_wt - bsdata$bag_wt)


#' Select prairie plots from data
prairie_plots <- c(2,5,11,15,16,20,18,21,23,24,25,27)
prairie_data <- bsdata[bsdata$plot%in%prairie_plots,]

#' Create unique identifier
#' 
prairie_data$p_sp_spp <- ifelse(test = prairie_data$plot < 10, 
                                    yes = paste0("P0", prairie_data$plot, "_SP",  prairie_data$subplot, "_", prairie_data$species),
                                    no = paste0("P", prairie_data$plot, "_SP", prairie_data$subplot, "_", prairie_data$species))


#' We need to merge the two separate biomass bags' worth of data for 
#' plot 1, subplot 2
#' 
aggregate_data_sp <- aggregate(prairie_data$biomass_wt, list(prairie_data$p_sp_spp), sum)

#' Separate p_sp_spp into new columns
prairie_data <- transform(aggregate_data_sp, 
                          ID = colsplit(x = Group.1, split = "_", names = c("plot", "subplot", "species")))

#' Rename columns
colnames(prairie_data)
colnames(prairie_data) <- c("p_sp_spp", "spp_biomass", "plot", "subplot", "species")

#' Create unique identifier
#' 
prairie_data$plot_subplot <- paste(prairie_data$plot, prairie_data$subplot, sep = "_")

#' Summarize biomass data (sum) by plot_subplot
aggregate_data_plot <- aggregate(prairie_data$spp_biomass, list(prairie_data$plot_subplot), sum)

#' Merge total biomass back to prairie_data
prairie_data <- merge(x = prairie_data, y = aggregate_data_plot, 
                      by.x = "plot_subplot", by.y = "Group.1")

#' Rename columns
colnames(prairie_data)
colnames(prairie_data) <- c("plot_subplot", "p_sp_spp", "spp_biomass", "plot", "subplot", "species", "total_biomass")

#' ### Results of Step 1
head(prairie_data)

#' ## Step 2: Add in burn status
#' 
#' Make a list of all spring 2018 burned plots
burned_plots <- c("P18","P21","P23","P24","P25","P27")

#' Create a new column for burned or not (TRUE/FALSE)
#' 
prairie_data$spring_burn[prairie_data$plot %in% burned_plots] <- TRUE
prairie_data$spring_burn[! prairie_data$plot %in% burned_plots] <- FALSE
table(prairie_data$spring_burn)

#' ### Results of Step 2
head(prairie_data)



#' ## Save data
#' 
save(prairie_data, file = "data/processed_data/summer2018_prairie_data.R")

#' ## Footer
#' 
#' spun with
#' ezknitr::ezspin(file = "programs/summer2018/01_data_processing.R", out_dir = "programs/summer2018/output", fig_dir = "figures", keep_md = F)
#' 