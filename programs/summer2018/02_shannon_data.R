#' # Calculate Shannon Diversity Index
#' 
#' **Objective** Effect of Spring Burn on Understory Biomass & Diversity
#' 
#' Takes processed biomass data and calculate Shannon diversity index per subplot.
#' 
#' ## Header
remove(list=ls())
library(ezknitr)
library(knitr)

#' ## Load data
#' 
load(file = "data/processed_data/summer2018_prairie_data.R")

#' ## Step 1: Calculate live biomass (exclude litter from analysis)
#' 
#' $$H_{sp} = \sum_{i_{sp}=1}^{S_{sp}} p_{i_{sp}}\ln{p_{i_{sp}}}$$
#' 
#' where $H_{sp}$ is the subplot-level Shannon Diversity Index; $i_{sp}$ is each
#' individual species per subplot; $S_{sp}$ is the subplot-level Species Richness 
#' (i.e., # of species), and $p_{i_{sp}}$ is the proportional biomass:
#' 
#' $$p_{i_{sp}} = \frac{\mathrm{biomass_{i_{sp}}}}{\mathrm{total\, live\, biomass_{sp}}}$$
#' 
live_plants <- prairie_data[!prairie_data$species == "Litter",]

#' Summarize (sum) over live plants by subplot
aggregate_live <- aggregate(live_plants$spp_biomass, list(live_plants$plot_subplot), sum)
colnames(aggregate_live) <- c("plot_subplot", "live_biomass")

#' Merge back to original live_plants data
live_plants <- merge(x = live_plants, y = aggregate_live, by = "plot_subplot")

#' ## Step 2: Calculate $S_{sp}$
#' 
aggregate_richness <- aggregate(live_plants$spp_biomass, list(live_plants$plot_subplot), FUN = length)
colnames(aggregate_richness) <- c("plot_subplot", "richness")

#' Merge back to original live_plants data
live_plants <- merge(x = live_plants, y = aggregate_richness, by = "plot_subplot")


#' ## Footer
#' 
#' spun with
#' ezknitr::ezspin(file = "programs/summer2018/02_shannon_data.R", out_dir = "programs/summer2018/output", fig_dir = "figures", keep_md = F)
#' 