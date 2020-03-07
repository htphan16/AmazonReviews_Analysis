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
cleaner_pacified_corpus <- function(cleaned_pacifier_corpus) {
  # Remove punctuation
  cleaned_pacifier_corpus <- tm_map(cleaned_pacifier_corpus, removePunctuation)
  # Transform to lower case
  cleaned_pacifier_corpus <- tm_map(cleaned_pacifier_corpus, tolower)
  # Add more stopwords
  cleaned_pacifier_corpus <- tm_map(cleaned_pacifier_corpus, removeWords, words = c(stopwords("en"), "coffee"))
  # Strip whitespace
  cleaned_pacifier_corpus <- tm_map(cleaned_pacifier_corpus, replace_contraction)
  return(cleaned_pacifier_corpus)
}
tolower(cleaned_pacifier_corpus)
cleaned_pacifier_corpus %>% unnest_tokens('review_word', text)
negative_feelings <- 












### pacifier models
logReg_P1 <- glm(data=refined_pacifier, verified_purchase~log(helpful_votes)+star_rating+year,family=binomial(link="logit"))
summary(logReg_P1)
## predict(logReg1, type="response")
(ggplot(data=refined_pacifier, aes(x = log(helpful_votes)+star_rating+year, y=verified_purchase))+geom_point()
  +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = FALSE))

logReg_P2 <- glm(data=refined_pacifier, verified_purchase~log(helpful_votes)+year,family=binomial(link="logit"))
summary(logReg_P2)
## predict(logReg1, type="response")
(ggplot(data=refined_pacifier, aes(x = log(helpful_votes)+year, y=verified_purchase))+geom_point()
  +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = FALSE))

logReg_P3 <- glm(data=refined_pacifier, verified_purchase~star_rating+year,family=binomial(link="logit"))
summary(logReg_P3)
(ggplot(data=refined_pacifier, aes(x = star_rating+year, y=verified_purchase))+geom_point()
+geom_smooth(method = "glm", method.args = list(family = "binomial"),se = FALSE))

logReg_P4 <- glm(data=refined_pacifier, verified_purchase~year,family=binomial(link="logit"))
summary(logReg_P4)
(ggplot(data=refined_pacifier, aes(x = year, y=verified_purchase))+geom_point()
  +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = FALSE))

### microwave models
logReg_m1 <- glm(data=refined_microwave, verified_purchase~log(helpful_votes)+star_rating+year,family=binomial(link="logit"))
summary(logReg_m1)
predict(logReg_m1, type="response")
(ggplot(data=refined_microwave, aes(x = log(helpful_votes)+star_rating+year, y=verified_purchase))+geom_point()
  +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = FALSE))

logReg_m2 <- glm(data=refined_microwave, verified_purchase~log(helpful_votes)+star_rating,family=binomial(link="logit"))
summary(logReg_m2)
predict(logReg_m2, type="response")
(ggplot(data=refined_microwave, aes(x = log(helpful_votes)+star_rating, y=verified_purchase))+geom_point()
  +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = FALSE))

logReg_m3 <- glm(data=refined_microwave, verified_purchase~star_rating+year,family=binomial(link="logit"))
summary(logReg_m3)
predict(logReg_m3, type="response")
(ggplot(data=refined_microwave, aes(x = star_rating+year, y=verified_purchase))+geom_point()
  +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = FALSE))


