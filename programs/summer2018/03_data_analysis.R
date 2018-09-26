#' # Test hypotheses
#' 
#' **Objective** Effect of Spring Burn on Understory Biomass & Diversity
#' 
#' Analyzes the effect of burn on various dependent variables.
#' 
#' ## Header
remove(list=ls())
library(ezknitr)
library(knitr)
library(lme4)
library(lmerTest)

#' ## Load data
#' 
#' Subplot-level data
load(file = "data/processed_data/summer2018_litter_data.R")


#' ## Hypothesis 1: Spring burn will decrease total understory biomass (live and dead).
#' 
#' Run the model
hyp1.model <- lmer(formula = (total_biomass) ~ spring_burn + (1|plot), 
                   data = litter_data, 
                   REML = TRUE)
summary(hyp1.model)

#' ## Hypothesis 2: Spring burn will decrease the ratio of litter to total understory
#' biomass (live and dead).
#' 
#' Calculate the ratio of litter to total understory biomass
litter_data$ratio_LtoBM <- litter_data$spp_biomass / litter_data$total_biomass

#' Run the model.
hyp2.model <- lmer(formula = (ratio_LtoBM) ~ spring_burn + (1|plot), 
                   data = litter_data, 
                   REML = TRUE)
summary(hyp2.model)

#' Run a model testing for differences in litter, specifically
hyp2a.model <- lmer(formula = spp_biomass ~ spring_burn + (1|plot), 
                   data = litter_data, 
                   REML = TRUE)
summary(hyp2a.model)

#' ## Hypothesis 3: Spring burn will increase understory growth & diversity.
#' 
#' Calculate live understory biomass
litter_data$live_biomass <- litter_data$total_biomass - litter_data$spp_biomass

#' Run the model.
hyp3a.model <- lmer(formula = (live_biomass) ~ spring_burn + (1|plot), 
                    data = litter_data, 
                    REML = TRUE)
summary(hyp3a.model)

#' Run the model: Richness (S)
hyp3b.model <- lmer(formula = (richness) ~ spring_burn + (1|plot), 
                   data = litter_data, 
                   REML = TRUE)
summary(hyp3b.model)

#' Run the model: Shannon Diversity Index (H)
hyp3c.model <- lmer(formula = (shannon) ~ spring_burn + (1|plot), 
                    data = litter_data, 
                    REML = TRUE)
summary(hyp3c.model)

#' ## Save Results
#' 
save(hyp1.model, hyp2.model, hyp3a.model, hyp3b.model, hyp3c.model,
     file = "data/results_data/summer2018_models_out.R")

#' ## Footer
#' 
#' spun with
#' ezknitr::ezspin(file = "programs/summer2018/03_data_analysis.R", out_dir = "programs/summer2018/output", fig_dir = "figures", keep_md = F)
#' 