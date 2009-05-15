library(ggplot2)
all <- read.csv("baby-names.csv", stringsAsFactors = FALSE)
all$sex <- factor(all$sex, levels = c("girl", "boy"))
sump <- colwise(sum, "percent")

# Investigate the percentage of all names that the top 1000 baby names
# occupies
ofall <- ddply(all, .(year, sex), sump)
qplot(year, percent, data = ofall, colour = sex, geom = "line") + ylim(0, 1)
# Recently trending down - names are become more diverse?


# Trends in various letters --------------------------------------------

# Helper function to extract letter at given position.  Negative values
# index from rear of string.
letter <- function(string, pos) {
  if (pos > 0) {
    substr(string, pos, pos) 
  } else {
    nc <- nchar(string)
    substr(string, nc + pos + 1, nc + pos + 1)
  }
}

axes <- list(
  scale_x_continuous(breaks = c(1900, 1950, 2000)),
  scale_y_continuous("", limits = c(0, 0.4), formatter = "percent")
)

# Last letter
ll <- ddply(all, .(year, sex, last = letter(name, -1)), sump)
qplot(year, percent, data = ll, colour = sex, geom = "line") + 
  facet_wrap(~ last) + axes
last_plot() + scale_y_log10()

# First letter
fl <- ddply(all, .(year, sex, first = letter(name, 1)), sump)
qplot(year, percent, data = fl, colour = sex, geom = "line") + 
  facet_wrap(~ first) + axes

# Second letter?
sl <- ddply(all, .(year, sex, second = letter(name, 2)), sump)
qplot(year, percent, data = sl, colour = sex, geom = "line") + 
  facet_wrap(~ second) + axes
