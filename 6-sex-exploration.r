options(stringsAsFactors = FALSE)
library(plyr)
library(ggplot2)

# Two basic tasks:
#  * for names that are used for both boys and girls, how has usage changed?
#  * can we use names that clearly have the incorrect sex to estimate error
#    rates in this data?

bnames <- read.csv("baby-names.csv")

# The complete data set takes a long time to work with, so we want to limit it
# to names that plenty of data: i.e. that they've been in the top 1000 for 
# both boys and girls, and there are a decent number of babies with those 
# names.

# Your turn:  create a summary that for each name, gives:
#   * total proportion of babies with that name
#   * the total proportion of boys
#   * the total proportion of girls
#   * the number of years the name was in the top 1000 as a girls name
#   * the number of years the name was in the top 1000 as a boys name
#
# Hint: Start with a single name and figure out how to solve the problem
# Hint: Use summarise
times <- ddply(bnames, c("name"), summarise, 
  boys = sum(prop[sex == "boy"]),
  boys_n = sum(sex == "boy"),
  girls = sum(prop[sex == "girl"]),
  girls_n = sum(sex == "girl"),
  .progress = "text"
)

# ~7000 names in total - want to limit to under 200. In real-life would
# probably use more, but starting with a subset for easier comprehension isn't
# a bad idea.
nrow(times)

# At absolute minimum need at least 1 year each in top 1000.  This cuts it 
# down to 582 names.
times <- subset(times, boys_n > 1 & girls_n > 1)

# Use basic graphics to figure out good cut-offs
qplot(boys_n, girls_n, data = times)
qplot(log10(boys), log10(girls), data = times)

qplot(pmin(boys_n, girls_n), data = times, binwidth = 1)
times$both <- with(times, boys_n > 10 & girls_n > 10)

# Still a few too many names.  Lets focus on names that have managed a certain
# level of popularity.
qplot(pmin(boys, girls), data = subset(times, both), binwidth = 0.01)
qplot(pmax(boys, girls), data = subset(times, both), binwidth = 0.1)
qplot(boys + girls, data = subset(times, both), binwidth = 0.1)

both_sexes <- subset(times, both & boys + girls > 0.4)
selected_names <- both_sexes$name

# Now that we have figured out which names we should focus on (at least to
# begin with), we need to calculate yearly summaries for each of those names.

selected <- subset(bnames, name %in% selected_names)
nrow(selected) / nrow(bnames)

# For each name in each year, figure out total boys and total girls
bysex <- ddply(selected, c("name", "year"), summarise,
  boys = sum(prop[sex == "boy"]),
  girls = sum(prop[sex == "girl"]),
  .progress = "text"
)

# It's useful to have a symmetric means of comparing the relative abundance
# of boys and girls - the log ratio is good for this.
bysex$lratio <- log10(bysex$boys / bysex$girls)
bysex$lratio[!is.finite(bysex$lratio)] <- NA

# Explore the distribution of lratio for each name.  This is why a smaller
# number of names helps - we can more easily see the name associated with the 
# pattern and use our knowledge of names to determine whether or not it's
# plausible that the name is used for both sexes.
qplot(lratio, reorder(name, lratio, na.rm = T), data = bysex)
qplot(abs(lratio), reorder(name, lratio, na.rm = T), data = bysex)

qplot(abs(lratio), reorder(name, lratio, na.rm = T), data = bysex) +
  geom_point(data = both_sexes, colour = "red")

qplot(year, lratio, data = bysex, group = name, geom = "line")

# Two things seem to be helpful in differentiating true dual-sex names from
# errors: the average position and the amount of spread.  
# 
# Brainstorm: how could we summarise these things quantitatively?  
# Your turn: Compute the mean and range of lratio for each name
rng <- ddply(bysex, "name", summarise, 
  diff = diff(range(lratio, na.rm = T)),
  mean = mean(lratio, na.rm = T)
)

qplot(diff, abs(mean), data = rng)
qplot(diff, abs(mean), data = rng, colour = abs(mean) < 1.75 | diff > 0.9)

shared_names <- subset(rng, abs(mean) < 1.75 | diff > 0.9)$name

qplot(abs(lratio), reorder(name, lratio, na.rm=T), 
  data = subset(bysex, name %in% shared_names))

# Dual-sex names -------------------------------------------------------------

shared <- subset(bysex, name %in% shared_names)

qplot(year, lratio, data = shared, geom = "line") + facet_wrap(~ name)

# lratio useful because it's symmetric, but probably easier to switch back to
# something more familiar.
qplot(year, boys / (boys + girls), data = shared, geom = "line") + 
  facet_wrap(~ name)

# What's going on with Carol?  Let's go back to the raw data
qplot(year, prop, data = subset(bnames, name == "Carol"), colour = sex)
# How about Shirley?  
qplot(year, prop, data = subset(bnames, name == "Shirley"), colour = sex)

# Your turn: what is alike about these patterns?

# Sex encoding errors --------------------------------------------------------

errors <- subset(bysex, !(name %in% shared_names))
qplot(year, lratio, data = errors, group = name, geom = "line")
qplot(year, abs(lratio), data = errors, group = name, geom = "line", 
  colour = lratio > 0)
  
# Your turn: What do you see in this plot?   Do you think we can use this data
# to estimate sex-encoding errors?  Why/Why not?
