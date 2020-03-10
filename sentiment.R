library(ggplot2)
library(tidyverse)
library(dplyr)
library(tm)
library(tidytext)
library(qdap)
library('sentimentr')

cleaned_pacifier <- read.csv("Problem_C_Data/cleaned_pacifier.tsv")
cleaned_microwave <- read.csv("Problem_C_Data/cleaned_microwave.tsv")
cleaned_hair_dryer <- read.csv("Problem_C_Data/cleaned_hair_dryer.tsv")

mean(cleaned_microwave$helpful_votes)
median(nchar(as.character(cleaned_microwave$review_body)))
refined_pacifier <- filter(cleaned_pacifier, nchar(as.character(review_body))>=50, as.numeric(helpful_votes/total_votes) > 0.98, as.numeric(helpful_votes) >= 1)
refined_microwave <- filter(cleaned_microwave, nchar(as.character(review_body))>=50, as.numeric(helpful_votes/total_votes) > 0.98, as.numeric(helpful_votes) >= 1)
refined_hair_dryer <- filter(cleaned_hair_dryer, nchar(as.character(review_body))>=50, as.numeric(helpful_votes/total_votes) > 0.98, as.numeric(helpful_votes) >= 1)

cleaned_pacifier_review <- cleaned_pacifier %>% select(product_id, review_body) %>% rename(doc_id=product_id,text=review_body)
cleaned_microwave_review <- cleaned_microwave %>% select(product_id, review_body) %>% rename(doc_id=product_id,text=review_body)
cleaned_hair_dryer_review <- cleaned_hair_dryer %>% select(product_id, review_body) %>% rename(doc_id=product_id,text=review_body)

### Finding product features based on frequency of most common words
### Remove all generic descriptions, may add/remove some descriptions
### Consider only single word frequency
pacifier_text_df <- tibble(line=1:18939, text=as.character(cleaned_pacifier_review$text))

pacifier_text_freq <- (pacifier_text_df %>% unnest_tokens(word, text) %>% anti_join(stop_words) %>% count(word, sort=TRUE) 
%>% filter(word!='pacifier', word!='pacifiers', word!='product',word!= 'baby',word!= 'love',
           word!= 'loves',word!= 'bought',word!= '2',word!= '34',word!='recommend',
           word!='perfect',word!='nice',word!='3',word!='month',word!='months',word!='buy',
           word!='br',word!='perfect',word!='quality',word!='mouth'))
pacifier_text_freq[1:20,]
microwave_text_df <- tibble(line=1:1615, text=as.character(cleaned_microwave_review$text))
microwave_text_freq <- (microwave_text_df %>% unnest_tokens(word, text) %>% anti_join(stop_words) %>% count(word, sort=TRUE) 
  %>% filter(word!='microwave', word!='microwaves', word!='product',word!= 'baby',word!= 'love',
             word!= 'loves',word!= 'bought',word!='perfect',word!='ge',word!='nice',
             word!= '2',word!= '34',word!='recommend',word!='br',word!='buy',word!='model'
             ))
microwave_text_freq[1:20,]
hair_dryer_text_df <- tibble(line=1:11470, text=as.character(cleaned_hair_dryer_review$text))
hair_dryer_text_freq <- (hair_dryer_text_df %>% unnest_tokens(word, text) %>% anti_join(stop_words) %>% count(word, sort=TRUE) 
  %>% filter(word!='hair',word!='dryer',word!='dry',word!='drying',word!='dries',
             word!='hairdryer', word!='product',word!= 'baby',word!= 'love',
             word!= 'loves',word!= 'bought',word!='perfect',word!='ge',word!='nice',
             word!= '2',word!= '34',word!='recommend',word!='br',word!='buy',word!='month',
             word!='months',word!='buy',word!='br',word!='perfect',word!='quality'
  ))
hair_dryer_text_freq[1:20,]

microwave_text_df <- tibble(line=1:1615, text=as.character(cleaned_microwave_review$text))
microwave_text_freq <- (microwave_text_df %>% unnest_tokens(word, text) %>% anti_join(stop_words) %>% count(word, sort=TRUE) 
                        %>% filter(word!='microwave', word!='microwaves', word!='product',word!= 'baby',word!= 'love',
                                   word!= 'loves',word!= 'bought',word!='perfect',word!='ge',word!='nice',
                                   word!= '2',word!= '34',word!='recommend',word!='br',word!='buy',word!='model'
                        ))
