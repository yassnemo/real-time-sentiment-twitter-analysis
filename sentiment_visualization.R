# This script creates visualizations for sentiment trends.

# Load required scripts
source("global.R")
source("sentiment_trends.R")

# Function to plot sentiment trends
plot_sentiment_trends <- function(sentiment_data) {
  ggplot(sentiment_data, aes(x = timestamp)) +
    geom_line(aes(y = positive_pct, color = "Positive"), size = 1) +
    geom_line(aes(y = negative_pct, color = "Negative"), size = 1) +
    geom_line(aes(y = neutral_pct, color = "Neutral"), size = 1) +
    labs(title = "Sentiment Trends Over Time",
         x = "Time",
         y = "Percentage of Tweets",
         color = "Sentiment") +
    theme_minimal()
}

# Function to create an interactive plotly chart
plot_sentiment_trends_interactive <- function(sentiment_data) {
  p <- plot_sentiment_trends(sentiment_data)
  ggplotly(p)  # convert ggplot to interactive plotly chart
}
