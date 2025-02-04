# Identifies latent topics using LDA

# Function to create document-term matrix
create_dtm <- function(cleaned_text) {
  corpus <- Corpus(VectorSource(cleaned_text)) %>%
    tm_map(stemDocument) %>%  
    tm_map(stripWhitespace)
  
  DocumentTermMatrix(corpus, control = list(
    weighting = weightTfIdf,
    bounds = list(global = c(5, 100)) 
  ))
}

# Function to run LDA
run_lda <- function(dtm, num_topics = 4) {
  if (is.null(dtm) || nrow(dtm) < 10) return(NULL)  
  
  topicmodels::LDA(
    dtm,
    k = num_topics,
    control = list(seed = 1234)
  )
}

# Function to extract top terms
get_topic_terms <- function(lda_model, num_terms = 5) {
  if (is.null(lda_model)) return(tibble())
  
  lda_model %>%
    tidy(matrix = "beta") %>%
    group_by(topic) %>%
    slice_max(beta, n = num_terms) %>%
    ungroup() %>%
    mutate(topic = paste("Topic", topic))
}