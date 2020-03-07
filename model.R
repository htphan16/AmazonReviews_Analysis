cleaned_pacifier <- read.csv("Problem_C_Data/cleaned_pacifier.tsv")
cleaned_microwave <- read.csv("Problem_C_Data/cleaned_microwave.tsv")
cleaned_hair_dryer <- read.csv("Problem_C_Data/cleaned_hair_dryer.tsv")

library(ggplot2)
library(tidyverse)
library(dplyr)

mean(cleaned_microwave$helpful_votes)
median(nchar(as.character(cleaned_microwave$review_body)))
refined_pacifier <- filter(cleaned_pacifier, nchar(as.character(review_body))>=100, as.numeric(helpful_votes/total_votes) > 0.98, as.numeric(helpful_votes) >= 1)
refined_microwave <- filter(cleaned_microwave, nchar(as.character(review_body))>=100, as.numeric(helpful_votes/total_votes) > 0.98, as.numeric(helpful_votes) >= 1)

### pacifier models
logReg_P1 <- glm(data=refined_pacifier, verified_purchase~log(helpful_votes)+star_rating+year,family=binomial(link="logit"))
summary(logReg_P1)
## predict(logReg1, type="response")
(ggplot(data=refined_pacifier, aes(x = log(helpful_votes)+star_rating+year, y=verified_purchase))+geom_point()
  +geom_smooth(method = "glm", method.args = list(family = "binomial"),se = TRUE))

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


