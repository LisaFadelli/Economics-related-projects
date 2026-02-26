**Last Update: 20 Jan 

************************************************************************
** Prepare data
** Run the GTrends.py file to download the GTrendslong.csv file with all the data about the google trends search intensity
** Prepare GTrendFinal.dta
import excel "$MY_RAWDATA/Google Trend/idmetroname.xls", sheet("Sheet4") firstrow clear
save "$MY_INPUT/idmetroname.dta", replace
import delimited "$MY_RAWDATA/Google Trend/CSV/GTrendslong.csv", clear
drop v1 
rename uber searchintensity
merge m:m metroid using "$MY_INPUT/idmetroname.dta"
drop if date==""
drop _merge 
save "$MY_INPUT/GTrend.dta", replace

** Modify the data
use "$MY_INPUT/GTrend.dta", clear
assert searchintensity >= 0
sort metroname metroid date
** Rename "Seach intensity" to "Google Trend"
rename searchintensity googletrend
rename date week

** Generate month level (easier fot merging into  other data on)
gen date2 = date(week, "YMD")
format date2 %td
sort metroname date2
gen month = mofd(date2)
gen weeknr = wofd(date2)

*gen int week_7_days_num = floor((date2 - td(01mar2020))/7+1)


save "$MY_INPUT/GTrendsFinal.dta", replace

