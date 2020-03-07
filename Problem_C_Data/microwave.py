import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime

microwave = pd.read_csv('microwave.tsv', delimiter='\t',encoding='utf-8')
cleaned_microwave = microwave
cleaned_microwave['verified_purchase'] = cleaned_microwave['verified_purchase'].replace({'Y': 1, 'y': 1, 'N': 0, 'n': 0})
cleaned_microwave['product_id'] = cleaned_microwave['product_id'].str.upper()
cleaned_microwave['year'] = pd.to_datetime(cleaned_microwave['review_date'], "%m/%d/%Y").dt.to_period("Y")-2003
cleaned_microwave.to_csv('cleaned_microwave.tsv')

microwave_by_pid = microwave.groupby(['product_id']).agg({'verified_purchase': 'count', 'star_rating': 'mean', 'helpful_votes': 'sum','review_body': 'count'})
microwave_by_pid.to_csv('microwave_by_pid.csv')
print(microwave_by_pid.head())
microwave_by_year_pid = microwave.groupby(['year', 'product_id']).agg({'verified_purchase': 'count','star_rating': 'mean', 'review_body': 'count'})
microwave_by_year_pid_vp = microwave.groupby(['year', 'product_id', 'verified_purchase']).agg({'star_rating': 'mean', 'review_body': 'count'})
microwave_by_vp_pid = microwave.groupby(['verified_purchase', 'product_id']).agg({'star_rating': 'mean', 'review_body': 'count'})
# print(microwave_by_vp_pid)
# microwave_by_pid.to_csv('')
# print(microwave.groupby(['review_date', 'product_id']).count()['review_body'])
# print(hair_dryer.groupby(['review_date', 'product_id']).mean()['star_rating'])
# print(microwave.groupby(['review_date', 'product_id']).mean()['star_rating'])