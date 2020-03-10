import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime

hair_dryer = pd.read_csv('hair_dryer.tsv', delimiter='\t',encoding='utf-8')
cleaned_hair_dryer = hair_dryer
cleaned_hair_dryer['verified_purchase'] = cleaned_hair_dryer['verified_purchase'].replace({'Y': 1, 'y': 1, 'N': 0, 'n': 0})
cleaned_hair_dryer['product_id'] = cleaned_hair_dryer['product_id'].str.upper()
cleaned_hair_dryer['year'] = pd.to_datetime(cleaned_hair_dryer['review_date'], "%m/%d/%Y").dt.to_period("Y")-2002
cleaned_hair_dryer.to_csv('cleaned_hair_dryer.tsv')

# hair_dryer_by_pid = hair_dryer.groupby(['product_id']).agg({'verified_purchase': 'count', 'star_rating': 'mean', 'helpful_votes': 'sum','review_body': 'count'})
# hair_dryer_by_pid.to_csv('hair_dryer_by_pid.csv')
# print(hair_dryer_by_pid.head())
# hair_dryer_by_year_pid = hair_dryer.groupby(['year', 'product_id']).agg({'verified_purchase': 'count','star_rating': 'mean', 'review_body': 'count'})
# hair_dryer_by_year_pid_vp = hair_dryer.groupby(['year', 'product_id', 'verified_purchase']).agg({'star_rating': 'mean', 'review_body': 'count'})
# hair_dryer_by_vp_pid = hair_dryer.groupby(['verified_purchase', 'product_id']).agg({'star_rating': 'mean', 'review_body': 'count'})
# print(hair_dryer_by_vp_pid)
# hair_dryer_by_pid.to_csv('')
# print(hair_dryer.groupby(['review_date', 'product_id']).count()['review_body'])
# print(hair_dryer.groupby(['review_date', 'product_id']).mean()['star_rating'])
# print(hair_dryer.groupby(['review_date', 'product_id']).mean()['star_rating'])

hair_dryer_sent = pd.read_csv('sentiment_hair_dryer_review.csv', delimiter=',',encoding='utf-8')
hair_dryer_by_year = hair_dryer_sent.groupby(['year']).agg({'verified_purchase': 'count','star_rating': 'mean', 'review_body': 'count', 'ave_sentiment': 'mean', 'word_count': 'mean'})
# print(hair_dryer_by_pid_by_year.head(10))
low_rate_hair_dryer_by_year = hair_dryer_by_year[hair_dryer_by_year['star_rating'] <= 2.5]
medium_rate_hair_dryer_by_year = hair_dryer_by_year[(hair_dryer_by_year['star_rating'] < 4) & (hair_dryer_by_year['star_rating'] > 2.5)]
high_rate_hair_dryer_by_year = hair_dryer_by_year[hair_dryer_by_year['star_rating'] >= 4]

# low_rate_hair_dryer_by_year.to_csv('low_rate_hair_dryer.csv')
# medium_rate_hair_dryer_by_year.to_csv('medium_rate_hair_dryer.csv')
# high_rate_hair_dryer_by_year.to_csv('high_rate_hair_dryer.csv')

hair_dryer_sent_by_pid_year = hair_dryer_sent.groupby(['product_id','year']).agg({'verified_purchase': 'count', 'star_rating': 'mean', 'helpful_votes': 'sum','review_body': 'count'})
# hair_dryer_sent_by_pid.to_csv('hair_dryer_by_pid.csv')
# print(hair_dryer_sent_by_pid_year.head(10))
low_rate_hair_dryer_by_pid_year = hair_dryer_sent_by_pid_year[hair_dryer_sent_by_pid_year['star_rating'] <= 2.5]
medium_rate_hair_dryer_by_pid_year = hair_dryer_sent_by_pid_year[(hair_dryer_sent_by_pid_year['star_rating'] < 4) & (hair_dryer_sent_by_pid_year['star_rating'] > 2.5)]
high_rate_hair_dryer_by_pid_year = hair_dryer_sent_by_pid_year[hair_dryer_sent_by_pid_year['star_rating'] >= 4]
print(low_rate_hair_dryer_by_pid_year.head(10))
low_rate_hair_dryer_by_year.to_csv('low_rate_hair_dryer_with_pid.csv')
medium_rate_hair_dryer_by_year.to_csv('medium_rate_hair_dryer_with_pid.csv')
high_rate_hair_dryer_by_year.to_csv('high_rate_hair_dryer_with_pid.csv')

# hair_dryer_sent_by_year_pid = hair_dryer_sent.groupby(['year', 'product_id']).agg({'verified_purchase': 'count','star_rating': 'mean', 'review_body': 'count'})
# hair_dryer_sent_by_year_pid_vp = hair_dryer_sent.groupby(['year', 'product_id', 'verified_purchase']).agg({'star_rating': 'mean', 'review_body': 'count'})
# hair_dryer_sent_by_vp_pid = hair_dryer_sent.groupby(['verified_purchase', 'product_id']).agg({'star_rating': 'mean', 'review_body': 'count'})