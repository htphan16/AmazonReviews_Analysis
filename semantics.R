library(ggplot2)
library(tidyverse)
library(dplyr)
library(tm)
library(tidytext)
library(qdap)

cleaned_pacifier <- read.csv("Problem_C_Data/cleaned_pacifier.tsv")
cleaned_microwave <- read.csv("Problem_C_Data/cleaned_microwave.tsv")
cleaned_hair_dryer <- read.csv("Problem_C_Data/cleaned_hair_dryer.tsv")

mean(cleaned_microwave$helpful_votes)
median(nchar(as.character(cleaned_microwave$review_body)))
refined_pacifier <- filter(cleaned_pacifier, nchar(as.character(review_body))>=150, as.numeric(helpful_votes/total_votes) > 0.98, as.numeric(helpful_votes) >= 1)
refined_microwave <- filter(cleaned_microwave, nchar(as.character(review_body))>=150, as.numeric(helpful_votes/total_votes) > 0.95, as.numeric(helpful_votes) >= 1)

cleaned_pacifier_review <- cleaned_pacifier %>% select(product_id, review_body) %>% rename(doc_id=product_id,text=review_body)
head(cleaned_pacifier_review)

cleaned_pacifier_corpus <- VCorpus(VectorSource(cleaned_pacifier$review_body))
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
cleaner_pacified_corpus <- function(corpus) {
  # Replace contraction
  corpus <- tm_map(corpus, replace_contraction)
  # Remove punctuation
  corpus <- tm_map(corpus, removePunctuation)
  # Transform to lower case
  corpus <- tm_map(corpus, tolower)
  # Add more stopwords
  corpus <- tm_map(corpus, removeWords, words = c(stopwords("en")))
  # Strip whitespace
  corpus <- tm_map(corpus, replace_contraction)
  return(corpus)
}

cleaner_pacified_corp <- cleaner_pacified_corpus(cleaned_pacifier_corpus)
content(cleaner_pacified_corp[2])
pacified_DTM <- DocumentTermMatrix()

