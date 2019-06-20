#' # Processing 2018 and 2019 tree data
#' 
#' **Objective** Analyze tree growth from May 2018 through June 2019
#' 
#'
#' 
#' ## Header
remove(list=ls())
library(ezknitr)
library(knitr)

#' ## Load data
#' 
#' Load tree data from 2018
all_data2018 <- read.csv("data/raw_data/tree_survey/tree_survey_data2018.csv", 
                   encoding = "CSV UTF-8")
#' Load tree data from 2019
all_data2019 <- read.csv("data/raw_data/tree_survey/tree_survey_data2019.csv", 
                    encoding = "CSV UTF-8")


#' ## Step 1: Subset tree data only
#' 
tree2018 <- all_data2018[all_data2018$Type=="Tree",]

tree2019 <- all_data2019[all_data2019$Type=="tree",]

#' after subsetting trees, we noticed that there are 2x more trees this year
#' then last year. We might have data being read twice, or there are more
#' trees this year because of growth.
#' 
#' We are going to look at tagged trees first, then look at the possibility of 
#' shrub growth. We are uncertain with how we are going to look at 
#' 
#' When coding to not include "na," use $tag!="na",
tagged_tree2018 <- tree2018[tree2018$Tag.Number !="na",]

tagged_tree2019 <- tree2019[tree2019$Tag !="na",]

#' Confirmed that data from 2019 is reading each tree at least twice. 
#' 
#' We opened the file outside of R to see if data was duplicated and it was.
#' We are going to need to clean up the file.
#' 

#' ## Save data
#' 


#' ## Footer
#' 
#' spun with
#' ezknitr::ezspin(file = "programs/summer2019/01_tree_growth.R", out_dir = "programs/summer2019/output", fig_dir = "figures", keep_md = F)
#' 