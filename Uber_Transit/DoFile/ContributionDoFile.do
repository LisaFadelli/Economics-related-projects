**ContributionDoFile
**Last Update: 20 Jan 

global MY_PATH "/Users/lisafadelli/Documents/HH/WISE21_22/UrbanEconomics/Paper/Contribution/ContributionPackage_LisaFadelli"

** create new subfolders
cap mkdir "$MY_PATH/RawData"
cap mkdir "$MY_PATH/InputData"
cap mkdir "$MY_PATH/OutputData"
cap mkdir "$MY_PATH/DoFile"
cap mkdir "$MY_PATH/Temp"
cap mkdir "$MY_PATH/Table"

** define relate paths
global MY_RAWDATA "$MY_PATH/RawData"
global MY_INPUT "$MY_PATH/InputData"
global MY_OUTPUT "$MY_PATH/OutputData"
global MY_DO "$MY_PATH/DoFile"
global MY_TEMP "$MY_PATH/Temp"
global MY_TABLE "$MY_PATH/Table"

/**
Download the google Trends search intensity using the python code
**/

** 
do "$MY_DO/GTrends"
do "$MY_DO/MSACovidCases"
** merge the two dataset
do "$MY_DO/MergingDataset"
do "$MY_DO/MonthlyNTD"

** Analysis
do "$MY_DO/Analysis"
