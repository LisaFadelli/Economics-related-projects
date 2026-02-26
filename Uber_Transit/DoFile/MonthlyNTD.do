
foreach xxx in UPT VOMS VRH VRM {
    import excel "$MY_RAWDATA/October 2021 Adjusted Database.xlsx", sheet("`xxx'") firstrow clear case(lower) 
    rename digitntdid NTDID // importing the excel file gives "5 digit NTDID" a funny name because Stata variables cannot start with a number
    drop b // the 4 digit NTDID code gets saves with variable name B, and we do not need it
    drop if modes == ""
    foreach y of varlist jan* feb* mar* apr* may* jun* jul* aug* sep* oct* nov* dec*{
        ren `y' stub`y'
    }
    * Drop rows that contain no data
    egen meanX = rowmean(stub*)
    drop if meanX == .

    *One observation per month-year
    reshape long stub, i(NTDID modes tos reportertype) j(time) string

    ren stub `xxx'
    * Get date in the proper format (Stata assumes it is the first day of the month)
    gen dateSurvey = date(time,"M20Y")
    format dateSurvey %dM_CY
    
    * Simplifying mode to be only Bus, Rail, or Other
    gen Mode = "Bus" if inlist(modes, "MB", "CB", "RB", "TB")
    replace Mode = "Rail" if inlist(modes, "HR", "LR", "SR", "CR", "IP", "CC", "MG", "MO")
    replace Mode = "Rail" if inlist(modes, "YR", "AG", "AR")
    replace Mode = "Other" if Mode == ""
	
	* Remediating implausible negative value of VRM
		/* This concerns mode DR of NTDID 50096 in December 2006
			per "Interim Reports/September 2016 Adjusted Database-Negative" */
	count if `xxx' < 0 /* stored in memory as r(N) */
	capture confirm variable VRM /* produces a scalar stored as _rc which is
		null when the condition is true (i.e. when we are dealing with VRM) */
	
	if _rc != 0 {
		assert r(N) == 0
		}
	else {
		assert r(N) == 1
		replace `xxx' = abs(`xxx')
	}

    * Get total for each mode and overall total
    collapse (sum) `xxx', by(NTDID Mode dateSurvey)
    save "$MY_TEMP/temp", replace
    collapse (sum) `xxx', by(NTDID dateSurvey)
    append using "$MY_TEMP/temp"
    replace Mode = "Total" if Mode == ""
    drop if inlist(`xxx', 0, .) // the sum of missings gets sent to zero. All of these variables are things which cannot reasonably be zero
    save "$MY_TEMP/temp`xxx'", replace
}

** The totals should never be missing from temp/temp{UPT,VOMS,VRH,VRM}.dta
foreach iii in UPT VOMS VRH VRM {
	use "$MY_TEMP/temp`iii'", clear
	reshape wide `iii', i(NTDID dateSurvey) j(Mode) string
	assert `iii'Total != .
}

** Merge the data for all four outcomes together
use "$MY_TEMP/tempVRM.dta", clear
foreach xxx in UPT VOMS VRH{
    merge 1:1 NTDID dateSurvey Mode using "$MY_TEMP/temp`xxx'", nogen // those which don't match are due to dropping missing observations above (line 80)
}
order NTDID dateSurvey Mode UPT VOMS VRM VRH

** Make an observation an agency-month pair, so it matches how the regressions are currently set to run (ie, change from long to wide)
reshape wide UPT VOMS VRM VRH, i(NTDID dateSurvey) j(Mode) string

** Label variables
foreach myVar in Total Rail Bus Other {
    label var UPT`myVar' "Unlinked passenger trips"
    label var VOMS`myVar' "Maximum vehicles in service"
    label var VRM`myVar' "Vehicle revenue miles"
    label var VRH`myVar' "Vehicle revenue hours"
}

** Fix NTDID - store as string and add in leading zeros
gen NTDID2 = string(NTDID, "%05.0f")
drop NTDID
rename NTDID2 NTDID
label var NTDID "5 digit NTD ID"

** Drop any observations that contain no information
ds NTDID dateSurvey, not
egen isSomethingThere = rowfirst(`r(varlist)')
drop if isSomethingThere == .
drop isSomethingThere

** For convience create a month variable
gen month = month(dateSurvey)

compress
save "$MY_INPUT/MonthlyNTD.dta", replace

** Keep only the data needed for the contribution
use "$MY_INPUT/MonthlyNTD.dta"
drop if year < 2020

keep dateSurvey VOMSTotal UPTTotal NTDID month year

local ntdid "00001	00003	00005	00008	00023	00024	00028	00029	00035	00040	00046	00058	00376	00407	10003	10004	10005	10013	10053	10118	10133	10178	10179	10180	10181	10182	11159	11160	11237	20006	20008	20071	20072	20075	20076	20078	20080	20082	20084	20085	20096	20098	20099	20100	20122	20126	20128	20135	20149	20160	20161	20163	20165	20166	20169	20175	20176	20177	20188	20190	20192	20195	20201	20204	20206	20208	20209	20210	20212	20217	20219	20220	20226	22930	30019	30022	30023	30030	30034	30040	30044	30048	30051	30057	30058	30068	30070	30071	30073	30075	30078	30080	30081	30085	30104	30106	30108	30111	30112	30129	30141	30201	30990	40008	40019	40022	40027	40029	40034	40035	40037	40041	40074	40077	40078	40082	40138	40161	40176	40181	40200	40205	40215	40228	40232	40237	40238	40239	40240	40241	40246	40248	40249	40250	40251	40253	40254	40256	40257	40260	40261	40262	40263	40264	41027	41088	42001	44929	44932	50012	50027	50031	50042	50045	50066	50103	50104	50113	50118	50119	50131	50141	50146	50154	50157	50166	50167	50179	50182	50183	50185	50193	50200	50213	50515	50516	50517	50518	50519	50521	55311	60007	60008	60011	60041	60048	60056	60068	60070	60103	60108	60113	60114	60115	60117	60119	60120	60121	60125	60126	60130	60133	60260	66270	70005	70006	70035	70046	70047	70057	70271	80006	80109	90003	90007	90008	90009	90010	90012	90013	90014	90015	90016	90019	90022	90023	90024	90026	90030	90036	90039	90041	90042	90043	90044	90045	90090	90094	90095	90134	90146	90147	90151	90154	90157	90159	90161	90168	90182	90196	90205	90211	90214	90223	90225	90229	90234	90235	90246	90247	90249	90250	90251	90252	90253	90254	90255	90256	90257	90258	90259	90260	90261	90262	90263	90265	90266	90267	90268	90269	90270	90271	90272	90273	90274	90275	90276	90277	90278	90279	90280	90281	90282	90283	90284	90285	90286	90287	90288	90289	90290	90291	90292	90293	90294	90295	90296	90300	90301	90304	90306	99422	99423	99424	99425	A0020"
gen ntdidMSA = 0
foreach id of local ntdid {
	replace ntdidMSA = 1 if NTDID == "`id'"
}

drop if ntdidMSA == 0
drop ntdidMSA
save "$MY_INPUT/MonthlyNTD.dta", replace


import excel "$MY_RAWDATA/2020AgencyInfo.xlsx", sheet("MetroNTDID") firstrow, clear
save "$MY_INPUT/2020AgencyInfo.dta", replace

use "$MY_INPUT/MonthlyNTD.dta", clear
merge m:m NTDID using "$MY_INPUT/2020AgencyInfo.dta"
drop _merge 
gen day = 1
gen date2 = mdy(month, day, year)
format date2 %td
rename month monthnr
gen month = mofd(date2)
sort metroid month
format UPTTotal %13.0fc
format VOMSTotal %13.0fc
drop monthnr year day dateSurvey



local metrocode "US-CA-807 US-CA-825 US-CA-862 US-CO-751 US-FL-528 US-FL-534 US-FL-539 US-GA-524 US-IL-602 US-MA-506 US-MD-512 US-MI-505 US-MN-613 US-MO-609 US-MO-616 US-NC-517 US-NV-839 US-NY-501 US-OH-515 US-OR-820 US-PA-504 US-PA-508 US-TX-618 US-TX-623 US-TX-635 US-TX-641 US-VA-511 US-WA-819"
foreach id of local metrocode{
	preserve
	keep if metroid == "`id'"
	save "$MY_TEMP/NTDID/`id'.dta", replace
	restore
}

use "$MY_TEMP/NTDID/US-CA-807.dta", clear
collapse(sum) UPTTotal VOMSTotal, by(month)
drop if month < 722
save "$MY_TEMP/NTDID/US-CA-807.dta", replace

local metrocode2 "US-CA-825 US-CA-862 US-CO-751 US-FL-528 US-FL-534 US-FL-539 US-GA-524 US-IL-602 US-MA-506 US-MD-512 US-MI-505 US-MN-613 US-MO-609 US-MO-616 US-NC-517 US-NV-839 US-NY-501 US-OH-515 US-OR-820 US-PA-504 US-PA-508 US-TX-618 US-TX-623 US-TX-635 US-TX-641 US-VA-511 US-WA-819"
foreach id2 of local metrocode2{
	use "$MY_TEMP/NTDID/`id2'.dta", clear
	collapse(sum) UPTTotal VOMSTotal, by(month)
	drop if month < 722
	save "$MY_TEMP/NTDID/`id2'.dta", replace
}


local metrocode "US-CA-807 US-CA-825 US-CA-862 US-CO-751 US-FL-528 US-FL-534 US-FL-539 US-GA-524 US-IL-602 US-MA-506 US-MD-512 US-MI-505 US-MN-613 US-MO-609 US-MO-616 US-NC-517 US-NV-839 US-NY-501 US-OH-515 US-OR-820 US-PA-504 US-PA-508 US-TX-618 US-TX-623 US-TX-635 US-TX-641 US-VA-511 US-WA-819"
foreach id of local metrocode{
	use "$MY_TEMP/NTDID/`id'.dta"
	gen metroid = "`id'"
	save "$MY_TEMP/NTDID/`id'.dta", replace
}

use "$MY_TEMP/NTDID/US-CA-807.dta", clear
local metrocode2 "US-CA-825 US-CA-862 US-CO-751 US-FL-528 US-FL-534 US-FL-539 US-GA-524 US-IL-602 US-MA-506 US-MD-512 US-MI-505 US-MN-613 US-MO-609 US-MO-616 US-NC-517 US-NV-839 US-NY-501 US-OH-515 US-OR-820 US-PA-504 US-PA-508 US-TX-618 US-TX-623 US-TX-635 US-TX-641 US-VA-511 US-WA-819"
foreach id of local metrocode2{
	append using "$MY_TEMP/NTDID/`id'.dta" 
}
save "$MY_TEMP/NTDID/TOTAL.dta", replace


use "$MY_OUTPUT/FinalWithoutControls.dta", clear
merge m:1 metroid month using "$MY_TEMP/NTDID/TOTAL.dta" 
sort metroid date
drop _merge
drop if week == ""
save "$MY_OUTPUT/FinalDataset.dta", replace





