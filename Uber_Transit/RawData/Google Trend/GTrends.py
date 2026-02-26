import pandas as pd
import time
import pytrends
from pytrends.request import TrendReq
pytrends = TrendReq(hl='en-US', tz=0, retries=10)
keywords =['Uber']
keywords.sort()
df = pd.read_excel('idmetro.xls')
geo = df["ID_MSA"].astype(str)
wait = 2
print('Number of queries to do: ', len(keywords) * len(geo))
folder_to_export_path = '/Users/lisafadelli/Documents/HH/WISE21_22/UrbanEconomics/Paper/Contribution/OFFICIAL/RawData/Google Trend/CSV/'

for ID_MSA in geo:
    try:
        pytrends.build_payload(kw_list=keywords , 
                               timeframe='2020-03-01 2021-08-31', 
                               geo=ID_MSA, gprop='')
        final = pytrends.interest_over_time()
        final.rename(columns={ID_MSA: "Uber"}, inplace=True)
        final.drop(labels=['isPartial'],axis='columns', inplace=True)
        final[ID_MSA]=ID_MSA
        final.rename(columns={ID_MSA: "metroid"}, inplace=True)
        final.to_csv(folder_to_export_path+ID_MSA+'GTrends.csv')
        
        print(ID_MSA 
              + ' was succesfully pulled from google trends and stored in ' 
              + ID_MSA + 'GTrends.csv')
    except Exception as e:
        print(ID_MSA 
              + ' was not successfully pulled because of the following error: ' 
              + str(e))
    continue


import glob
import os
joined_files = os.path.join(folder_to_export_path+'/*.csv')
joined_list = glob.glob(joined_files)
GTrend = pd.concat(map(pd.read_csv, joined_list), ignore_index=True)
GTrend.to_csv(folder_to_export_path+'GTrendslong.csv')



