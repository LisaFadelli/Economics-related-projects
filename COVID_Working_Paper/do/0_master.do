clear all
version 16.1


global MY_PATH "/Users/lisafadelli/Documents/HH/SOSE21/COVIDECON/Paper_Fadelli_Sviridov"

** create new subfolders
cap mkdir "$MY_PATH/raw_data"
cap mkdir "$MY_PATH/data"
cap mkdir "$MY_PATH/graph"
cap mkdir "$MY_PATH/do"
cap mkdir "$MY_PATH/Ados"

** define relate paths
global MY_RAWDATA "$MY_PATH/raw_data"
global MY_DATA "$MY_PATH/data"
global MY_GRAPH "$MY_PATH/graph"
global MY_DO "$MY_PATH/do"

** provide stata ado files in a separate folder
cap adopath - PERSONAL
cap adopath - PLUS
cap adopath - SITE
cap adopath - OLDPLACE
adopath + "$MY_PATH/Ados"

cap log close 
log using $MY_PATH/log1.txt, replace
do $MY_DO/1_pull_data.do
do $MY_DO/2_analysis.do
log close
