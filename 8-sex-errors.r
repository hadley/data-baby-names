library(plyr)
# Hypothesis: constant percentage of sex recording errors
# Only see for very popular names because otherwise the 
# error never makes it into the top thousand.

bnames <- read.csv("baby-names.csv", stringsAsFactors = FALSE)

# For each year, find names used for both boys and girls
one <-  subset(bnames, year == 2008)

both <- ddply(bnames, "year", subset,
  name %in% intersect(name[sex == "boy"], name[sex == "girl"]))

both <- both[with(both, order(name, year, sex)), ]
# both$freq <- 1 / both$percent

library(reshape)
bysex <- cast(both, name + year ~ sex, value = "percent")
bysex <- add.all.combinations(bysex, c("name", "year"))
bysex$ratio <- log(bysex$boy / bysex$girl)

# Work out years each appears in dataset
years <- ddply(bysex, "name", function(df) sum(!is.na(df$ratio)))
years10 <- subset(years, V1 > 10)

common <- subset(bysex, name %in% years10$name)

library(ggplot2)
qplot(year, ratio, data = common, geom = "line", group = name)

pop <- subset(common, (boy > 0.01 | girl > 0.01 | is.na(boy) | is.na(girl))
qplot(year, abs(ratio), data = pop, geom = "line", group = name)

pop <- ddply(pop, "name", transform, 
  sex = ifelse(max(boy, na.rm = T) > max(girl, na.rm = T), "Boy", "Girl"))

ggplot(pop, aes(year, 1 / exp(abs(ratio)) * 1000)) +
  geom_line(aes(group = name)) +
  ylim(0, 15) + xlim(1880, 2000) + 
  ylab("Errors per thousand") + 
  facet_grid(sex ~ .) +
  geom_smooth(se = FALSE, size = 1)
ggsave("sex-errors.png")
