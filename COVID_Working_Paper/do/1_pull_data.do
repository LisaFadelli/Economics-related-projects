import delimited "$MY_RAWDATA/United_States_COVID-19_Cases_and_Deaths_by_State_over_Time.csv", encoding(ISO-8859-2)
sort state
encode state, gen(id)

gen year = substr(submission_date, 7, 4)
tab year
gen month = substr(submission_date, 1, 2)
tab month
gen day = substr(submission_date, 4, 2)
tab day
destring year month day, replace
sum year month day
drop submission_date
gen date = mdy(month, day, year)
format date %tdDD-Mon-YY

sort state date

save "$MY_DATA/CovidCases.dta", replace

import delimited "$MY_RAWDATA/generalinfo.csv", encoding(UTF-8) clear 
save "$MY_DATA/General_Info.dta", replace
use "$MY_DATA/CovidCases.dta"
merge m:1 state using "$MY_DATA/General_Info.dta"
save "$MY_DATA/CovidCases.dta", replace

import delimited "$MY_RAWDATA/incidence_every100000.csv", delimiter("", collapse) encoding(UTF-8) clear
gen year = substr(submission_date, 7, 4)
tab year
gen month = substr(submission_date, 4, 2)
tab month
gen day = substr(submission_date, 1, 2)
tab day
destring year month day, replace
sum year month day
drop submission_date
gen date = mdy(month, day, year)
format date %tdDD-Mon-YY
drop totpopulation new_case year month day 
save "$MY_DATA/incidence_every100000.dta", replace
use "$MY_DATA/CovidCases.dta"
drop _merge
merge 1:1 state date using "$MY_DATA/incidence_every100000.dta"
save "$MY_DATA/CovidCases.dta", replace

xtset id date
gen cases_ma7 = incidence_every100000 + l.incidence_every100000 + l2.incidence_every100000 +l3.incidence_every100000 + l4.incidence_every100000 + l5.incidence_every100000 + l6.incidence_every100000
gen date2 = date
list date date2 if state == "AR"
save "$MY_DATA/CovidCases.dta", replace

