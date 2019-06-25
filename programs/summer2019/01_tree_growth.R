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
tree_merge$dbh.diff <- as.numeric(tree_merge$dbh2019) - 
  as.numeric(tree_merge$dbh2018)



#' Trying out making a polar plot using 2018 data
#' 


#' We need to figure out how to specifically call up one plot at a time.
#'
plot10_2018 <- tagged_tree2018[as.numeric(tagged_tree2018$plot2018==10)]

#' These sort data into just the plots and by year
#' 
plot3_2018 <- tagged_tree2018[tagged_tree2018$plot2018==3,] 

plot3_2019 <- tagged_tree2019[tagged_tree2019$plot2019==3,] 


plot6_2018 <- tagged_tree2018[tagged_tree2018$plot2018==6,] 

plot6_2019 <- tagged_tree2019[tagged_tree2019$plot2019==6,] 


plot9_2018 <- tagged_tree2018[tagged_tree2018$plot2018==9,] 

plot9_2019 <- tagged_tree2019[tagged_tree2019$plot2019==9,] 


plot10_2018 <- tagged_tree2018[tagged_tree2018$plot2018==10,] 

plot10_2019 <- tagged_tree2019[tagged_tree2019$plot2019==10,] 


plot22_2018 <- tagged_tree2018[tagged_tree2018$plot2018==22,] 

plot22_2019 <- tagged_tree2019[tagged_tree2019$plot2019==22,] 


plot26_2018 <- tagged_tree2018[tagged_tree2018$plot2018==26,] 

plot26_2019 <- tagged_tree2019[tagged_tree2019$plot2019==26,] 

#' Plots of trees (polar plot)
#'
plot6.2018 <- plot_ly(type='scatterpolar', 
                      r = plot6_2018$distance2018, 
                      theta = plot6_2018$direction2018,
                      mode = "markers", 
                      name = "2018")
plot6.2019 <- plot_ly(type='scatterpolar', 
                      r = plot6_2019$distance2019, 
                      theta = plot6_2019$direction2019,
                      mode = "markers",
                      name = "2019")
subplot(plot6.2018, plot6.2019)

plot3.2018 <- plot_ly(type='scatterpolar', 
                      r = plot3_2018$distance2018, 
                      theta = plot3_2018$direction2018,
                      mode = "markers", 
                      name = "2018")
plot3.2019 <- plot_ly(type='scatterpolar', 
                      r = plot3_2019$distance2019, 
                      theta = plot3_2019$direction2019,
                      mode = "markers",
                      name = "2019")
subplot(plot3.2018, plot3.2019)

plot9.2018 <- plot_ly(type='scatterpolar', 
                      r = plot9_2018$distance2018, 
                      theta = plot9_2018$direction2018,
                      mode = "markers", 
                      name = "2018")
plot9.2019 <- plot_ly(type='scatterpolar', 
                      r = plot9_2019$distance2019, 
                      theta = plot9_2019$direction2019,
                      mode = "markers",
                      name = "2019")
subplot(plot9.2018, plot9.2019)

plot10.2018 <- plot_ly(type='scatterpolar', 
                      r = plot10_2018$distance2018, 
                      theta = plot10_2018$direction2018,
                      mode = "markers", 
                      name = "2018")
plot10.2019 <- plot_ly(type='scatterpolar', 
                      r = plot10_2019$distance2019, 
                      theta = plot10_2019$direction2019,
                      mode = "markers",
                      name = "2019")
subplot(plot10.2018, plot10.2019)

plot22.2018 <- plot_ly(type='scatterpolar', 
                      r = plot22_2018$distance2018, 
                      theta = plot22_2018$direction2018,
                      mode = "markers", 
                      name = "2018")
plot22.2019 <- plot_ly(type='scatterpolar', 
                      r = plot22_2019$distance2019, 
                      theta = plot22_2019$direction2019,
                      mode = "markers",
                      name = "2019")
subplot(plot22.2018, plot22.2019)


plot26.2018 <- plot_ly(type='scatterpolar', 
                      r = plot26_2018$distance2018, 
                      theta = plot26_2018$direction2018,
                      mode = "markers", 
                      name = "2018")
plot26.2019 <- plot_ly(type='scatterpolar', 
                      r = plot26_2019$distance2019, 
                      theta = plot26_2019$direction2019,
                      mode = "markers",
                      name = "2019")
subplot(plot26.2018, plot26.2019)

#' Call all trees, not just tagged
#' 
#'Plot 3
plot3_2018_all <- tree2018[tree2018$Plot==3,] 

plot3_2019_all <- tree2019[tree2019$Plot==3,]

plot3.2018.all <- plot_ly(type='scatterpolar', 
                           r = plot3_2018_all$Distance..m., 
                           theta = plot3_2018_all$Direction....,
                           mode = "markers", 
                           name = "2018")

plot3.2019.all <- plot_ly(type='scatterpolar', 
                          r = plot3_2019_all$Distance..m., 
                          theta = plot3_2019_all$Direction..deg.,
                          mode = "markers", 
                          name = "2019")


subplot(plot3.2018.all, plot3.2019.all)

#'Plot 6
plot6_2018_all <- tree2018[tree2018$Plot==6,] 

plot6_2019_all <- tree2019[tree2019$Plot==6,]

