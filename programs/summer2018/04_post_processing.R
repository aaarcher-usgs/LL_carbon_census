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
library(dplyr)

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
aggregate_data_plot_species <- aggregate(prairie_data$spp_biomass, 
                                         list(prairie_data$plot_species), FUN = sum)

#' Renamed columns in the aggregate temporary hold
colnames(aggregate_data_plot_species) <- c("plot_species", "biomass")

#'Add burn year to summarization
#'
species_biomass <- group_by (prairie_data, plot_species)

#'Can we aggragate without having a value? spring_burn is binary
species_biomass <- aggregate(prairie_data$spring_burn ~ prairie_data$plot_species, df, )

#' Setkey was another attempt at moving one column (spring_burn) over to aggregate dataset
setkey(setDT(aggregate_data_plot_species), plot_species)
aggregate_data_plot_species[prairie_data, spring_burn := i.spring_burn]

#' Does merge work for one column or does it have to be the complete dataset?
aggregate_data_plot_species <- merge(x = aggregate_data_plot_species, y = prairie_data$spring_burn, 
                                     by = c("plot_species"))

#' ## Save Results
#' 
save(prairie_data, file = "data/processed_data/summer2018_prairie_data.R")

#' ## Footer
#' 
#' spun with
#' ezknitr::ezspin(file = "programs/summer2018/03_data_analysis.R", out_dir = "programs/summer2018/output", fig_dir = "figures", keep_md = F)
#' 
