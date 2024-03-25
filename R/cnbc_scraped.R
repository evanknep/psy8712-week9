# Script Settings And Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(rvest)
library(stringr)

# Data Import and Cleaning

## URLs for the different sections
urls <- c(Business = "https://www.cnbc.com/business/",
          Investing = "https://www.cnbc.com/investing/",
          Tech = "https://www.cnbc.com/technology/",
          Politics = "https://www.cnbc.com/politics/")



all_headlines <- list()
all_lengths <- list()
all_sources <- list()

for (url in urls) {
  source <- str_extract(url, "(?<=https://www\\.cnbc\\.com/)[^/]+")
  page <- read_html(url)
  headlines <- page %>%
    html_elements(".Card-title") %>%
    html_text()
  lengths <- headlines %>%
    str_count("\\w+")
  sources <- rep(source, length(headlines))
  all_headlines <- c(all_headlines, headlines)
  all_lengths <- c(all_lengths, lengths)
  all_sources <- c(all_sources, sources)
}

cnbc_tbl <- tibble(all_headlines, all_lengths, all_sources)




