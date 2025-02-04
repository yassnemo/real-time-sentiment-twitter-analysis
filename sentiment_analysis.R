# Calculates sentiment scores using multiple lexicons

# Function to analyze sentiment
analyze_sentiment <- function(cleaned_text) {
  if (is.null(cleaned_text) || length(cleaned_text) == 0) return(NULL)
  
  # AFINN scores (-5 to +5)
  afinn_scores <- get_sentiment(cleaned_text, method = "afinn")
  
  # NRC emotions (anger, anticipation, etc.)
  nrc_emotions <- get_nrc_sentiment(cleaned_text) %>%
    rename_with(~ paste0("nrc_", .x))
  
  # Bing classification (positive/negative)
  bing_sentiment <- get_sentiment(cleaned_text, method = "bing") %>%
    sign() %>%  # Convert to -1, 0, +1
    case_match(-1 ~ "negative", 0 ~ "neutral", 1 ~ "positive")
  
  tibble(
    afinn_score = afinn_scores,
    bing_sentiment = bing_sentiment
  ) %>%
    bind_cols(nrc_emotions)
}

# Function to aggregate sentiment over time
aggregate_sentiment <- function(tweets) {
  if (is.null(tweets)) return(NULL)
  
  tweets %>%
    mutate(
      time_bucket = floor_date(timestamp, "15 minutes") 
    ) %>%
    group_by(time_bucket) %>%
    summarise(
      avg_afinn = mean(afinn_score, na.rm = TRUE),
      pos_ratio = sum(bing_sentiment == "positive") / n(),
      .groups = "drop"
    )
}