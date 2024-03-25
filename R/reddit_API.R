# Script Settings And Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(RedditExtractoR)
library(stringr)

# Data Import and Cleaning
urls <- find_thread_urls(subreddit = "rstats", sort_by = "new", period = "month")
reddit <- get_thread_content(urls$url)
rstats_tbl <- as_tibble(reddit$threads) %>%
  select(c('title', 'upvotes', 'comments'))

#Analysis
comment_upvote_corr <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)
comment_upvote_corr
is_sig <- ifelse(comment_upvote_corr$p.value <= 0.05, "was", "was not")
df <- formatC(comment_upvote_corr$estimate ,digits = 2)
p <- formatC(comment_upvote_corr$p.value, digits=2)



#Visualization
rstats_tbl %>%
  ggplot(aes(x=comments, y = upvotes)) +
  geom_jitter() + 
  geom_smooth(method = "lm") + 
  labs(title = "Relationship Between # of Comments and Upvotes on Reddit Posts")


#Publication
#"The correlation between upvotes and comments was r(0.52) = .52 p = 3.3e-62.This test was statistically significant"
paste("The correlation between upvotes and comments was ", 
      "r(",df,") ", "= ", str_remove(df, "^0+"),
      " p = ", str_remove(p, "^0+"), '.', 'This test ', is_sig, " statistically significant", sep = "")

