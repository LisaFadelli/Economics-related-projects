import pandas as pd
url = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/rolling-averages/us-counties-2020.csv'
df = pd.read_csv(url)
df.to_csv('/Users/lisafadelli/Documents/HH/WISE21_22/UrbanEconomics/Paper/Contribution/OFFICIAL/RawData/' + 'covidcounties2020.csv')

url2 = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/rolling-averages/us-counties-2021.csv'
df2 = pd.read_csv(url2)
df2.to_csv('/Users/lisafadelli/Documents/HH/WISE21_22/UrbanEconomics/Paper/Contribution/OFFICIAL/RawData/' + 'covidcounties2021.csv')

url3 = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'
df3 = pd.read_csv(url3)
df3.to_csv('/Users/lisafadelli/Documents/HH/WISE21_22/UrbanEconomics/Paper/Contribution/OFFICIAL/RawData/' + 'covidcounties.csv')
