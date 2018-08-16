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
library(ggplot2)

#' ## Load data
#' 
#' Subplot-level data
load(file = "data/processed_data/summer2018_prairie_data.R")

#' Biomass by burn and live status
load(file = "data/processed_data/summer2018_biomass_x_burn.R")

#' ## Figure 1
#' 
#+ figure1
ggplot(aes(y = BM_mean, x = burn_status), data = biomass_x_burn)+
  geom_bar(stat="identity", aes(fill=live_status)) +
  geom_errorbar(aes(ymin= BM_LL, 
                    ymax= BM_UL, color=live_status),
                width=.2) +
  scale_fill_manual(values=c("#999999", "#E69F00")) +
  theme_classic()



#' ## Footer
#' 
#' spun with
#' ezknitr::ezspin(file = "programs/summer2018/05_results_graphs.R", out_dir = "programs/summer2018/output", fig_dir = "figures", keep_md = F)
#' 
