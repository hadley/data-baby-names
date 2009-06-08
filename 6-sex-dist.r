
bnames <- read.csv("baby-names.csv")
library(reshape)

sexdist <- cast(bnames, name ~ sex, sum, value = "percent")
sexdist <- transform(sexdist,
  total = boy + girl, 
  pmale = boy / (boy + girl),
  pfemale = girl / (boy + girl))
  


sexdist <- ddply(bnames, .(name), function(df) {
  boys <- df$sex == "boy"
  data.frame(
    boy =  sum(df$percent[boys]),
    girl = sum(df$percent[!boys]),
    total = sum(df$percent)
  )
}, .progress = "text")
sexdist <- sexdist[order(sexdist$total), ]

sexdist <- subset(sexdist, boy != 0 & girl != 0)
dim(sexdist)

top <- subset(sexdist, boy > 0.02 & girl > 0.02)


top_dist <- ddply(bnames[bnames$name %in% top$name, ], .(name, year), function(df) {
  boys <- df$sex == "boy"
  data.frame(
    boy =  sum(df$percent[boys]),
    girl = sum(df$percent[!boys]),
    total = sum(df$percent)
  )
}, .progress = "text")

top_dist$mperc <- top_dist$boy / top_dist$total

qplot(year, mperc, data = top_dist) + facet_wrap(~ name)

qplot(year, mperc, data = subset(top_dist, boy > 0.0001 & girl > 0.0001), geom="line") + facet_wrap(~ name)

# Would be interesting mturk experiment - what five words does this name
# evoke.  