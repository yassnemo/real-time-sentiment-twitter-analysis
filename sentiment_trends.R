# This script aggregates sentiment data over time.

# Load required scripts
source("global.R")
source("sentiment_analysis.R")  

# Function to aggregate sentiment trends
aggregate_sentiment <- function(tweets, time_interval = "hour") {
  tweets %>%
    mutate(timestamp = floor_date(created_at, unit = time_interval)) %>% 
    group_by(timestamp, sentiment) %>%  
    summarise(count = n(), .groups = "drop") %>%
    pivot_wider(names_from = sentiment, values_from = count, values_fill = 0) %>%  
    mutate(total = Positive + Negative + Neutral,  
           positive_pct = Positive / total * 100,
           negative_pct = Negative / total * 100,
           neutral_pct = Neutral / total * 100)
}

