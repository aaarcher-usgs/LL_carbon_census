#' Set a seed so that each time your random numbers will begin at the same place.
#' 
#' The seed should just be any old number
set.seed(93751221)

#' Create an empty dataframe to hold random numbers
#' 
#' Note: named for...
#' 
#' - rs: soil respiration; 
#' - subplots: subplots within the larger 28 plots
#' - 2018a: because it's the first survey of the 2018 summer
rs_subplots_2018a <- as.data.frame(matrix(data = NA, nrow = 84, ncol = 4))

#' Name each column
colnames(rs_subplots_2018a) <- c("plot", "subplot", "distance", "direction")

#' Name plots
rs_subplots_2018a$plot <- rep(1:28, each = 3)

#' Name subplots
rs_subplots_2018a$subplot <- rep(1:3, times = 28)

#' Generate distances from center
rs_subplots_2018a$distance <- runif(n = 84, min = 0, max = 5)

#' Generate angles from N (0 degrees)
rs_subplots_2018a$direction <- runif(n = 84, min = 0, max = 360)

#' Save as csv
write.csv(x = rs_subplots_2018a, 
          file = "research_methods/soil_respiration/rs_subplots_2018a.csv")
