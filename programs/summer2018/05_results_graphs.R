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
#+ figure3
ggplot(aes(y = richnesS_mean, x = burn_status), data = burn_x_RSH)+
  geom_bar(stat = "identity") +
  geom_errorbar(aes(ymin= richnesS_LL, 
                    ymax= richnesS_UL),
                width=.2)+
  theme_classic()

#'## Figure 4
#'
#'
#+ figure4
ggplot(aes(y = sHannon_mean, x = burn_status), data = burn_x_RSH)+
  geom_bar(stat = "identity") +
  geom_errorbar(aes(ymin= sHannon_LL, 
                    ymax= sHannon_UL),
                width=.2)+
  theme_classic()




#' ## Figure 5
#' 
#' Process data for figure 5
#' 
#' Rename spring_burn "True" and "False" to "burned" and "unburned"
liveBM_x_spp$spring_burn[liveBM_x_spp$spring_burn=="TRUE"] <- "Burned" 
liveBM_x_spp$spring_burn[liveBM_x_spp$spring_burn=="FALSE"] <- "Unburned"

#' Extract species name
species_names <- as.data.frame(
  matrix(
    as.character(
      sort(
        unique(liveBM_x_spp$species))),
    nrow = length(unique(liveBM_x_spp$species)),
    ncol = 1))

species_names$name2[species_names$V1 =="Ambrosa artemisifolia"|
                      species_names$V1 =="Ambrosa sp."|
                      species_names$V1 =="Chenopodium album"|
                      species_names$V1 =="Geum macrophyllum"|
                      species_names$V1 =="Hypercium perforatum"|
                      species_names$V1 =="Liatris sp."|
                      species_names$V1 =="Lithospermum incisum"|
                      species_names$V1 =="Silphium lacinatum"|
                      species_names$V1 =="Tephrosia virginiana"|
                      species_names$V1 =="Unknown"] <- "Other"
species_names$name <- as.character(species_names$V1)
species_names$name2[is.na(species_names$name2)] <- species_names$name[is.na(species_names$name2)]

#' Reorder species
species_names$order <- as.character(
  c("10", "11", "26", "26", "01", "12", "02", "03", "13", "04", "26",
    "14", "15", "05", "26", 
    "16", "26", "26", "26", 
    "17", "06", "07", "18", "19", "08", "09", "26",
    "20", "21",
    "22", "26", 
    "23", "24", "26", "25"))

#' Merge order number back to main data
liveBM_x_spp <- merge(x = liveBM_x_spp, y = species_names, by.x = "species", by.y = "V1")

#' Create ordered species list
liveBM_x_spp$spp_order <- paste(liveBM_x_spp$order, liveBM_x_spp$name2, sep = " ")

#' Set colors
color_scale <- c("#f7fcb9","#e5f5e0","#c7e9c0","#a1d99b", "#74c476", #grasses 5
                 "#41ab5d", "#238b45", "#006d2c", "#00441b", #grasses 4
                 "#e0ecf4", "#bfd3e6", "#9ebcda", "#8c96c6", "#8c6bb1", #purples 5
                 "#88419d", "#810f7c", "#4d004b", #purples 3
                 #"#fee8c8", "#fdd49e", "#fdbb84", "#fc8d59", "#ef6548", #orange  5
                 #"#d7301f", "#b30000", "#7f0000", #orange 3
                 "#ece7f2", "#d0d1e6", "#a6bddb", "#74a9cf", "#3690c0", #blues 5
                 "#0570b0", "#045a8d", "#023858", #blues 3
                 #"#7a0177", #extra purple 1
                 "black" #unknown 1
                 )

#' Make the figure
#+ figure5
ggplot(data = liveBM_x_spp,
        aes(y = biomass, x = plot)) +
  geom_bar(stat="identity", aes(fill=spp_order)) +
  facet_wrap(~spring_burn, scale = "free_x") + 
  scale_fill_manual(values = color_scale) +
  theme_classic()



  
#' ## Footer
#' 
#' spun with
#' ezknitr::ezspin(file = "programs/summer2018/05_results_graphs.R", out_dir = "programs/summer2018/output", fig_dir = "figures", keep_md = F)
#' 


