bnames <- read.csv("baby-names.csv")

library(plyr)
# add ranks
ranked <- ddply(bnames, .(sex, year), transform, rank = rank(-percent))

top5 <- subset(ranked, rank <= 5)
top5$name <- as.character(top5$name)

library(ggplot2)
qplot(year, reorder(name, year, min), data = top5, group = name, geom = "text", label = rank) + facet_wrap(~ sex, scales = "free_y")

qplot(year, reorder(name, year, min), data = top5, group = name, colour = rank) + facet_wrap(~ sex, scales = "free_y")


qplot(year, percent, data = top5, group = name, colour = rank) + 
  facet_wrap(~ name) + 
  scale_x_continuous(breaks = c(1880, 1920, 1960, 2000))

