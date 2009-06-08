# Bibical naming trends

oldt <- scan("old-testament.txt", "")
bnames <- read.csv("baby-names.csv")

oldt_names <- bnames[bnames$name %in% oldt, ]

library(plyr)
oldt_sum <- ddply(oldt_names, .(year, sex), function(df) 
  data.frame(percent = sum(df$percent), n = nrow(df)))

library(ggplot2)
qplot(year, percent, data = oldt_sum, colour = sex, geom = "line")
qplot(year, n, data = oldt_sum, colour = sex, geom = "line")


total <- ddply(oldt_names, .(sex, name), colwise(sum, "percent"))
total[order(-total$percent)[1:20], ]