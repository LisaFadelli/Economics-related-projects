use "$MY_DATA/CovidCases.dta"

** Covid-19 situation in Arkansas [Graph]
xtline cases_ma7 if state == "AR" & inrange(date, 22056, 22176), overlay ytitle(7-Day incidence rate) xtitle(Date) title (7-day Incidence Rate in Arkansas, box position(12) ring(7)) xline(22116) xlabel(, angle(45) format("%tdMon_DD_,_YY")) ylabel(, angle(0))
graph export "$MY_GRAPH/7day_incidence_rate_AR.png", as(png) name("Graph") replace


** DIFFERENCE-IN-DIFFERENCES METHOD
**estimate the DiD specification 1
global intdate 22116
gen tgroup = 0 if inlist(state, "MO")
replace tgroup = 1 if state == "AR"
gen post = 1 if date >= $intdate & date <= $intdate + 60
replace post = 0 if date < $intdate & date >= $intdate - 60
gen did = tgroup * post
eststo Missouri: reg cases_ma7 did post tgroup 
drop post tgroup did

** estimate the DiD specification 2 
gen tgroup = 0 if inlist(state, "OK")
replace tgroup = 1 if state == "AR"
gen post = 1 if date >= $intdate & date <= $intdate + 60
replace post = 0 if date < $intdate & date >= $intdate - 60
gen did = tgroup * post
eststo Oklahoma: reg cases_ma7 did post tgroup 
drop post tgroup did

**estimate the DiD specification 3
gen tgroup = 0 if inlist(state, "TN")
replace tgroup = 1 if state == "AR"
gen post = 1 if date >= $intdate & date <= $intdate + 60
replace post = 0 if date < $intdate & date >= $intdate - 60
gen did = tgroup * post
eststo Tennessee: reg cases_ma7 did post tgroup 

estout Missouri Oklahoma Tennessee, cells(b(star fmt(%9.3f)) t(par)) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N. obs")) legend note(t statistics in parentheses) label collabels(none)

** we use specification (1)
drop post tgroup did
global intdate 22116
gen tgroup = 0 if inlist(state, "MO")
replace tgroup = 1 if state == "AR"
gen post = 1 if date >= $intdate & date <= $intdate + 60
replace post = 0 if date < $intdate & date >= $intdate - 60
gen did = tgroup * post
eststo m1: reg cases_ma7 did post tgroup 
gen iday = $intdate if state == "AR"
foreach x of numlist 14/1 {
	gen e_b`x' = (date - iday == -`x' & tgroup == 1)
	label var e_b`x' "-`x'"
}
foreach x of numlist 0/60 {
	gen e_a`x' = (date - iday == `x' & tgroup == 1)
	label var e_a`x' "`x'"
}
reg cases_ma7 e_* i.date tgroup if inrange(date, 22056, 22176)
est store eventstudy1

coefplot eventstudy1, keep (e_*) vertical yline(0) xline(15) xsize(15) ysize(5) title (Event study, box position(12) ring(7)) xtitle("Days to the intervention", size(medium)) ytitle("Coefficient", size(medium)) xlabel(, angle(45)) ylabel(, angle(0))
graph export "$MY_GRAPH/coefplot_eventstudy.png", as(png) name("Graph") replace



** SYNTHETIC CONTROL METHOD 
global intdate 22116
keep if date >= $intdate -15 & date <= $intdate +60
sum id if state == "AR"

drop if male == . | female == . | medianage == . | ageunder18 == . | ageover18 == . | ageover65 == . | ageover85 == . | hispanic == . | white == . | blackafricanamerican == .| indianalaskanative == .| asian == .| hawaiianpacificislander == .| other_races == .| two_or_more_races == .| diabetes_rate == .| obesity_rate == . | cases_ma7 == . | pop_density == . | government == .
count

sort id date
foreach x of numlist 1/14 {
    gen l`x'cases_ma7 = l`x'.cases_ma7
}
global lags l1cases_ma7 l2cases_ma7 l3cases_ma7 l4cases_ma7 l5cases_ma7 l6cases_ma7 l7cases_ma7 l8cases_ma7 l9cases_ma7 l10cases_ma7 l11cases_ma7 l12cases_ma7 l13cases_ma7 l14cases_ma7 

** SCM specification 1
synth cases_ma7 medianage ageover65 ageover85 diabetes_rate obesity_rate pop_density government cases_ma7 $lags, trunit(3) trperiod($intdate) xperiod(22115) fig 

