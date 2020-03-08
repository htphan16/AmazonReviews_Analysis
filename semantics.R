library(ggplot2)
library(tidyverse)
library(dplyr)
library(tm)
library(tidytext)
library(qdap)
library(topicmodels)
library(textmineR)

cleaned_pacifier <- read.csv("Problem_C_Data/cleaned_pacifier.tsv")
cleaned_microwave <- read.csv("Problem_C_Data/cleaned_microwave.tsv")
cleaned_hair_dryer <- read.csv("Problem_C_Data/cleaned_hair_dryer.tsv")

mean(cleaned_microwave$helpful_votes)
median(nchar(as.character(cleaned_microwave$review_body)))
refined_pacifier <- filter(cleaned_pacifier, nchar(as.character(review_body))>=150, as.numeric(helpful_votes/total_votes) > 0.98, as.numeric(helpful_votes) >= 1)
refined_microwave <- filter(cleaned_microwave, nchar(as.character(review_body))>=150, as.numeric(helpful_votes/total_votes) > 0.95, as.numeric(helpful_votes) >= 1)

cleaned_pacifier_review <- cleaned_pacifier %>% rename(doc_id=product_id,text=review_body)
head(cleaned_pacifier_review)

cleaned_pacifier_corpus <- VCorpus(DataframeSource(cleaned_pacifier_review))
cleaned_pacifier_corpus

### Text processing
### tolower(): Make all characters lowercase
### removePunctuation(): Remove all punctuation marks
### removeNumbers(): Remove numbers
### stripWhitespace(): Remove excess whitespace
### bracketX(): Remove all text within brackets (e.g. "It's (so) cool" becomes "It's cool")
### replace_number(): Replace numbers with their word equivalents (e.g. "2" becomes "two")
### replace_abbreviation(): Replace abbreviations with their full text equivalents (e.g. "Sr" becomes "Senior")
### replace_contraction(): Convert contractions back to their base words (e.g. "shouldn't" becomes "should not")
### replace_symbol() Replace common symbols with their word equivalents (e.g. "$" becomes "dollar")
### all_stops <- c("word1", "word2", stopwords("en"))
### Once you have a list of stop words that makes sense, you will use the removeWords() function on your text. 
### removeWords() takes two arguments: the text object to which it's being applied and the list of words to remove.

### Alter the function code to match the instructions
cleaner_pacifier_corpus <- function(corpus) {
  # Replace contraction, number
  corpus <- tm_map(corpus, replace_contraction)
  corpus <- tm_map(corpus, replace_number)
  # Remove punctuation
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, PlainTextDocument)
  # Transform to lower case
  corpus <- tm_map(corpus, content_transformer(tolower))
  # Add more stopwords
  corpus <- tm_map(corpus, removeWords, words = c(stopwords("en")))
  # Strip whitespace
  corpus <- tm_map(corpus, stripWhitespace)
  # Remove numbers
  corpus <- tm_map(corpus, removeNumbers)
  return(corpus)
}

cleaner_pacifier_corp <- cleaner_pacifier_corpus(cleaned_pacifier_corpus)
content(cleaner_pacifier_corp)[[2]]
cleaner_pacifier_corp
pacifier_DTM <- DocumentTermMatrix(cleaner_pacifier_corp)
pacifier_m <- as.matrix(pacifier_DTM)
pacifier_m[1:200,'baby']
pacifier_TDM <- TermDocumentMatrix(cleaner_pacifier_corp)
pacifier_DTM$dimnames$Terms
rowTotals <- apply(pacifier_DTM , 1, sum) #Find the sum of words in each Document
pacifier_DTM.new <- pacifier_DTM[rowTotals> 0, ]           #remove all docs without words
pacifier_LDA <- LDA(pacifier_DTM.new, k = 2, control = list(alpha = 0.1))
pacifier_LDA


