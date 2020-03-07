import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime

pacifier = pd.read_csv('pacifier.tsv', delimiter='\t',encoding='utf-8')
cleaned_pacifier = pacifier
cleaned_pacifier['verified_purchase'] = cleaned_pacifier['verified_purchase'].replace({'Y': 1, 'y': 1, 'N': 0, 'n': 0})
cleaned_pacifier['product_id'] = cleaned_pacifier['product_id'].str.upper()
cleaned_pacifier['year'] = pd.to_datetime(cleaned_pacifier['review_date'], "%m/%d/%Y").dt.to_period("Y")-2003
cleaned_pacifier.to_csv('cleaned_pacifier.tsv')

pacifier_by_pid = pacifier.groupby(['product_id']).agg({'verified_purchase': 'count', 'star_rating': 'mean', 'helpful_votes': 'sum','review_body': 'count'})
pacifier_by_pid.to_csv('pacifier_by_pid.csv')
print(pacifier_by_pid.head())
pacifier_by_year_pid = pacifier.groupby(['year', 'product_id']).agg({'verified_purchase': 'count','star_rating': 'mean', 'review_body': 'count'})
pacifier_by_year_pid_vp = pacifier.groupby(['year', 'product_id', 'verified_purchase']).agg({'star_rating': 'mean', 'review_body': 'count'})
pacifier_by_vp_pid = pacifier.groupby(['verified_purchase', 'product_id']).agg({'star_rating': 'mean', 'review_body': 'count'})
# print(pacifier_by_vp_pid)
# pacifier_by_pid.to_csv('')
# print(pacifier.groupby(['review_date', 'product_id']).count()['review_body'])
# print(hair_dryer.groupby(['review_date', 'product_id']).mean()['star_rating'])
# print(microwave.groupby(['review_date', 'product_id']).mean()['star_rating'])