# Script Settings And Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(rvest)

# Data Import and Cleaning
## URLs for the different sections
urls <- c(Business = "https://www.cnbc.com/business/",
          Investing = "https://www.cnbc.com/investing/",
          Tech = "https://www.cnbc.com/technology/",
          Politics = "https://www.cnbc.com/politics/")

page <- read_html("https://cnbc.com")
page %>%
  html_elements(".politics .nav-menu-buttonText , 
                .tech .nav-menu-buttonText , 
                .investing .nav-menu-buttonText , 
                .business_news .nav-menu-buttonText")
