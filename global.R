# Suppress package startup messages
suppressPackageStartupMessages({
  library(rtweet)
  library(shiny)
  library(tidyverse)
  library(lubridate)
  library(textclean)
  library(syuzhet)
  library(tm)
  library(plotly)
  library(DT)
})

# Configure global options
options(shiny.maxRequestSize = 50*1024^2)  
options(digits = 4)                      

# Define text cleaning pipeline
clean_text <- function(text) {
  text %>%
    replace_url() %>%          
    replace_hash() %>%           
    replace_tag() %>%            
    replace_contraction() %>%    
    replace_emoticon() %>%       
    replace_symbol() %>%         
    str_remove_all("[^[:alnum:]]") %>% 
    str_to_lower() %>%           
    str_squish()                 
}

# Load stopwords
stop_words <- stopwords::stopwords("en", source = "snowball")