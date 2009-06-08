library(RCurl)
library(plyr)

save_year <- function(state, year) {
  url <- "http://www.ssa.gov/cgi-bin/namesbystate.cgi"
  data <- postForm(url, style = "post", "year" = year, "state" = state) 
  writeLines(data, paste("original/", state, "-", year, ".html", sep=""))
}

years <- 1960:2008
states <- c("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY")

m_ply(expand.grid(state = states, year = years), save_year, 
  .progress = "text")
