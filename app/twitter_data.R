library(twitteR)
library(rtweet)
library(NLP)
library(tm) # text mining
library(stringr)
library(SnowballC) # text stemming
library(RColorBrewer) # Color Palettes
library(wordcloud)
library(RWeka)
library(syuzhet) # Sentiment
library(topicmodels)
library(tidytext)
library(slam)

#======== User defined functions ====================

tweets_downloader <- function(tag, n, lang='en', retryonratelimit = TRUE) {
  
  twitter_token <- create_token(app = "s2", Sys.getenv("api_key"), Sys.getenv("api_secret"), access_token = Sys.getenv("access_token"), access_secret = Sys.getenv("access_secret"), set_renv = FALSE)
  
  tweet.df <- search_tweets(tag, n = n, include_rts = FALSE, lang = lang, token = twitter_token, retryonratelimit = retryonratelimit)
  print(paste0("Total Tweets downloaded for - ",tag,": ",length(tweet.df$text)))
  print(paste0("Total Unique Texts downloaded for - ",tag,": ",length(unique(tweet.df$text))))
  
  tweet.df$hashtags <- as.character(tweet.df$hashtags)
  tweet.df$symbols <- as.character(tweet.df$symbols)
  tweet.df$urls_url <- as.character(tweet.df$urls_url)
  tweet.df$urls_t.co <- as.character(tweet.df$urls_t.co)
  tweet.df$urls_expanded_url <- as.character(tweet.df$urls_expanded_url)
  tweet.df$media_url <- as.character(tweet.df$media_url)
  tweet.df$media_t.co <- as.character(tweet.df$media_t.co)
  tweet.df$media_expanded_url <- as.character(tweet.df$media_expanded_url)
  tweet.df$media_type <- as.character(tweet.df$media_type)
  tweet.df$ext_media_url <- as.character(tweet.df$ext_media_url)
  tweet.df$ext_media_t.co <- as.character(tweet.df$ext_media_t.co)
  tweet.df$ext_media_expanded_url <- as.character(tweet.df$ext_media_expanded_url)
  tweet.df$mentions_user_id <- as.character(tweet.df$mentions_user_id)
  tweet.df$mentions_screen_name <- as.character(tweet.df$mentions_screen_name)
  tweet.df$geo_coords <- as.character(tweet.df$geo_coords)
  tweet.df$coords_coords <- as.character(tweet.df$coords_coords)
  tweet.df$bbox_coords <- as.character(tweet.df$bbox_coords)
  
  tweet.df
}

tweets_cleaner <- function(tweet.df){
  
  tweets_txt <- unique(tweet.df$text)
  clean_tweet = gsub("&amp", "", tweets_txt) # Remove Amp
  clean_tweet = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", clean_tweet) # Remove Retweet
  clean_tweet = gsub("@\\w+", "", clean_tweet) # Remove @
  clean_tweet = gsub("#", " ", clean_tweet) # Before removing punctuations, add a space before every hashtag
  clean_tweet = gsub("[[:punct:]]", "", clean_tweet) # Remove Punct
  clean_tweet = gsub("[[:digit:]]", "", clean_tweet) # Remove Digit/Numbers
  clean_tweet = gsub("http\\w+", "", clean_tweet) # Remove Links
  clean_tweet = gsub("[ \t]{2,}", " ", clean_tweet) # Remove tabs
  clean_tweet = gsub("^\\s+|\\s+$", " ", clean_tweet) # Remove extra white spaces
  clean_tweet = gsub("^ ", "", clean_tweet)  # remove blank spaces at the beginning
  clean_tweet = gsub(" $", "", clean_tweet) # remove blank spaces at the end
  clean_tweet = gsub("[^[:alnum:][:blank:]?&/\\-]", "", clean_tweet) # Remove Unicode Char
  
  
  clean_tweet <- str_replace_all(clean_tweet," "," ") #get rid of unnecessary spaces
  clean_tweet <- str_replace_all(clean_tweet, "https://t.co/[a-z,A-Z,0-9]*","") # Get rid of URLs
  clean_tweet <- str_replace_all(clean_tweet, "http://t.co/[a-z,A-Z,0-9]*","")
  clean_tweet <- str_replace(clean_tweet,"RT @[a-z,A-Z]*: ","") # Take out retweet header, there is only one
  clean_tweet <- str_replace_all(clean_tweet,"#[a-z,A-Z]*","") # Get rid of hashtags
  clean_tweet <- str_replace_all(clean_tweet,"@[a-z,A-Z]*","") # Get rid of references to other screennames
  
  clean_tweet
}

tweets_cleaner_tm <- function(clean_tweet, custom_stopwords = c("bla bla")){
  
  docs <- Corpus(VectorSource(clean_tweet))
  #inspect(docs)
  
  
  docs <- tm_map(docs, content_transformer(tolower)) # Convert the text to lower case
  docs <- tm_map(docs, removeNumbers) # Remove numbers
  docs <- tm_map(docs, removeWords, stopwords("english")) # Remove english common stopwords
  docs <- tm_map(docs, removeWords, custom_stopwords)  # Remove your own stop word
  docs <- tm_map(docs, removePunctuation) # Remove punctuations
  docs <- tm_map(docs, stripWhitespace) # Eliminate extra white spaces
  # docs <- tm_map(docs, stemDocument) # Text stemming
  docs
}



#============ Get The data for all hashtags ==================


#=== Data Science 
tweet_df_ds <- tweets_downloader(tag="#DataScience OR #MachineLearning OR #DeepLearning", n=1000, lang='en', 
                                 retryonratelimit = TRUE)
saveRDS(tweet_df_ds, file = "/srv/shiny-server/tweet_df_ds.rds")


#================= Sentiment Analysis =========================
tweet_df_ds <- readRDS(file = "/srv/shiny-server/stweet_df_ds.rds")

word.df <- as.vector(tweets_cleaner(tweet_df_ds))
emotion_df_ds <- get_nrc_sentiment(word.df)
saveRDS(emotion_df_ds, file = "/srv/shiny-server/emotion_df_ds.rds")


