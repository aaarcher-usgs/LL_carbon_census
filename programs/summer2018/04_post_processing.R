#' # Post Processing
#' 
#' **Objective** Effect of Spring Burn on Understory Biomass & Diversity
#' 
#' Takes processed data and creates a data set based on plot and species with 
#' respect to burn year.
#' 
#' ## Header

library(ezknitr)
library(knitr)


#' ## Load data
#' 
#' Subplot-level data
load(file = "data/processed_data/summer2018_prairie_data.R")

#' Load biomass table
bsdata <- read.csv("data/Raw_Data/Biomass_Sorting_Data.csv")
head(bsdata)

#' ## Create data set with plot and species
#' 
#' #' Create unique identifier
#' 
prairie_data$plot_species <- paste(prairie_data$plot, prairie_data$species, sep = "_")

#' Summarize biomass data (sum) by plot_species
aggregate_data_plot_species <- aggregate(prairie_data$spp_biomass, list(prairie_data$plot_species), sum)

#' ## Save Results
#' 

#' ## Footer
#' 
#' spun with
#' ezknitr::ezspin(file = "programs/summer2018/03_data_analysis.R", out_dir = "programs/summer2018/output", fig_dir = "figures", keep_md = F)
#' 
