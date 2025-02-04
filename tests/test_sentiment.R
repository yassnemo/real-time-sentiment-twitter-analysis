# File: test_sentiment.R (temporary)
source("global.R")
source("data_ingestion.R")
source("sentiment_analysis.R")

# Test pipeline
test_tweets <- fetch_tweets(query = "bitcoin", n = 100) %>%
  preprocess_tweets() %>%
  mutate(sentiment = analyze_sentiment(cleaned_text)) %>%
  unnest(sentiment)

# View results
test_tweets %>%
  select(cleaned_text, afinn_score, bing_sentiment) %>%
  slice_head(n = 5) %>%
  print()

# Test aggregation
aggregate_sentiment(test_tweets) %>%
  plot_ly(x = ~time_bucket) %>%
  add_lines(y = ~avg_afinn, name = "AFINN Score") %>%
  add_lines(y = ~pos_ratio, name = "Positive Ratio", yaxis = "y2") %>%
  layout(yaxis2 = list(overlaying = "y", side = "right"))