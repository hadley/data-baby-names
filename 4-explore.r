

ofall <- ddply(all, .(year, sex), function(df) sum(df$percent))
library(ggplot2)
qplot(year, V1, data = ofall, colour = sex, geom = "line") + ylim(0, 1)


all$lastletter <- with(all, substr(name, nchar(name), nchar(name)))

ll <- ddply(all, .(year, sex, lastletter), function(df) sum(df$percent))
qplot(year, V1, data = ll, colour = sex, geom = "line") + 
  facet_wrap(~ lastletter) + 
  scale_x_continuous(breaks = c(1900, 1950, 2000))
  
last_plot() + scale_y_log10()
