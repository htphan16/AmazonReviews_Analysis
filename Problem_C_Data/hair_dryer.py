import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime

hair_dryer = pd.read_csv('hair_dryer.tsv', delimiter='\t',encoding='utf-8')
cleaned_hair_dryer = hair_dryer
cleaned_hair_dryer['verified_purchase'] = cleaned_hair_dryer['verified_purchase'].replace({'Y': 1, 'y': 1, 'N': 0, 'n': 0})
cleaned_hair_dryer['product_id'] = cleaned_hair_dryer['product_id'].str.upper()
cleaned_hair_dryer['month'] = pd.to_datetime(cleaned_hair_dryer['review_date'], "%m/%d/%Y").dt.to_period("Y")-2003
cleaned_hair_dryer.to_csv('cleaned_hair_dryer.csv', sep='\t')

hair_dryer_by_pid = hair_dryer.groupby(['product_id']).agg({'verified_purchase': 'count', 'star_rating': 'mean', 'helpful_votes': 'sum','review_body': 'count'})
hair_dryer_by_pid.to_csv('hair_dryer_by_pid.csv')
print(hair_dryer_by_pid.head())
hair_dryer_by_month_pid = hair_dryer.groupby(['month', 'product_id']).agg({'verified_purchase': 'count','star_rating': 'mean', 'review_body': 'count'})
hair_dryer_by_month_pid_vp = hair_dryer.groupby(['month', 'product_id', 'verified_purchase']).agg({'star_rating': 'mean', 'review_body': 'count'})
hair_dryer_by_vp_pid = hair_dryer.groupby(['verified_purchase', 'product_id']).agg({'star_rating': 'mean', 'review_body': 'count'})
# print(hair_dryer_by_vp_pid)
# hair_dryer_by_pid.to_csv('')
# print(hair_dryer.groupby(['review_date', 'product_id']).count()['review_body'])
# print(hair_dryer.groupby(['review_date', 'product_id']).mean()['star_rating'])
# print(hair_dryer.groupby(['review_date', 'product_id']).mean()['star_rating'])