microwave_text_freq[1:20,]
hair_dryer_text_df <- tibble(line=1:11470, text=as.character(cleaned_hair_dryer_review$text))
hair_dryer_text_freq <- (hair_dryer_text_df %>% unnest_tokens(word, text) %>% anti_join(stop_words) %>% count(word, sort=TRUE) 
                         %>% filter(word!='hair',word!='dryer',word!='dry',word!='drying',word!='dries',
                                    word!='hairdryer', word!='product',word!= 'baby',word!= 'love',
                                    word!= 'loves',word!= 'bought',word!='perfect',word!='ge',word!='nice',
                                    word!= '2',word!= '34',word!='recommend',word!='br',word!='buy',word!='month',
                                    word!='months',word!='buy',word!='br',word!='perfect',word!='quality'
                         ))
hair_dryer_text_freq[1:20,]

### Consider bigram
bi_pacifier_text_freq <- (pacifier_text_df %>% unnest_tokens(bigram, text, token='ngrams', n=2) 
                          %>% separate(bigram, c("word1", "word2"), sep = " ") 
                          %>% filter(!word1 %in% stop_words$word) 
                          %>% filter(!word2 %in% stop_words$word) 
                          %>% count(word1, word2, sort=TRUE) 
                          %>% filter(!word1 %in% c('pacifier', 'pacifiers','product','baby','love',
                                                   'loves','bought','recommend','perfect','nice','buy','br','perfect','quality','mouth'))
                          %>% filter(!word2 %in% c('pacifier', 'pacifiers','product','baby','love',
                                                   'loves','bought','recommend','2','month','months','perfect','nice','buy','br','perfect','quality','mouth')))
bi_pacifier_text_freq[1:20,]

### Consider bigram
bi_microwave_text_freq <- (microwave_text_df %>% unnest_tokens(bigram, text, token='ngrams', n=2) 
                          %>% separate(bigram, c("word1", "word2"), sep = " ") 
                          %>% filter(!word1 %in% stop_words$word) 
                          %>% filter(!word2 %in% stop_words$word) 
                          %>% count(word1, word2, sort=TRUE)
                          %>% filter(!word1 %in% c('microwave', 'microwaves','product','baby','love',
                                                   'loves','bought','recommend','perfect','nice','buy',
                                                   'br','perfect','quality'))
                          %>% filter(!word2 %in% c('microwave', 'microwaves','product','baby','love',
                                                   'loves','bought','recommend','2','month','months',
                                                   'perfect','nice','buy','br','perfect','quality')))
bi_microwave_text_freq[1:20,]

### Consider bigram
bi_hair_dryer_text_freq <- (hair_dryer_text_df %>% unnest_tokens(bigram, text, token='ngrams', n=2) 
                          %>% separate(bigram, c("word1", "word2"), sep = " ") 
                          %>% filter(!word1 %in% stop_words$word) 
                          %>% filter(!word2 %in% stop_words$word) 
                          %>% count(word1, word2, sort=TRUE)
                          %>% filter(!word1 %in% c('hair', 'dryer','product','love',
                                                   'loves','bought','recommend','perfect',
                                                   'nice','buy','br','perfect','quality'))
                          %>% filter(!word2 %in% c('hair', 'dryer','product','baby','love',
                                                   'loves','bought','recommend','2','month','months',
                                                   'perfect','nice','buy','br','perfect','quality','mouth')))
bi_hair_dryer_text_freq[1:20,]

sentiment_pacifier_review <- cbind(cleaned_pacifier, sentiment_by(get_sentences(as.character(cleaned_pacifier_review$text))))
sentiment_microwave_review <- cbind(cleaned_microwave, sentiment_by(get_sentences(as.character(cleaned_microwave_review$text))))
sentiment_hair_dryer_review <- cbind(cleaned_hair_dryer, sentiment_by(get_sentences(as.character(cleaned_hair_dryer_review$text))))

