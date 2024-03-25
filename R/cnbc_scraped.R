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
  sources
  all_headlines <- c(all_headlines, headlines)
  all_lengths <- c(all_lengths, lengths)
  all_sources <- c(all_sources, sources)
}

### realized I created a list where each element is a list of 1. This was a problem for graphing of course, 
### and was preventing me from factorizing the source column. I imagine there is a cleaner way to fix that within my for loop
### but I am running a bit low on time so am doing it the lazy way below.
cnbc_tbl <- tibble("headline" = all_headlines, "length" = all_lengths, "source" = all_sources)
cnbc_tbl$source <- sapply(cnbc_tbl$source, `[`, 1)
cnbc_tbl$headline <- sapply(cnbc_tbl$headline, `[`, 1)
cnbc_tbl$length <- sapply(cnbc_tbl$length, `[`, 1)

cnbc_tbl$source <- factor(cnbc_tbl$source)


#Analysis
anova_result <- aov(length~source, data = cnbc_tbl)

dfd <- anova_result$df.residual
p_value <- formatC(summary(anova_result)[[1]]$"Pr(>F)"[1], digits = 2)
f_value <- formatC(summary(anova_result)[[1]]$"F value"[1], digits = 2)
dfn <- summary(anova_result)[[1]]$"Df"[1]

is_sig <- ifelse(p_value <= 0.05, "was", "was not")



#Visualization
cnbc_tbl %>%
  ggplot(aes(x=source, y =length)) +
  geom_boxplot()

#Publication
paste("The results of an ANOVA comparing lengths across sources was ", 
      "r(",dfn, "," ,dfd,") ", "= ", str_remove(f_value, "^0+"),
      " p = ", str_remove(p_value, "^0+"), '.', 'This test ', is_sig, " statistically significant", sep = "")