plot6.2018.all <- plot_ly(type='scatterpolar', 
                          r = plot6_2018_all$Distance..m., 
                          theta = plot6_2018_all$Direction....,
                          mode = "markers", 
                          name = "2018")

plot6.2019.all <- plot_ly(type='scatterpolar', 
                          r = plot6_2019_all$Distance..m., 
                          theta = plot6_2019_all$Direction..deg.,
                          mode = "markers", 
                          name = "2019")

subplot(plot6.2018.all, plot6.2019.all)

#'Plot 9
plot9_2018_all <- tree2018[tree2018$Plot==9,] 

plot9_2019_all <- tree2019[tree2019$Plot==9,]

plot9.2018.all <- plot_ly(type='scatterpolar', 
                          r = plot9_2018_all$Distance..m., 
                          theta = plot9_2018_all$Direction....,
                          mode = "markers", 
                          name = "2018")

plot9.2019.all <- plot_ly(type='scatterpolar', 
                          r = plot9_2019_all$Distance..m., 
                          theta = plot9_2019_all$Direction..deg.,
                          mode = "markers", 
                          name = "2019")

subplot(plot9.2018.all, plot9.2019.all)

#'Plot 8
#'
plot8_2018_all <- tree2018[tree2018$Plot==8,] 

plot8_2019_all <- tree2019[tree2019$Plot==8,]

plot8.2018.all <- plot_ly(type='scatterpolar', 
                          r = plot8_2018_all$Distance..m., 
                          theta = plot8_2018_all$Direction....,
                          mode = "markers", 
                          name = "2018")

plot8.2019.all <- plot_ly(type='scatterpolar', 
                          r = plot8_2019_all$Distance..m., 
                          theta = plot8_2019_all$Direction..deg.,
                          mode = "markers", 
                          name = "2019")

subplot(plot8.2018.all, plot8.2019.all)

#' Plot 22
plot22_2018_all <- tree2018[tree2018$Plot==22,] 

plot22_2019_all <- tree2019[tree2019$Plot==22,]

plot22.2018.all <- plot_ly(type='scatterpolar', 
                          r = plot22_2018_all$Distance..m., 
                          theta = plot22_2018_all$Direction....,
                          mode = "markers", 
                          name = "2018")

plot22.2019.all <- plot_ly(type='scatterpolar', 
                          r = plot22_2019_all$Distance..m., 
                          theta = plot22_2019_all$Direction..deg.,
                          mode = "markers", 
                          name = "2019")

subplot(plot22.2018.all, plot22.2019.all)

#'Plot 13
plot13_2018_all <- tree2018[tree2018$Plot==13,] 

plot13_2019_all <- tree2019[tree2019$Plot==13,]

plot13.2018.all <- plot_ly(type='scatterpolar', 
                          r = plot13_2018_all$Distance..m., 
                          theta = plot13_2018_all$Direction....,
                          mode = "markers", 
                          name = "2018")

plot13.2019.all <- plot_ly(type='scatterpolar', 
                          r = plot13_2019_all$Distance..m., 
                          theta = plot13_2019_all$Direction..deg.,
                          mode = "markers", 
                          name = "2019")

subplot(plot13.2018.all, plot13.2019.all)

#' Plot 12
plot12_2018_all <- tree2018[tree2018$Plot==8,] 

plot12_2019_all <- tree2019[tree2019$Plot==8,]

plot12.2018.all <- plot_ly(type='scatterpolar', 
                          r = plot12_2018_all$Distance..m., 
                          theta = plot12_2018_all$Direction....,
                          mode = "markers", 
                          name = "2018")

plot12.2019.all <- plot_ly(type='scatterpolar', 
                          r = plot12_2019_all$Distance..m., 
                          theta = plot12_2019_all$Direction..deg.,
                          mode = "markers", 
                          name = "2019")

subplot(plot12.2018.all, plot12.2019.all)

#'Plot 7
plot7_2018_all <- tree2018[tree2018$Plot==7,] 

plot7_2019_all <- tree2019[tree2019$Plot==7,]

plot7.2018.all <- plot_ly(type='scatterpolar', 
                          r = plot7_2018_all$Distance..m., 
                          theta = plot7_2018_all$Direction....,
                          mode = "markers", 
                          name = "2018")

plot7.2019.all <- plot_ly(type='scatterpolar', 
                          r = plot7_2019_all$Distance..m., 
                          theta = plot7_2019_all$Direction..deg.,
                          mode = "markers", 
                          name = "2019")

subplot(plot7.2018.all, plot7.2019.all)

#'Plot 28
plot28_2018_all <- tree2018[tree2018$Plot=28,] 

plot28_2019_all <- tree2019[tree2019$Plot==28,]

plot28.2018.all <- plot_ly(type='scatterpolar', 
                          r = plot28_2018_all$Distance..m., 
                          theta = plot28_2018_all$Direction....,
                          mode = "markers", 
                          name = "2018")

plot28.2019.all <- plot_ly(type='scatterpolar', 
                          r = plot28_2019_all$Distance..m., 
                          theta = plot28_2019_all$Direction..deg.,
                          mode = "markers", 
                          name = "2019")

subplot(plot28.2018.all, plot28.2019.all)

#' ## Save data
#' 


#' ## Footer
#' 
#' spun with
#' ezknitr::ezspin(file = "programs/summer2019/01_tree_growth.R", out_dir = "programs/summer2019/output", fig_dir = "figures", keep_md = F)
#' 