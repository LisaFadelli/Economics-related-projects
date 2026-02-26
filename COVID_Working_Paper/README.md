# THE EFFECT OF WEARING MASK TO PROTECT THEMSELVES FROM THE COVID-19 INFECTION ON THE 7-DAY INCIDENCE RATE: EVIDENCE FROM ARKANSAS STATE 
 
##### SUBMISSION DATE:
31.08.2021 

---

The folder contains: 
- Ado Files ( it includes all packages needed)
- Do file (0_master, 1_pull_data, 2_analysis)
- Raw Data

## DATASET 
- "United_States_COVID-19_Cases_and_Deaths_by_State_over_Time.csv" contains all the data about new daily cases for each state from mid-January 2020 to mid-August 2021 available from www.cdc.gov
- "generalinfo.csv" contains socio-demographic data, health conditions information, for each state of the USA downloaded from [www.cdc.gov](www.cdc.gov), [www.cdc.gov/brfss/data_tools](www.cdc.gov/brfss/data_tools) and [www.census.gov/library/visualizations/interactive/2020-population-and-housing-state-data](www.census.gov/library/visualizations/interactive/2020-population-and-housing-state-data)
- "incidence_every100000.csv" contains the data about the 7-day moving average 

## SOFTWARE REQUIREMENT: 
Stata version 16.1 or higher

## INSTRUCTION:  
Download the folder, open the:  
*“0_master.do”* runs all the do files included in the folder 
In order to replicate the do-file, at line 5, change the global macro MY_PATH adding the real path name where the folder has been saved  

*“1_pull_data.do”* pulls and transforms the data, obtaining the datasets and variables to use  

*“2_analysis”* executes the analysis 

