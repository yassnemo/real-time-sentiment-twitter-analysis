# Fetches tweets from Twitter API and preprocesses them

# Load global configurations and credentials
source("global.R")

# Function to fetch tweets in real-time
fetch_tweets <- function(query = "#datascience", timeout = 60, n = 1000) {
  tryCatch({
    
    # For standard search 
    search_tweets(
      q = query,
      n = n,
      lang = "en",
      include_rts = FALSE,
      token = twitter_token
    ) %>%
      mutate(timestamp = as_datetime(created_at)) %>%
      select(
        user_id, 
        text, 
        timestamp, 
        favorite_count, 
        retweet_count, 
        location = user_location
      )
  }, error = function(e) {
    message("Twitter API Error: ", e$message)
    return(NULL)
  })
}

# Function to preprocess tweets
preprocess_tweets <- function(tweets) {
  if (is.null(tweets) || nrow(tweets) == 0) return(NULL)
  
  tweets %>%
    mutate(
      clean_text = clean_text(text),  
      tokens = str_split(clean_text, "\\s+")
    ) %>%
    unnest(tokens) %>%
    filter(!tokens %in% stop_words) %>%
    group_by(user_id, timestamp) %>%
    summarise(
      cleaned_text = paste(tokens, collapse = " "),
      .groups = "drop"
    ) %>%
    left_join(tweets, by = c("user_id", "timestamp"))
}