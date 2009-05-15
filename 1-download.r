library(RCurl)
library(plyr)
library(XML)

save_year <- function(year) {
  url <- "http://www.ssa.gov/cgi-bin/popularnames.cgi"
  data <- postForm(url, style = "post", 
    "number" = "p", "top" = "1000", "year" = year) 
  writeLines(data, paste("original/", year, ".html", sep=""))
}

years <- 1880:2008
l_ply(years, save_year)