** change the donor pool
drop if inlist(state,"AL","CA","CO","CT","DC","DE", "HI","IL","IN")
drop if inlist(state,"KS","KY","LA","MA","MD","ME","MI","MN","MS")
drop if inlist(state,"MT","NC","NM","NV","NY","OH","OR","PA","RI")
drop if inlist(state,"TX","VA","VT","WA","WI","WV") 
** SCM specification 2
synth cases_ma7 medianage ageover65 ageover85 diabetes_rate obesity_rate pop_density government cases_ma7 $lags, trunit(3) trperiod($intdate) xperiod(22115) fig 
gr_edit xaxis1.style.editstyle majorstyle(tickangle(forty_five)) editcopy 
gr_edit xaxis1.major.label_format = `"%tdMon_dd,_CCYY"'editcopy
gr_edit xaxis1.style.editstyle majorstyle(use_labels(no)) editcopy
gr_edit xaxis1.style.editstyle majorstyle(alternate(no)) editcopy
gr_edit yaxis1.style.editstyle majorstyle(tickangle(horizontal)) editcopy
graph export "$MY_GRAPH/synth.png", as(png) name("Graph") replace


** in-time placebo test 
use "$MY_DATA/CovidCases.dta", clear
global intdate 22116
drop if inlist(state,"AL","CA","CO","CT","DC","DE", "HI","IL","IN")
drop if inlist(state,"KS","KY","LA","MA","MD","ME","MI","MN","MS")
drop if inlist(state,"MT","NC","NM","NV","NY","OH","OR","PA","RI")
drop if inlist(state,"TX","VA","VT","WA","WI","WV") 
keep if date >= $intdate -60 & date <= $intdate +60
sum id if state == "AR"
drop if male == . | female == . | medianage == . | ageunder18 == . | ageover18 == . | ageover65 == . | ageover85 == . | hispanic == . | white == . | blackafricanamerican == .| indianalaskanative == .| asian == .| hawaiianpacificislander == .| other_races == .| two_or_more_races == .| diabetes_rate == .| obesity_rate == . | cases_ma7 == . | pop_density == . | government == .
count
sort id date
foreach x of numlist 1/20 {
    gen l`x'cases_ma7 = l`x'.cases_ma7
}
global lags l1cases_ma7 l2cases_ma7 l3cases_ma7 l4cases_ma7 l5cases_ma7 l6cases_ma7 l7cases_ma7 l8cases_ma7 l9cases_ma7 l10cases_ma7 l11cases_ma7 l12cases_ma7 l13cases_ma7 l14cases_ma7 l15cases_ma7 l16cases_ma7 l17cases_ma7 l18cases_ma7 l19cases_ma7 l20cases_ma7 
synth cases_ma7 medianage ageover65 ageover85 diabetes_rate obesity_rate pop_density government cases_ma7 $lags, trunit(3) trperiod(22086) xperiod (22085) fig keep("$MY_DATA/synth.dta", replace)
preserve
use "$MY_DATA/synth.dta", clear
describe
tw(line _Y_treated _time)(line _Y_synthetic _time), name(synth,replace) xline (22116.5) xline(22086.5)  title(In time placebo test, box position(12) ring(7)) b2title(Date) ytitle(7-day incidence rate) legend(label(1 "Arkansas") label(2 "synthetic Arkansas")) xlabel(, angle(45) format("%tdMon_DD_,_YY"))
graph export "$MY_GRAPH/in_time_placebo_synth.png", as(png) name("synth") replace
restore
preserve

** in-space placebo test
drop if state == "AR" 
sum id if state == "MO"
synth cases_ma7 medianage ageover65 ageover85 diabetes_rate obesity_rate pop_density government cases_ma7 $lags, trunit(28) trperiod($intdate) xperiod (22115) fig keep("$MY_DATA/synth.dta", replace)
use "$MY_DATA/synth.dta", clear
describe
tw(line _Y_treated _time)(line _Y_synthetic _time), name(synth,replace) xline (22116.5)  title(In space placebo test, box position(12) ring(7)) b2title(Date) ytitle(7-day incidence rate) legend(label(1 "Missouri") label(2 "synthetic Missouri")) xlabel(, angle(45) format("%tdMon_DD_,_YY"))
graph export "$MY_GRAPH/in_space_placebo_synth.png", as(png) name("synth") replace






