pacifier <- read.delim("Problem_C_Data/pacifier.tsv")
microwave <- read.delim("Problem_C_Data/microwave.tsv")
hair_dryer <- read.delim2("Problem_C_Data/hair_dryer.tsv")

library(ggplot2)
library(tidyverse)
library(dplyr)

refined_pacifier <- filter(pacifier, as.numeric(helpful_votes/total_votes) > 0.9, as.numeric(helpful_votes) > 20)
pacifier %>% group_by(product = product_id) %>% summarize(mean_star_rating=mean(star_rating, na.rm=TRUE))
ggplot(refined_pacifier, aes(x=factor(star_rating), helpful_votes))+geom_boxplot()

ggplot(pacifier, aes(star_rating, fill=toupper(verified_purchase)))+geom_bar(position='dodge')
ggplot(refined_pacifier, aes(x=as.Date(refined_pacifier$review_date, format="%m/%d/%Y"), y=star_rating))+geom_line()+scale_x_date(date_labels = "%Y")
ggplot(refined_pacifier, aes(x=as.Date(refined_pacifier$review_date, format="%m/%d/%Y"), y=helpful_votes))+geom_line()+scale_x_date(date_labels = "%Y")
ggplot(pacifier, aes(x=as.Date(pacifier$review_date, format="%m/%d/%Y"), y=helpful_votes))+geom_line()+scale_x_date(date_labels = "%Y")
ggplot(refined_pacifier, aes(toupper(verified_purchase), helpful_votes))+geom_boxplot()