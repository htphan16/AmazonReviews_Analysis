library(ggplot2)
library(tidyverse)
library(dplyr)
library(tm)
library(tidytext)
library(qdap)
library(topicmodels)
library(broom)

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
  # Remove punctuation
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, PlainTextDocument)
  # Transform to lower case
  corpus <- tm_map(corpus, content_transformer(tolower))
  # Add more stopwords
  corpus <- tm_map(corpus, removeWords, words = c(stopwords("en"),'microwave','ge','loved','pacifier','pacifiers','product','baby','love',
                                                  'hair','dryer','dry','drying','dries',
                                                  'hairdryer','loves','bought','2','34','recommend',
                                                  'perfect','nice','3','month','months','buy',
                                                  'br','perfect','mouth','babies','buying'))
  # Strip whitespace
  corpus <- tm_map(corpus, stripWhitespace)
  # Remove numbers
  corpus <- tm_map(corpus, removeNumbers)
  return(corpus)
}

cleaned_microwave_review <- cleaned_microwave %>% rename(doc_id=product_id,text=review_body)
head(cleaned_microwave_review)

cleaned_microwave_corpus <- VCorpus(DataframeSource(cleaned_microwave_review))
cleaned_microwave_corpus

cleaner_microwave_corp <- cleaner_pacifier_corpus(cleaned_microwave_corpus)
microwave_DTM <- DocumentTermMatrix(cleaner_microwave_corp)
microwave_m <- as.matrix(microwave_DTM)
#microwave_TDM <- TermDocumentMatrix(cleaner_microwave_corp)
rowTotals <- apply(microwave_DTM , 1, sum) #Find the sum of words in each Document
microwave_DTM.new <- microwave_DTM[rowTotals> 0, ]           #remove all docs without words
microwave_DTM.new
microwave_LDA <- LDA(microwave_DTM.new, k = 20, control = list(seed=1234))

library(tidytext)
microwave_topics <- tidy(microwave_LDA, matrix = "beta")
microwave_topics
top_microwave_topics <- (microwave_topics %>% group_by(topic)
                        %>% top_n(50, beta) %>% ungroup() %>% arrange(topic, -beta)
                        %>% filter(!term %in% stop_words$word) 
                        %>% filter(term!='microwave',term!='hair',term!='loved',term!='dry',term!='drying',term!='dryer',term!='dryers',
                                   term!='pacifier',term!='pacifiers', term!='product',term!= 'baby',term!= 'love',
                                   term!= 'loves',term!= 'bought',term!= '2',term!= '34',term!='recommend',
                                   term!='perfect',term!='nice',term!='3',term!='month',term!='months',term!='buy',
                                   term!='br',term!='perfect',term!='mouth',term!='babies',term!='buying'))

top_microwave_topics

top_microwave_terms <- top_microwave_topics %>%
  group_by(topic) %>%
  top_n(7, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

top_microwave_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  scale_x_reordered()

gamma_terms <- top_hair_dryer_terms %>%
  group_by(topic) %>%
  summarise(gamma = mean(gamma)) %>%
  arrange(desc(gamma)) %>%
  left_join(top_hair_dryer_terms, by = "topic") %>%
  mutate(topic = paste0("Topic ", topic),
         topic = reorder(topic, gamma))

gamma_terms %>% 
  top_n(20, gamma) %>%
  ggplot(aes(topic, gamma, fill = topic)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  scale_y_continuous(expand = c(0,0),
                     limits = c(0, 0.09)) +
  labs(x = NULL, y = expression(gamma),
       title = "Top 20 topics by prevalence in the hair dryer corpus",
       subtitle = "With the top words that contribute to each topic")

beta_spread <- top_hair_dryer_topics %>%
  mutate(topic = paste0("topic", topic)) %>%
  spread(topic, beta) %>%
  filter(topic1 > .001 | topic2 > .001) %>%
  #filter(topic2 != NA,topic1 != NA) %>%
  mutate(log_ratio = log2(topic2 / topic1))

beta_spread


