set more off
capture clear
capture log close
cls

log using log/01-gss-egp-redist-class-distribution.log, replace

use data/gss-1972-and-later-filled-in-recoded-imputed-in-sample.dta, clear

********************************************************************************
*** Reweight according to sample size
********************************************************************************
do analysis/gss-egp-redist-rescale-weights.do

********************************************************************************
*** Class Distribution
********************************************************************************
** Graphic scheme
set scheme plotplainblind
graph set window fontface "Arial"

*** distribution of the EGP class by survey year	
mlogit egp10_6_rf i.year [pw=wt_scaled]
margins i.year, level(95) saving(data/egp6-trend-data.dta, replace)
marginsplot, ///
	plot1opts(mcolor(blue) lcolor(blue)) ci1opts(color(blue)) ///
	plot2opts(mcolor(black) lcolor(black)) ci2opts(color(black)) ///
	plot3opts(mcolor(purple) lcolor(purple)) ci3opts(color(purple)) ///
	plot4opts(mcolor(dkgreen) lcolor(dkgreen)) ci4opts(color(dkgreen)) ///
	plot5opts(mcolor(red) lcolor(red)) ci5opts(color(red)) ///
	plot6opts(mcolor(orange) lcolor(orange)) ci6opts(color(orange)) ///
	title("Current Classes", size(medlarge)) ymtick(,tlcolor(black)) ///
	ytitle("") xtitle("")  xlabel(1977 1988(10)2018,  glwidth(medthin) ///
				labsize(medlarge) nogrid labcolor(black) tlcolor(black)) ///
	plotr(m(small)) aspectratio(0.8)  ///
	yscale(lcolor(black)) xscale(lcolor(black))  ///
	ylabel(0(0.1)0.5,  labsize(medlarge) labcolor(black) tlcolor(black) format(%5.1f)) ///
	ciopt(color(%50)) recastci(rspike)   ///
	plotopts(lwidth(medthick)) ///
	legend(col(3)   ///
	order(7 "Salariat (I+II)" 8 "Intermediate (IIIa+IVab+V)" ///
		  9 "Farming (IVc+VIIb)" 10 "Working, Service (IIIb)" ///
		  11 "Working, Manual (VI+VIIa)" 12 "Military")) 

graph save graph/egp6-dist-survey-year.gph, replace
gr export graph/egp6-dist-survey-year.pdf, replace

mlogit oegp10_6_rf i.year [pw=wt_scaled]
margins i.year, level(95)
marginsplot, ///
	plot1opts(mcolor(blue) lcolor(blue)) ci1opts(color(blue)) ///
	plot2opts(mcolor(black) lcolor(black)) ci2opts(color(black)) ///
	plot3opts(mcolor(purple) lcolor(purple)) ci3opts(color(purple)) ///
	plot4opts(mcolor(dkgreen) lcolor(dkgreen)) ci4opts(color(dkgreen)) ///
	plot5opts(mcolor(red) lcolor(red)) ci5opts(color(red)) ///
	plot6opts(mcolor(orange) lcolor(orange)) ci6opts(color(orange)) ///
	title("Class Origins", size(medlarge)) ymtick(,tlcolor(black)) ///
	ytitle("") xtitle("")  xlabel(1977 1988(10)2018,  glwidth(medthin) ///
				labsize(medlarge) nogrid labcolor(black) tlcolor(black)) ///
	plotr(m(small)) aspectratio(0.8)  ///
	yscale(lcolor(black)) xscale(lcolor(black))  ///
	ylabel(0(0.1)0.5,  labsize(medlarge) labcolor(black) tlcolor(black) format(%5.1f)) ///
	ciopt(color(%50)) recastci(rspike)   ///
	plotopts(lwidth(medthick)) ///
	legend(col(3)   ///
	order(7 "Salariat (I+II)" 8 "Intermediate (IIIa+IVab+V)" ///
		  9 "Farming (IVc+VIIb)" 10 "Working, Service (IIIb)" ///
		  11 "Working, Manual (VI+VIIa)" 12 "Military")) 

			
graph save graph/oegp6-dist-survey-year.gph, replace	
gr export graph/oegp6-dist-survey-year.pdf, replace

grc1leg graph/egp6-dist-survey-year.gph graph/oegp6-dist-survey-year.gph, ///
name(g1, replace)
graph display g1, ysize(4) xsize(7)

graph save graph/egp6-oegp6-dist-survey-year.gph, replace 
gr export graph/egp6-oegp6-dist-survey-year.pdf, replace
gr export graph/egp6-oegp6-dist-survey-year.png, width(600) height(450) replace

log close
