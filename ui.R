# Dashboard user interface layout

source("global.R")

ui <- fluidPage(
  titlePanel("Real-Time Social Media Sentiment Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      width = 3,
      textInput("query", "Search Keywords/Hashtags:", value = "#datascience"),
      numericInput("n_tweets", "Tweets per Refresh:", value = 200, min = 50),
      actionButton("manual_refresh", "Refresh Now", icon = icon("sync")),
      hr(),
      checkboxGroupInput(
        "sentiment_types",
        "Show Sentiments:",
        choices = c("Positive", "Neutral", "Negative"),
        selected = c("Positive", "Neutral", "Negative")
      ),
      sliderInput("topic_slider", "Number of Topics:", min = 2, max = 6, value = 4)
    ),
    
    mainPanel(
      width = 9,
      fluidRow(
        valueBoxOutput("total_tweets"),
        valueBoxOutput("avg_sentiment"),
        valueBoxOutput("top_topic")
      ),
      fluidRow(
        tabBox(
          width = 12,
          tabPanel(
            "Sentiment Trends",
            plotlyOutput("sentiment_timeline")
          ),
          tabPanel(
            "Topic Model",
            plotlyOutput("topic_bars")
          ),
          tabPanel(
            "Recent Tweets",
            DTOutput("tweet_table")
          )
        )
      )
    )
  ),
  
  tags$head(
    tags$style(HTML("
      .value-box { min-height: 100px; }
      .tab-content { padding-top: 15px; }
    "))
  )
)