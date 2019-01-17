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
  scale_fill_manual(values=c("#999999", "#F5CCD7")) +
  scale_color_manual(values = c("black", "darkred")) +
  theme_classic() +
  xlab("Treatment") +
  ylab("Biomass (dry weight, g)")

#' ## Figure 2
#' 
#+ figure2
ggplot(aes(y = Ratio_mean, x = burn_status), data = burn_x_RSH)+
  geom_bar(stat = "identity", fill = "#999999") +
  geom_errorbar(aes(ymin= Ratio_LL, 
                    ymax= Ratio_UL),
                width=.2)+
  ylab("Ratio of litter to total biomass") +
  xlab("Burn Status") + 
  theme_classic()

#'## Figure 3
#'
#+ figure3
ggplot(aes(y = richnesS_mean, x = burn_status), data = burn_x_RSH)+
  geom_bar(stat = "identity", fill = "#999999") +
  geom_errorbar(aes(ymin= richnesS_LL, 
                    ymax= richnesS_UL),
                width=.2)+
  ylab("Species Richness") +
  xlab("Burn Status") + 
  theme_classic()

#'## Figure 4
#'
#'
#+ figure4
ggplot(aes(y = sHannon_mean, x = burn_status), data = burn_x_RSH)+
  geom_bar(stat = "identity", fill = "#999999") +
  geom_errorbar(aes(ymin= sHannon_LL, 
                    ymax= sHannon_UL),
                width=.2)+
  ylab("Shannon Diversity Index") +
  xlab("Burn Status")+
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
  c("09", "10", "24", "24", "01", "11", "02", "03", "12", "04", "24",
    "13", "14", "05", "24", 
    "15", "24", "24", "24", 
    "16", "06", "07", "17", "18", "08", "08", "24",
    "19", "19",
    "20", "24", 
    "21", "22", "24", "23"))

#' Merge order number back to main data
liveBM_x_spp <- merge(x = liveBM_x_spp, y = species_names, by.x = "species", by.y = "V1")

#' Create ordered species list
liveBM_x_spp$spp_order <- paste(liveBM_x_spp$order, liveBM_x_spp$name2, sep = " ")

#' Rename a couple
liveBM_x_spp$spp_order[liveBM_x_spp$spp_order=="08 Schizachyrium scoparium"|
                         liveBM_x_spp$spp_order=="08 Schizachyrium scrophulariifolia"] <-
  "08 Schizachyrium spp."
liveBM_x_spp$spp_order[liveBM_x_spp$spp_order=="19 Solidago sp."|
                         liveBM_x_spp$spp_order=="19 Solidago ulmifolia"] <-
  "19 Solidago spp."
liveBM_x_spp$spp_order[liveBM_x_spp$order=="11"|
                         liveBM_x_spp$order=="12"|
                         liveBM_x_spp$order=="13"|
                         liveBM_x_spp$order=="06"|
                         liveBM_x_spp$order=="07"] <- "24 Invasive"
liveBM_x_spp$spp_order[liveBM_x_spp$spp_order=="23 Viola sp."|
                         liveBM_x_spp$order=="22"] <- "24 Other"

#' Set colors
color_scale <- c('#c7e9c0','#a1d99b','#74c476','#41ab5d','#238b45',"#006d2c",#"#014636", #6
                 #"#993404", 
                 "#cc4c02",'#ef6548','#fc8d59','#fdbb84', #5
                 #'#67001f', '#980043', '#ce1256', '#e7298a', '#df65b0',#pinks 5
                 # '#c994c7','#d4b9da','#e7e1ef',#pinks 4
                 '#fcc5c0','#fa9fb5','#f768a1','#dd3497','#ae017e','#7a0177',#'#49006a',
                 #'#fa9fb5','#fcc5c0', #pinks continued 2
                 #'#fee8c8','#fdd49e',#'#d7301f', #'#b30000','#7f0000',#orange
                 #"#a50f15", 
                 "black", "grey"
                 )

#' Make the figure
#+ figure5_style1
ggplot(data = liveBM_x_spp,
        aes(y = biomass, x = plot)) +
  geom_bar(stat="identity", aes(fill=spp_order)) +
  facet_wrap(~spring_burn, scale = "free_x", ncol=1) + 
  scale_fill_manual(values = color_scale) +
  theme_classic()

#' ## Figure 5 - different style
#' 
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="01"] <- "G1 big bluestem"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="02"] <- "G2 grama grass"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="03"] <- "G3 smooth brome"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="04"] <- "Other"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="05"] <- "G4 wild rye"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="08"] <- "G5 little bluestem"

liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="09"] <- "F01 yarrow"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="10"] <- "F02 giant blue hyssop"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="14"] <- "F03 purple prairie clover"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="15"] <- "F04 oxeye sunflower"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="16"] <- "F05 wild bergamot"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="17"] <- "F06 prairie coneflower" 
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="18"] <- "F07 black-eyed Susan"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="19"] <- "F08 goldenrod"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="20"] <- "F09 dandelion"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="21"] <- "F10 poison ivy"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="11"|
                             liveBM_x_spp$order=="12"|
                             liveBM_x_spp$order=="13"|
                             liveBM_x_spp$order=="06"|
                             liveBM_x_spp$order=="07"] <- "Invasive"
liveBM_x_spp$ID_type_order[liveBM_x_spp$order=="22"|
                             liveBM_x_spp$order=="23"|
                             liveBM_x_spp$order=="24"] <- "Other"

#' Set colors
color_scale2 <- c("#cc4c02",'#ef6548','#fc8d59','#fdbb84', #oranges
                 '#fcc5c0','#fa9fb5','#f768a1','#dd3497','#ae017e','#7a0177',#purples
                 '#c7e9c0','#a1d99b','#74c476','#31a354','#006d2c',
                 #'#c7e9c0','#a1d99b','#74c476','#41ab5d','#238b45',"#006d2c",#grasses
                 "red", "black"
)

#' Make the figure
#+ figure5_style2
ggplot(data = liveBM_x_spp,
       aes(y = biomass, x = plot)) +
  geom_bar(stat="identity", aes(fill=ID_type_order)) +
  facet_wrap(~spring_burn, scale = "free_x", ncol=1) + 
  scale_fill_manual(values = color_scale2,
                    name = "Plant") +
  ylab("Biomass (dry weight, g)") + 
  xlab("Plot Number") +
  theme_classic()+
  theme(legend.text = element_text(size=8))
  
#' ## Footer
#' 
#' spun with
#' ezknitr::ezspin(file = "programs/summer2018/05_results_graphs.R", out_dir = "programs/summer2018/output", fig_dir = "figures", keep_md = F)
#' 


