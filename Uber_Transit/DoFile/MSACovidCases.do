
import delimited "$MY_RAWDATA/covidcounties2020.csv", clear 
save "$MY_INPUT/covidcounties2020.dta", replace
import delimited "$MY_RAWDATA/covidcounties2021.csv", clear
save "$MY_INPUT/covidcounties2021.dta", replace
merge 1:1 date geoid using "$MY_INPUT/covidcounties2020.dta"
drop v1
sort county date
split geoid, p("-")
*destring geoid2, gen(countyid)
local fips "13013 13015 13035 13045 13057 13063 13067 13077 13085 13089 13097 13113 13117 13121 13135 13143 13149 13151 13159 13171 13199 13211 13217 13223 13227 13231 13247 13255 13297 08001 08005 08014 08019 08031 08035 08039 08047 08059 08093 06017 06061 06067 06113 06077 34003 34013 34017 34019 34023 34025 34027 34029 34031 34035 34037 34039 36005 36047 36059 36061 36079 36081 36085 36087 36103 36119 6037 6059 17031 17037 17043 17063 17089 17093 17097 17111 17197 18073 18089 18111 18127 48085 48113 48121 48139 48231 48251 48257 48367 48397 48439 48497 48015 48039 48071 48157 48167 48201 48291 48339 48473 24009 24017 24021 24031 24033 51013 51043 51047 51061 51107 51113 51157 51179 51187 51510 51919 51942 51951 54037 42017 42029 42045 42091 42101 10003 34005 34007 34015 34033 12011 12086 12099 25009 25017 25021 25023 25025 33015 33017 33011 06001 06013 06041 06075 06081 06069 06085 26087 26093 26099 26125 26147 26163 53033 53053 53061 27003 27019 27025 27037 27053 27059 27079 27095 27123 27139 27141 27163 27171 55093 55109 06073 12053 12057 12101 12103 24003 24005 24013 24025 24027 24035 24510 17005 17013 17027 17083 17117 17119 17133 17163 29071 29099 29113 29183 29189 29219 29510 12069 12095 12097 12117 12035 12127 37007 37025 37071 37097 37109 37119 37159 37179 45023 45057 45091 48013 48019 48029 48091 48187 48259 48325 48493 41005 41009 41051 41067 41071 53011 53059 42003 42005 42007 42019 42051 42125 42129 48021 48055 48209 48453 48491 32003 18029 18047 18115 18161 21015 21023 21037 21077 21081 21117 21191 39015 39017 39025 39061 39165 20091 20103 20107 20121 20209 29013 29025 29037 29047 29049 29095 29107 29165 29177"

gen MSAcounty = 0
foreach county of local fips {
	replace MSAcounty = 1 if geoid2 == "`county'"
}

drop if MSAcounty == 0
drop MSAcounty


destring geoid2, gen(fips)
save "$MY_TEMP/County.dta", replace

import excel "$MY_RAWDATA/MSACounty.xlsx", sheet("Sheet1") firstrow clear
drop cbsa_id county
save "$MY_TEMP/MSACounty.dta", replace
use "$MY_TEMP/County.dta"
drop _merge
merge m:1 fips using "$MY_TEMP/MSACounty.dta"
sort metroid date
drop deaths deaths_avg deaths_avg_per_100k
** missing values 
drop if metroid=="US-CA-803"
save "$MY_TEMP/County2.dta", replace


use "$MY_TEMP/County2.dta"

local metrocode "US-CA-807 US-CA-825 US-CA-862 US-CO-751 US-FL-528 US-FL-534 US-FL-539 US-GA-524 US-IL-602 US-MA-506 US-MD-512 US-MI-505 US-MN-613 US-MO-609 US-MO-616 US-NC-517 US-NV-839 US-NY-501 US-OH-515 US-OR-820 US-PA-504 US-PA-508 US-TX-618 US-TX-623 US-TX-635 US-TX-641 US-VA-511 US-WA-819"

foreach id of local metrocode{
	preserve
	keep if metroid == "`id'"
	save "$MY_TEMP/`id'.dta", replace
	restore
}

use "$MY_TEMP/US-CA-807.dta", clear
drop _merge
sort county date
gen date2 = date(date, "YMD")
format date2 %td
gen month = mofd(date2)
gen weeknr = wofd(date2)
save "$MY_TEMP/US-CA-807.dta", replace
collapse(sum) cases, by(weeknr)
drop if weeknr <= 0 
rename cases weeklycases
save "$MY_TEMP/WeeklyCases/US-CA-807.dta", replace

local metrocode2 "US-CA-825 US-CA-862 US-CO-751 US-FL-528 US-FL-534 US-FL-539 US-GA-524 US-IL-602 US-MA-506 US-MD-512 US-MI-505 US-MN-613 US-MO-609 US-MO-616 US-NC-517 US-NV-839 US-NY-501 US-OH-515 US-OR-820 US-PA-504 US-PA-508 US-TX-618 US-TX-623 US-TX-635 US-TX-641 US-VA-511 US-WA-819"

foreach id2 of local metrocode2{
	use "$MY_TEMP/`id2'.dta", clear
	drop _merge
	sort county date
	gen date2 = date(date, "YMD")
	format date2 %td
	gen month = mofd(date2)
	gen weeknr = wofd(date2)
	save "$MY_TEMP/`id2'.dta", replace
	collapse(sum) cases, by(weeknr)
	drop if weeknr <= 0 
	rename cases weeklycases
	save "$MY_TEMP/WeeklyCases/`id2'.dta", replace
}











