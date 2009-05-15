library(plyr)

files <- dir("raw", full = T)
names(files) <- gsub("\\.csv", "", dir("raw"))

bnames <- ldply(files, read.csv, header = F, skip = 1, nrows = 1000,
  stringsAsFactors = FALSE)
names(bnames) <- c("year", "rank", "boy_name", "boy_percent", "girl_name", "girl_percent")

# Change from wide to long form
boys <- bnames[c("year", "boy_name", "boy_percent")]
girls <- bnames[c("year", "girl_name", "girl_percent")]

names(boys) <- names(girls) <- c("year", "name", "percent")
boys$sex <- "boy"
girls$sex <- "girl"

all <- rbind(boys, girls)

# Turn percent string into a number
all$percent <- as.numeric(gsub("%", "", all$percent)) / 100
all$year <- as.numeric(as.character(all$year))

write
