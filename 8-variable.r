library(ggplot2)
library(plyr)

# Try and find names that vary a lot between the states.

bnames <- read.csv("baby-names-by-state.csv", stringsAsFactors = F)
bnames <- subset(bnames, !is.na(number))
bnames$state <- factor(bnames$state)

# Add number of births and convert to proportion
births <- read.csv("births.csv")
bnames <- merge(bnames, births, by = c("state", "year", "sex"))
bnames$prop <- bnames$number / bnames$births

# Extract only names that have appeared in at least 25% of possible years 
# and states
bnames$namesex <- paste(bnames$name, bnames$sex, sep = "-")
counts <- ddply(bnames, c("namesex"), summarise,
  n = length(namesex),
  number = sum(number))
counts <- counts[order(-counts$number), ]
counts <- subset(counts, n > 1250 * 0.25 & number > 1e5)

top <- subset(bnames, namesex %in% counts$namesex)
show_name <- function(name) {
  one <- top[top$namesex == name, ]  
  qplot(year, prop, data = one, geom = "line", group = state)
}

# Look for names where there is a lot of variation in pattern between states

# Correlation approach
bystate <- cast(top, namesex + year ~ state, value = "prop")

cors <- dlply(bystate, "namesex", function(df) 
  cor(as.matrix(df[, -(1:2)]), use = "pairwise.complete.obs"))

arrange(ldply(cors, min, na.rm = T), V1)

# Modelling approach - seems to do much better
patterns <- dlply(top, c("namesex"), function(df) {
  lm(prop ~ factor(year), data = df, weight = sqrt(births))
}, .progress = "text")

rsq <- function(mod) {
  summarise(summary(mod), rsq = r.squared, sigma = sigma)
}
qual <- arrange(merge(ldply(patterns, rsq), counts), -rsq)

sub <- c(as.character(qual$namesex[seq(1, nrow(qual), by = 5)]), "Juan-boy")

interesting <- subset(bnames, namesex %in% sub)
write.table(interesting, "interesting-names.csv", sep = ",", row = F)
