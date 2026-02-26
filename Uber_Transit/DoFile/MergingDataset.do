** merge the two datasets


use "$MY_TEMP/WeeklyCases/US-CA-807.dta", clear
gen metroid = "US-CA-807"
save "$MY_TEMP/WeeklyCases/US-CA-807.dta", replace

local metrocode2 "US-CA-825 US-CA-862 US-CO-751 US-FL-528 US-FL-534 US-FL-539 US-GA-524 US-IL-602 US-MA-506 US-MD-512 US-MI-505 US-MN-613 US-MO-609 US-MO-616 US-NC-517 US-NV-839 US-NY-501 US-OH-515 US-OR-820 US-PA-504 US-PA-508 US-TX-618 US-TX-623 US-TX-635 US-TX-641 US-VA-511 US-WA-819"

foreach id of local metrocode2{
	use "$MY_TEMP/WeeklyCases/`id'.dta"
	gen metroid = "`id'"
	save "$MY_TEMP/WeeklyCases/`id'.dta", replace
}

use "$MY_TEMP/County2.dta", clear
gen date2 = date(date, "YMD")
format date2 %td
gen month = mofd(date2)
*gen int week_7_days_num = floor((date2 - td(01mar2020))/7+1)
gen weeknr = wofd(date2)
drop if weeknr <=0
keep date metroid state metroname date2 weeknr
duplicates drop
save "$MY_TEMP/CountyToMerge.dta", replace


** append datasets
use "$MY_TEMP/WeeklyCases/US-CA-807.dta", clear
local metrocode2 "US-CA-825 US-CA-862 US-CO-751 US-FL-528 US-FL-534 US-FL-539 US-GA-524 US-IL-602 US-MA-506 US-MD-512 US-MI-505 US-MN-613 US-MO-609 US-MO-616 US-NC-517 US-NV-839 US-NY-501 US-OH-515 US-OR-820 US-PA-504 US-PA-508 US-TX-618 US-TX-623 US-TX-635 US-TX-641 US-VA-511 US-WA-819"
foreach id of local metrocode2{
	append using "$MY_TEMP/WeeklyCases/`id'.dta" 
}
save "$MY_TEMP/WeeklyCases/TOTAL.dta", replace


use "$MY_TEMP/CountyToMerge.dta", clear
merge m:1 metroid weeknr using "$MY_TEMP/WeeklyCases/TOTAL.dta" 
sort metroid date
drop _merge
save "$MY_OUTPUT/CountyCases.dta", replace

use "$MY_INPUT/GTrendsFinal.dta", clear
merge 1:m metroid weeknr using "$MY_OUTPUT/CountyCases.dta" 

drop if week == ""
keep week googletrend metroid metroname date2 month weeknr weeklycases
duplicates drop
save "$MY_OUTPUT/FinalWithoutControls.dta", replace

