# File: server.R
# Reactive data processing and output rendering

source("global.R")
source("data_ingestion.R")
source("sentiment_analysis.R")
source("topic_modeling.R")  
server <- function(input, output, session) {
  # Automatic refresh trigger
  auto_refresh <- reactiveTimer(REFRESH_INTERVAL * 1000)
  
  # Main data pipeline
  observe({
    auto_refresh()
    input$manual_refresh 
    
    tryCatch({
      # Fetch and process new tweets
      new_tweets <- fetch_tweets(
        query = isolate(input$query),
        n = isolate(input$n_tweets)
      ) %>%
        preprocess_tweets() %>%
        mutate(sentiment = analyze_sentiment(cleaned_text)) %>%
        unnest(sentiment)
      
      # Update shared data
      shared_data$raw_tweets <- bind_rows(
        shared_data$raw_tweets,
        new_tweets
      )
      shared_data$last_update <- Sys.time()
    }, error = function(e) {
      showNotification(paste("Error:", e$message), type = "error")
    })
  })
  
  # Value boxes
  output$total_tweets <- renderValueBox({
    count <- nrow(shared_data$raw_tweets)
    valueBox(count, "Total Tweets", icon = icon("twitter"), color = "blue")
  })
  
  output$avg_sentiment <- renderValueBox({
    avg <- mean(shared_data$raw_tweets$afinn_score, na.rm = TRUE)
    valueBox(
      round(avg, 2),
      "Average Sentiment (AFINN)",
      icon = icon("smile"),
      color = ifelse(avg >= 0, "green", "red")
    )
  })
  
  # Sentiment timeline plot
  output$sentiment_timeline <- renderPlotly({
    agg_data <- aggregate_sentiment(shared_data$raw_tweets)
    
    plot_ly(agg_data, x = ~time_bucket) %>%
      add_lines(
        y = ~avg_afinn,
        name = "Sentiment Score",
        line = list(color = sentiment_palette["positive"])
      ) %>%
      add_bars(
        y = ~pos_ratio,
        name = "Positive Ratio",
        yaxis = "y2",
        marker = list(color = sentiment_palette["neutral"])
      ) %>%
      layout(
        yaxis2 = list(overlaying = "y", side = "right"),
        xaxis = list(title = "Time"),
        hovermode = "x unified"
      )
  })
  
  # Recent tweet table
  output$tweet_table <- renderDT({
    shared_data$raw_tweets %>%
      arrange(desc(timestamp)) %>%
      select(timestamp, cleaned_text, afinn_score) %>%
      mutate(timestamp = format(timestamp, "%Y-%m-%d %H:%M:%S")) %>%
      datatable(
        rownames = FALSE,
        colnames = c("Time", "Text", "Sentiment"),
        options = list(pageLength = 5, autoWidth = TRUE)
      )
  })
  
  # Topic modeling (optional)
  output$topic_bars <- renderPlotly({
    req(shared_data$raw_tweets)
    
    dtm <- create_dtm(shared_data$raw_tweets$cleaned_text)
    lda_model <- run_lda(dtm, num_topics = input$topic_slider)
    topic_terms <- get_topic_terms(lda_model)
    
    topic_terms %>%
      plot_ly(x = ~beta, y = ~reorder(term, beta), color = ~topic) %>%
      add_bars() %>%
      layout(
        barmode = "stack",
        yaxis = list(title = ""),
        xaxis = list(title = "Term Importance (Beta)")
      )
  })
}