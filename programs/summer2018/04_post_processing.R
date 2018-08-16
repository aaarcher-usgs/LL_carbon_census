#' # Post Processing
#' 
#' **Objective** Effect of Spring Burn on Understory Biomass & Diversity
#' 
#' Takes processed data and creates a data set based on plot and species with 
#' respect to burn year.
#' 
#' ## Header
remove(list=ls())
library(ezknitr)
library(knitr)
library(dplyr)

#' ## Load data
#' 
#' Subplot-level data
load(file = "data/processed_data/summer2018_prairie_data.R")

#' ## Create data set with plot and species
#' 
#' #' Create unique identifier
#' 
prairie_data$plot_species <- paste(prairie_data$plot, prairie_data$species, sep = "_")

#' Summarize biomass data (sum) by plot_species
plot_species_biomass <- 
  aggregate(prairie_data$spp_biomass, 
            list(prairie_data$plot_species, 
                 prairie_data$spring_burn,
                 prairie_data$species,
                 prairie_data$plot), 
            FUN = sum)

#' Renamed columns in the aggregate temporary hold
colnames(plot_species_biomass) <- c("plot_species", "spring_burn", "species", "plot","biomass")
head(plot_species_biomass)

#' Remove litter
liveBM_x_spp <- plot_species_biomass[!plot_species_biomass$species=="Litter",]

#' ## Save Results
#' 
save(liveBM_x_spp, file = "data/processed_data/liveBM_x_spp.R")

#' ## Footer
#' 
#' spun with
#' ezknitr::ezspin(file = "programs/summer2018/04_post_processing.R", out_dir = "programs/summer2018/output", fig_dir = "figures", keep_md = F)
#' 
