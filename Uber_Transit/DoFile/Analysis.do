use "$MY_OUTPUT/FinalDataset.dta", clear

** declare that the dataset is a panel dataset
**xtset metroid week 
*metroid is a string variable
encode metroid, gen(id)
**xtset id week
* week is a string variable
gen year = substr(week, 1, 4)
tab year
gen month2 = substr(week, 6, 2)
tab month2
gen day = substr(week, 9, 2)
tab day
destring year month2 day, replace
drop week
gen week = mdy(month2, day, year)
format week %tdDD-Mon-YY


drop date2 year day month2
keep googletrend weeklycases UPTTotal VOMSTotal id week weeknr
replace weeklycases = . if weeklycases < 0
gen lnUPTTotal = ln(UPTTotal)
gen lnVOMSTotal = ln(VOMSTotal)
gen lnweeklycases = ln(weeklycases)

* Declare the dataset as a panel dataset
xtset id weeknr
* FE regression
xtreg googletrend lnweeklycases lnUPTTotal lnVOMSTotal, fe 
estimate store fe // rejected Ftest
* RE regression
xtreg googletrend lnweeklycases lnUPTTotal lnVOMSTotal, re
estimate store re
xttest0 // heterogeneity detected

hausman fe re // rejected
* FD regression
reg d.(googletrend lnweeklycases lnUPTTotal lnVOMSTotal)
estimate store fd
* Test for no serial correlation in first-differenced vit
predict u, resid
reg u l.u

drop _est_fe
** FIXED_EFFECT MODEL + Robustness condition
xtreg googletrend lnweeklycases lnUPTTotal lnVOMSTotal, fe vce(robust)
estimate store fe

* Check the normal distribution of the residuals 
predict r, resid
qnorm r
histogram r, normal

** Summary Statistics 
summarize googletrend weeklycases UPTTotal VOMSTotal
label variable googletrend "Google Trend Search Intensity"
label variable weeklycases "New weekly cases"
label variable UPTTotal "Unlinked Passenger Trips"
label variable VOMSTotal "Vehicles Operated in Annual Maximum Service"
label variable lnweeklycases "Log New weekly cases"
label variable lnUPTTotal "Log Unlinked Passenger Trips"
label variable lnVOMSTotal "Log Vehicles Operated in Annual Maximum Service"

estpost tabstat googletrend weeklycases UPTTotal VOMSTotal, ///
	statistics(mean median sd min max) columns(statistics)
estimates store uber_summary_stats

esttab uber_summary_stats using "$MY_TABLE/summary_stats.tex", replace ///	   
	booktabs label nonumber nomtitles ///
	cells("mean(fmt(a2)) p50(fmt(a2)) sd(fmt(a2)) min(fmt(%12.2f)) max(fmt(a2))") ///
	collabels("Mean" "Median" "Std. dev." "Minimum" "Maximum") ///
	scalars("N Obs.") 

esttab fe using "$MY_TABLE/fixedeffects.tex", se label booktabs replace star(* 0.10 ** 0.05 *** 0.01) scalars("myObs Observations" "r2_a Adjusted R-squared")



* Analysis
twoway scatter googletrend lnweeklycases || qfit googletrend lnweeklycases, by(weeknr)
twoway scatter googletrend lnUPTTotal || qfit googletrend lnUPTTotal, by(weeknr)
twoway scatter googletrend lnVOMSTotal || qfit googletrend lnVOMSTotal, by(weeknr)

