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
library(plotly)

#' ## Load data
#' 
#' Load tree data from 2018
all_data2018 <- read.csv("data/raw_data/tree_survey/tree_survey_data2018.csv", 
                   encoding = "CSV UTF-8",
                   stringsAsFactors = F)
#' Load tree data from 2019
all_data2019 <- read.csv("data/raw_data/tree_survey/tree_survey_data2019.csv", 
                    encoding = "CSV UTF-8",
                    stringsAsFactors = F)


#' ## Step One: Subset tree data only
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


#' ## Step Two: select for only tagged trees
#' 
#' When coding to not include "na," use $tag!="na",
#' 
tagged_tree2018 <- tree2018[tree2018$Tag.Number !="na" &
                              tree2018$Tag.Number !="",]

tagged_tree2019 <- tree2019[tree2019$Tag.Number !="na" &
                              tree2019$Tag.Number !="",]

#' Confirmed that data from 2019 is reading each tree at least twice. 
#' 
#' We opened the file outside of R to see if data was duplicated and it was.
#' We are going to need to clean up the file.
#' 
#' FIXED the duplication
#' 
#' 
#' Now determine what tag tree is in 2019's data but not 2018's
#' 
#' 
#' We found two enteries for the same tree at P26, tag number 24.
#' 
tagged_tree2019[tagged_tree2019$Tag.Number=="24",]

tagged_tree2019 <- subset(x = tagged_tree2019, DBH..cm.!=30.1)

tagged_tree2019[tagged_tree2019$Tag.Number=="24",]


#' ## Step Three: Make columns consistent but with year
#' 
#' 
colnames(tagged_tree2018)
colnames(tagged_tree2019)

colnames(tagged_tree2018) <- c("date2018", 
                               "plot2018",
                               "X2018",
                               "Y2018",
                               "type2018",
                               "common.name2018",
                               "genus2018",
                               "species2018",
                               "distance2018",
                               "direction2018",
                               "height2018", 
                               "stems2018",
                               "dbh2018",
                               "tag.number2018")

colnames(tagged_tree2019) <- c("date2019", 
                               "plot2019",
                               "X2019",
                               "Y2019",
                               "type2019",
                               "common.name2019",
                               "genus2019",
                               "species2019",
                               "distance2019",
                               "direction2019",
                               "stems2019",
                               "dbh2019",
                               "tag.number2019")


#' ## Step Four: Merge based on tree tag number
#' 
tree_merge <- merge(x = tagged_tree2018, y= tagged_tree2019, 
                    by.x = "tag.number2018", by.y = "tag.number2019")

#' ## Step Five: Calculate DBH growth
#' 
tree_merge$dbh.diff <- as.numeric(tree_merge$dbh2019) - as.numeric(tree_merge$dbh2018)

#' ## Save data
#' 


#' ## Footer
#' 
#' spun with
#' ezknitr::ezspin(file = "programs/summer2019/01_tree_growth.R", out_dir = "programs/summer2019/output", fig_dir = "figures", keep_md = F)
#' 