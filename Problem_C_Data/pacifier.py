import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime

pacifier = pd.read_csv('pacifier.tsv', delimiter='\t',encoding='utf-8')
cleaned_pacifier = pacifier
cleaned_pacifier['verified_purchase'] = cleaned_pacifier['verified_purchase'].replace({'Y': 1, 'y': 1, 'N': 0, 'n': 0})
cleaned_pacifier['product_id'] = cleaned_pacifier['product_id'].str.upper()
cleaned_pacifier['year'] = pd.to_datetime(cleaned_pacifier['review_date'], "%m/%d/%Y").dt.to_period("Y")-2002
cleaned_pacifier.to_csv('cleaned_pacifier.tsv')

# pacifier_by_pid = pacifier.groupby(['product_id']).agg({'verified_purchase': 'count', 'star_rating': 'mean', 'helpful_votes': 'sum','review_body': 'count'})
# pacifier_by_pid.to_csv('pacifier_by_pid.csv')
# print(pacifier_by_pid.head())
# pacifier_by_year_pid = pacifier.groupby(['year', 'product_id']).agg({'verified_purchase': 'count','star_rating': 'mean', 'review_body': 'count'})
# pacifier_by_year_pid_vp = pacifier.groupby(['year', 'product_id', 'verified_purchase']).agg({'star_rating': 'mean', 'review_body': 'count'})
# pacifier_by_vp_pid = pacifier.groupby(['verified_purchase', 'product_id']).agg({'star_rating': 'mean', 'review_body': 'count'})
# print(pacifier_by_vp_pid)
# pacifier_by_pid.to_csv('')
# print(pacifier.groupby(['review_date', 'product_id']).count()['review_body'])
# print(pacifier.groupby(['review_date', 'product_id']).mean()['star_rating'])
# print(pacifier.groupby(['review_date', 'product_id']).mean()['star_rating'])

pacifier_sent = pd.read_csv('sentiment_pacifier_review.csv', delimiter=',',encoding='utf-8')
pacifier_by_year = pacifier_sent.groupby(['year']).agg({'verified_purchase': 'count','star_rating': 'mean', 'review_body': 'count', 'ave_sentiment': 'mean', 'word_count': 'mean'})
# print(pacifier_by_pid_by_year.head(10))
low_rate_pacifier_by_year = pacifier_by_year[pacifier_by_year['star_rating'] <= 2.5]
medium_rate_pacifier_by_year = pacifier_by_year[(pacifier_by_year['star_rating'] < 4) & (pacifier_by_year['star_rating'] > 2.5)]
high_rate_pacifier_by_year = pacifier_by_year[pacifier_by_year['star_rating'] >= 4]

# low_rate_pacifier_by_year.to_csv('low_rate_pacifier.csv')
# medium_rate_pacifier_by_year.to_csv('medium_rate_pacifier.csv')
# high_rate_pacifier_by_year.to_csv('high_rate_pacifier.csv')

pacifier_sent_by_pid_year = pacifier_sent.groupby(['product_id','year']).agg({'verified_purchase': 'count', 'star_rating': 'mean', 'helpful_votes': 'sum','review_body': 'count'})
# pacifier_sent_by_pid.to_csv('pacifier_by_pid.csv')
# print(pacifier_sent_by_pid_year.head(10))
low_rate_pacifier_by_pid_year = pacifier_sent_by_pid_year[pacifier_sent_by_pid_year['star_rating'] <= 2.5]
medium_rate_pacifier_by_pid_year = pacifier_sent_by_pid_year[(pacifier_sent_by_pid_year['star_rating'] < 4) & (pacifier_sent_by_pid_year['star_rating'] > 2.5)]
high_rate_pacifier_by_pid_year = pacifier_sent_by_pid_year[pacifier_sent_by_pid_year['star_rating'] >= 4]
print(low_rate_pacifier_by_pid_year.head(30))
low_rate_pacifier_by_year.to_csv('low_rate_pacifier_with_pid.csv')
medium_rate_pacifier_by_year.to_csv('medium_rate_pacifier_with_pid.csv')
high_rate_pacifier_by_year.to_csv('high_rate_pacifier_with_pid.csv')

# pacifier_sent_by_year_pid = pacifier_sent.groupby(['year', 'product_id']).agg({'verified_purchase': 'count','star_rating': 'mean', 'review_body': 'count'})
# pacifier_sent_by_year_pid_vp = pacifier_sent.groupby(['year', 'product_id', 'verified_purchase']).agg({'star_rating': 'mean', 'review_body': 'count'})
# pacifier_sent_by_vp_pid = pacifier_sent.groupby(['verified_purchase', 'product_id']).agg({'star_rating': 'mean', 'review_body': 'count'})