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
library(ggthemes)
library(extrafont)
library(plyr)
library(scales)


#' ## Load data
#' 
#' Subplot-level data
load(file = "data/processed_data/summer2018_prairie_data.R")

#' plot level live species
load(file = "data/processed_data/summer2018_liveBM_x_spp.R")

#' Biomass by burn and live status
load(file = "data/processed_data/summer2018_biomass_x_burn.R")

#' Burn versus R(ratio), S(Richness), H(Shannon)
load(file = "data/processed_data/summer2018_burn_x_RSH.R")

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

#' ## Figure 2
#' 
#+ figure2
ggplot(aes(y = Ratio_mean, x = burn_status), data = burn_x_RSH)+
  geom_bar(stat = "identity") +
  geom_errorbar(aes(ymin= Ratio_LL, 
                    ymax= Ratio_UL),
                width=.2)+
  theme_classic()

#'## Figure 3
#'
#'#+ figure3
ggplot(aes(y = richnesS_mean, x = burn_status), data = burn_x_RSH)+
  geom_bar(stat = "identity") +
  geom_errorbar(aes(ymin= richnesS_LL, 
                    ymax= richnesS_UL),
                width=.2)+
  theme_classic()

#'## Figure 4
#'
#'#+ figure4
ggplot(aes(y = sHannon_mean, x = burn_status), data = burn_x_RSH)+
  geom_bar(stat = "identity") +
  geom_errorbar(aes(ymin= sHannon_LL, 
                    ymax= sHannon_UL),
                width=.2)+
  theme_classic()

#Rename spring_burn "True" and "False" to "burned" and "unburned"
liveBM_x_spp$spring_burn[liveBM_x_spp$spring_burn=="TRUE"] <- "Burned" 
liveBM_x_spp$spring_burn[liveBM_x_spp$spring_burn=="FALSE"] <- "Unburned"

#' ## Figure 5
#' 
#' The which command was supposed to get rid of all the plots that were 0 biomass
#' facet_wrap cammand sepparates the bars into burned and unburned
#' facet_grid command is supposed to get rid of the extra space between bars when the plots are 0
#' 
#+ figure5

ggplot (liveBM_x_spp[which(biomass>0),],
        aes(y = biomass, x = plot) +
  geom_bar(stat="identity", aes(fill=species)) +
  facet_wrap(~spring_burn) + 
  facet_grid( ~plots, scales = "free_x"))
theme_classic()



  
#' ## Footer
#' 
#' spun with
#' ezknitr::ezspin(file = "programs/summer2018/05_results_graphs.R", out_dir = "programs/summer2018/output", fig_dir = "figures", keep_md = F)
#' 


