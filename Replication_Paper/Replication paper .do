** Replication paper 
use "/Users/lisafadelli/Documents/MSCECONOMICSAMBURGO/COVIDECON/PAPER/Article for CEP (DTT).dta"
tsset dyadid year
* GMM, treaty age, all countries, maximum lag length 6
xi: xtabond lnfdiinstock hostgdptotln hostgdppcln hostinflln hosttrade rta i.year, robust maxldep(6) maxlags(6) pre(dttage bitage, endog)
* Test for serial correlation
estat abond

* Test for endogeneity 
quietly xi: xtabond lnfdiinstock hostgdptotln hostgdppcln hostinflln hosttrade rta i.year, maxldep(6) maxlags(6) pre(dttage bitage, endog)
estat sargan
// Reject estat --> check for other model

quietly xi: xtabond lnfdiinstock hostgdptotln hostgdppcln hostinflln hosttrade rta i.year, maxldep(6) maxlags(4) pre(dttage bitage, endog)
estat sargan
// not working

quietly xi: xtabond lnfdiinstock hostgdptotln hostgdppcln hostinflln hosttrade rta i.year, maxldep(2) maxlags(2) pre(dttage bitage, endog)
estat sargan
// not working

quietly xi: xtabond lnfdiinstock hostgdptotln hostgdppcln hostinflln hosttrade rta i.year, maxldep(1) maxlags(1) pre(dttage bitage, endog)
estat sargan
// not working 


quietly xi: xtabond lnfdiinstock hostgdptotln hostgdppcln hostinflln hosttrade rta i.year, maxldep(2) maxlags(6) pre(dttage bitage, endog)
estat sargan
// not working




** This is what I have added to the paper
Hypothesis
quietly xi: xtabond lnfdiinstock hostgdptotln hostgdppcln hostinflln hosttrade rta i.year, robust maxldep(2) maxlags(2) pre(dttage bitage, endog)
estat abond
quietly xi: xtabond lnfdiinstock hostgdptotln hostgdppcln hostinflln hosttrade rta i.year, maxldep(2) maxlags(2) pre(dttage bitage, endog)
estat sargan

quietly xi: xtabond lnfdiinstock hostgdptotln hostgdppcln hostinflln hosttrade rta i.year, maxldep(2) maxlags(2) pre(dttage bitage i.year, endog)
estat sargan
// not working of course

quietly xi: xtabond lnfdiinstock hostgdptotln hostgdppcln hostinflln hosttrade rta i.year, maxldep(6) maxlags(2) pre(dttage bitage, endog)
estat sargan
// not working

xi: xtabond lnfdiinstock hostgdptotln hostgdppcln hostinflln hosttrade rta i.year, robust maxldep(6) maxlags(6) pre(dttage bitage, endog) endogenous(hostgdptotln)
estat abond
xi: xtabond lnfdiinstock hostgdptotln hostgdppcln hostinflln hosttrade rta i.year, robust maxldep(2) maxlags(2) pre(dttage bitage, endog) endogenous(hostgdptotln)
estat sargan


//two stage
xi: xtabond lnfdiinstock hostgdptotln hostgdppcln hostinflln hosttrade rta i.year, twostep robust maxldep(6) maxlags(6) pre(dttage bitage, endog)
** inefficient, higher standard errors

