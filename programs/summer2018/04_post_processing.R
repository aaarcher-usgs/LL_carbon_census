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
#' Model outputs
load(file = "data/results_data/summer2018_models_out.R")

#' Subplot-level data
load(file = "data/processed_data/summer2018_prairie_data.R")

#' Plot-level data
load(file = "data/processed_data/summer2018_litter_data.R")

#' ## Populate first table for plotting 
#' 
#' Figure 1 will have total and live biomass by burn status
#' 
#' Calculate live understory biomass
litter_data$live_biomass <- litter_data$total_biomass - litter_data$spp_biomass

#' Create blank dataset to fill in
biomass_x_burn <- as.data.frame(matrix(NA, nrow = 4, ncol = 5))
colnames(biomass_x_burn) <- c("burn_status", "live_status", "BM_mean", "BM_LL", "BM_UL")
biomass_x_burn$burn_status <- c("Burned", "Burned", "Unburned", "Unburned")
biomass_x_burn$live_status <- c("Live", "Dead", "Live", "Dead")

#' Calculate means
biomass_x_burn$BM_mean[biomass_x_burn$burn_status=="Burned" & biomass_x_burn$live_status == "Live"] <- 
  mean(litter_data$live_biomass[litter_data$spring_burn==T])
biomass_x_burn$BM_mean[biomass_x_burn$burn_status=="Unburned" & biomass_x_burn$live_status == "Live"] <- 
  mean(litter_data$live_biomass[litter_data$spring_burn==F])
biomass_x_burn$BM_mean[biomass_x_burn$burn_status=="Burned" & biomass_x_burn$live_status == "Dead"] <- 
  mean(litter_data$spp_biomass[litter_data$spring_burn==T])
biomass_x_burn$BM_mean[biomass_x_burn$burn_status=="Unburned" & biomass_x_burn$live_status == "Dead"] <- 
  mean(litter_data$spp_biomass[litter_data$spring_burn==F])

#' Calculate errors
biomass_x_burn$BM_LL <- c(
  (19.843+3.81)-4.185, #burned, live
  (114.83-83.15)-14.53, # burned, dead
  19.843-2.959, # unburned, live
  114.83-10.28 # unburned, dead
)

biomass_x_burn$BM_UL <- c(
  (19.843+3.81)+4.185, #burned, live
  (114.83-83.15)+14.53, # burned, dead
  19.843+2.959, # unburned, live
  114.83+10.28 # unburned, dead
)

#' ## Create table for figures 2-4
#' 
#' Create empty dataset 
burn_x_RSH <- as.data.frame(matrix(NA, nrow = 2, ncol = 10))
colnames(burn_x_RSH) <- c("burn_status", 
                              "Ratio_mean", "Ratio_LL", "Ratio_UL",
                              "richnesS_mean", "richnesS_LL", "richnesS_UL",
                              "sHannon_mean", "sHannon_LL", "sHannon_UL")
burn_x_RSH$burn_status <- c("Unburned", "Burned")
burn_x_RSH$Ratio_mean <- c(0.80553, 0.80553-0.54422)
burn_x_RSH$Ratio_LL <- c(0.80553-0.06103, (0.80553-0.54422)-0.08631)
burn_x_RSH$Ratio_UL <- c(0.80553+0.06103, (0.80553-0.54422)+0.08631)

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
save(liveBM_x_spp, file = "data/processed_data/summer2018_liveBM_x_spp.R")
save(biomass_x_burn, file = "data/processed_data/summer2018_biomass_x_burn.R")
save(burn_x_RSH, file = "data/processed_data/summer2018_burn_x_RSH.R")

#' ## Footer
#' 
#' spun with
#' ezknitr::ezspin(file = "programs/summer2018/04_post_processing.R", out_dir = "programs/summer2018/output", fig_dir = "figures", keep_md = F)
#' 
