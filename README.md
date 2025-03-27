# Real-Time Twitter Sentiment Analysis in R


## Overview

This project enables real-time sentiment analysis of Twitter data using R. It classifies tweets as positive, negative, or neutral, providing insights into public sentiment on various topics.


## Features

- **Real-Time Data Collection:** Utilizes the Twitter API to fetch live tweets based on specified keywords or hashtags.
- **Sentiment Analysis:** Applies natural language processing techniques to determine the sentiment of each tweet.
- **Data Visualization:** Presents sentiment trends over time through interactive charts and graphs.

## Project Structure

- `global.R`: Contains global variables and configurations.
- `ui.R`: Defines the user interface for the Shiny application.
- `server.R`: Contains server-side logic for the Shiny application.
- `data_ingestion.R`: Handles data collection from Twitter.
- `sentiment_analysis.R`: Performs sentiment analysis on collected tweets.
- `sentiment_visualization.R`: Generates visualizations for sentiment data.
- `topic_modeling.R`: (Optional) Implements topic modeling on tweet data.

## Setup Instructions

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yassnemo/real-time-sentiment-twitter-analysis.git
   ```

2. **Install Required Packages:**
   Ensure you have the following R packages installed:
   - `shiny`
   - `rtweet`
   - `tidytext`
   - `ggplot2`
   - `dplyr`
   - `tidyr`
   - `wordcloud`
   - `tm`
   - `lubridate`

   You can install them using:
   ```r
   install.packages(c("shiny", "rtweet", "tidytext", "ggplot2", "dplyr", "tidyr", "wordcloud", "tm", "lubridate"))
   ```

3. **Authenticate with Twitter API:**
   Set up your Twitter API credentials using the `rtweet` package:
   ```r
   library(rtweet)
   create_token(
     app = "your_app_name",
     consumer_key = "your_consumer_key",
     consumer_secret = "your_consumer_secret",
     access_token = "your_access_token",
     access_secret = "your_access_secret"
   )
   ```

4. **Run the Shiny Application:**
   Launch the application by running:
   ```r
   library(shiny)
   runApp("path/to/your/app")
   ```

## Usage

- **Specify Keywords:** Modify the `data_ingestion.R` script to set the keywords or hashtags you want to track.
- **Analyze Sentiments:** Use the Shiny app interface to start the data collection and view real-time sentiment analysis.
- **Visualize Data:** Explore various charts and graphs to understand sentiment trends over time.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your improvements.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