refined_sentiment_pacifier_review <- filter(sentiment_pacifier_review, nchar(as.character(review_body))>=50, as.numeric(helpful_votes/total_votes) > 0.98, as.numeric(helpful_votes) >= 1)
refined_sentiment_microwave_review <- filter(sentiment_microwave_review, nchar(as.character(review_body))>=50, as.numeric(helpful_votes/total_votes) > 0.98, as.numeric(helpful_votes) >= 1)
refined_sentiment_hair_dryer_review <- filter(sentiment_hair_dryer_review, nchar(as.character(review_body))>=50, as.numeric(helpful_votes/total_votes) > 0.98, as.numeric(helpful_votes) >= 1)

#refined_sentiment_pacifier_review %>% 
#sentiment_pacifier_review_file <- write.csv(sentiment_pacifier_review,"Problem_C_Data/sentiment_pacifier_review.csv", row.names = FALSE)
#sentiment_microwave_review_file <- write.csv(sentiment_microwave_review,"Problem_C_Data/sentiment_microwave_review.csv", row.names = FALSE)
#sentiment_hair_dryer_review_file <- write.csv(sentiment_hair_dryer_review,"Problem_C_Data/sentiment_hair_dryer_review.csv", row.names = FALSE)

  ### pacifier models
logReg_P1 <- glm(data=refined_sentiment_pacifier_review, verified_purchase~log(helpful_votes)+star_rating+year,family=binomial(link="logit"))
summary(logReg_P1)
## predict(logReg1, type="response")
(ggplot(data=refined_sentiment_pacifier_review, aes(x = log(helpful_votes)+star_rating+year, y=verified_purchase))+geom_point()
  +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = TRUE))

1-pchisq(2321.8, 2143)
1-pchisq(2041.9, 2143)

logReg_P2 <- glm(data=refined_sentiment_pacifier_review, verified_purchase~log(helpful_votes)+year,family=binomial(link="logit"))
summary(logReg_P2)
## predict(logReg1, type="response")
(ggplot(data=refined_sentiment_pacifier_review, aes(x = log(helpful_votes)+year, y=verified_purchase))+geom_point()
  +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = FALSE))

logReg_P3 <- glm(data=refined_sentiment_pacifier_review, verified_purchase~star_rating+year,family=binomial(link="logit"))
summary(logReg_P3)
(ggplot(data=refined_sentiment_pacifier_review, aes(x = star_rating+year, y=verified_purchase))+geom_point()
  +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = FALSE))

logReg_P4 <- glm(data=refined_pacifier, verified_purchase~year,family=binomial(link="logit"))
summary(logReg_P4)
(ggplot(data=refined_pacifier, aes(x = year, y=verified_purchase))+geom_point()
  +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = FALSE))

### pacifier models
logReg_P5 <- glm(data=refined_sentiment_hair_dryer_review, verified_purchase~log(helpful_votes)+(star_rating)+year+exp(ave_sentiment),family=binomial(link="logit"))
summary(logReg_P5)
## predict(logReg1, type="response")
(ggplot(data=refined_sentiment_pacifier_review, aes(x = log(helpful_votes)+star_rating+year+exp(ave_sentiment), y=verified_purchase))+geom_point()
  +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = TRUE))

logReg_P6 <- glm(data=refined_sentiment_hair_dryer_review, verified_purchase~log(helpful_votes)+year+exp(ave_sentiment),family=binomial(link="logit"))
summary(logReg_P6)
## predict(logReg1, type="response")

pa <- (ggplot(data=refined_sentiment_pacifier_review, aes(x = log(helpful_votes)+year+star_rating+exp(ave_sentiment), y=verified_purchase))+geom_point()
  +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = TRUE))
mi <- (ggplot(data=refined_sentiment_microwave_review, aes(x = log(helpful_votes)+year+star_rating+exp(ave_sentiment), y=verified_purchase))+geom_point()
       +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = TRUE))
hd <- (ggplot(data=refined_sentiment_hair_dryer_review, aes(x = log(helpful_votes)+year+star_rating+exp(ave_sentiment), y=verified_purchase))+geom_point()
       +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = TRUE))
pa
mi
hd

logReg_P7 <- glm(data=refined_sentiment_pacifier_review, verified_purchase~year+exp(ave_sentiment),family=binomial(link="logit"))
summary(logReg_P7)
## predict(logReg1, type="response")
(ggplot(data=refined_sentiment_pacifier_review, aes(x = year+exp(ave_sentiment), y=verified_purchase))+geom_point()
  +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = TRUE))

