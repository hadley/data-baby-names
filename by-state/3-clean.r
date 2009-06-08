library(plyr)

files <- dir("raw", full = T)
names(files) <- gsub("\\.csv", "", dir("raw"))

# Load all csv files into a single data frame and give informative column
# names

bnames <- ldply(files, read.csv, header = F, skip = 1, nrows = 1000,
  stringsAsFactors = FALSE)
names(bnames) <- c("file", "rank", "boy_name", "boy_num", "girl_name", "girl_num")

# Change from wide to long form
boys <- bnames[c("file", "boy_name", "boy_num")]
girls <- bnames[c("file", "girl_name", "girl_num")]

names(boys) <- names(girls) <- c("file", "name", "number")
boys$sex <- "boy"
girls$sex <- "girl"

all <- rbind(boys, girls)

# Turn number into a real numbers
all$number <- as.numeric(gsub(",", "", all$number))

# Separate year and state
library(reshape)
all <- cbind(colsplit(all$file, "-", c("state", "year")), all)
all$year <- as.numeric(as.character(all$year))
all$file <- NULL

# Save as csv
write.table(all, "../baby-names-by-state.csv", sep=",", row = F)
