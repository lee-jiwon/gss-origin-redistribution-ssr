set more off
capture clear
capture log close
cls

log using log/04-gss-egp-redist-eqwlth-mk-graphs.log, replace

*** set scheme
set scheme plotplainblind, permanently
graph set window fontface "Arial"

********************************************************************************
*** Make a figure for over-time trends in EQWLTH
********************************************************************************
import excel rawdata/income-inequality-census-equ-adjusted.xls, ///
					first clear sheet("eqwlth-ineq")
					
tempfile ineq
save `ineq' ,replace

use data/eqwlth-trend.dta, clear
rename _m1 year
merge m:m year using `ineq'

#delimit ;
twoway rarea _ci_lb _ci_ub year, color(dkgreen%18) lwidth(none) ||
scatter _margin year , sort connect(blue)  lwidth(thick) mcolor(green) 
		lcolor(green) lwidth(medthick) msymbol(circle) msize(medium)
		text(4.84 2004 "Gov't should reduce income differences", size(medium)) ||	
scatter  incdev year ,  yaxis(2) 		
sort connect(line)  mcolor(black) lwidth(medthick)  msymbol(triangle) msize(medium) 
		lpattern(dash)
		lcolor(red) text(3.3 2000 "Log Income Deviation", size(medium)) 
	    title("") ytitle("{bf:Gov't's Role in Reducing Inequality}", 
																size(medium) axis(1))  
		ytitle("{bf:Log Deviation of Income}", size(medium) axis(2)) 
		ylabel(0.3(0.1)1, axis(2) labsize(large) labcolor(black) tlcolor(black) format(%5.1f))
		ymtick(,tlcolor(black) ) 
		xlabel(1978(10)2018,  glwidth(medthin) 
				labsize(large) nogrid labcolor(black) tlcolor(black)) 
		ylabel(3(0.5)5.5,  labsize(large) labcolor(black) tlcolor(black) format(%5.1f))
		aspectratio(0.8) legend(off)
		yscale(lcolor(black)) xscale(lcolor(black))
		yscale(lcolor(black) axis(2)) 
		xtitle("") xlabel(1978(10)2018, nogrid valuelabel)  ;   	   
# delimit cr	

graph display, ysize(8) xsize(14) 	   
gr save graph/eqwlth-trend.gph, replace
gr export graph/eqwlth-trend.pdf, replace

********************************************************************************
*** Make a figure for current-class and Origin effects all years combined
********************************************************************************
tempfile  m2 m3 m4 m5
use data/margins-eqwlth-m2.dta, clear	
gen model = 2
save `m2' ,replace

use data/margins-eqwlth-m3.dta, clear	
gen model = 3
save `m3',replace

use data/margins-eqwlth-m4.dta, clear	
gen model = 4
save `m4' ,replace

use data/margins-eqwlth-m5.dta, clear	
gen model = 5
save `m5' ,replace

use data/margins-eqwlth-m1.dta, clear	
gen model = 1
append using `m2' `m3' `m4' `m5'

g yaxis = .
replace yaxis = 77 if model==1 & _m1==1
replace yaxis = 76 if model==1 & _m1==2
replace yaxis = 75 if model==1 & _m1==3
replace yaxis = 74 if model==1 & _m1==4
replace yaxis = 71 if model==2 & _m1==1
replace yaxis = 70 if model==2 & _m1==2
replace yaxis = 69 if model==2 & _m1==3
replace yaxis = 68 if model==2 & _m1==4
replace yaxis = 65 if model==3 & _m1==1
replace yaxis = 64 if model==3 & _m1==2
replace yaxis = 63 if model==3 & _m1==3
replace yaxis = 62 if model==3 & _m1==4
replace yaxis = 59 if model==4 & _m1==1
replace yaxis = 58 if model==4 & _m1==2
replace yaxis = 57 if model==4 & _m1==3
replace yaxis = 56 if model==4 & _m1==4
replace yaxis = 53 if model==5 & _m1==1
replace yaxis = 52 if model==5 & _m1==2
replace yaxis = 51 if model==5 & _m1==3
replace yaxis = 50 if model==5 & _m1==4

* store point estimate in macros
forval i=1(1)5 {
	forval j=1(1)4 {
		qui sum _margin if _m1== `j' & model == `i'
		local est_`j'`i' : di %4.2f `r(mean)'
	}
}

#delimit ;
scatter yaxis _margin  if _m1==1 ,  
							color(black) symbol(circle) msize(medsmall) || 
rspike  _ci_lb _ci_ub yaxis if _m1==1, 
							lcolor(black%30) lwidth(thick) horizontal || 
scatter yaxis _margin  if _m1==2, 
							color(blue) symbol(triangle) msize(medsmall) || 
rspike  _ci_lb _ci_ub yaxis if _m1==2, 
							lcolor(blue%30) lwidth(thick) horizontal || 
scatter yaxis _margin  if _m1==3, 
							color(red) symbol(square) msize(medsmall) || 
rspike  _ci_lb _ci_ub yaxis if _m1==3, 
							color(red%30) lwidth(thick) horizontal || 
scatter yaxis _margin  if _m1==4,  
							color(green) symbol(diamond) msize(medsmall)  || 
rspike  _ci_lb _ci_ub yaxis if _m1==4, 
							color(green%30) lwidth(thick) horizontal
		ytitle("") yscale(lcolor(black)) xscale(lcolor(black)) 
		xtick(, tlcolor(black))
		ylabel(78.1 " " 78 "{bf: M1: Period}" 77 "Salariat Origin" 
		76 "Intermediate Origin" 75 "Farming Origin" 74 "Working Origin"
		72 "{bf: M2: M1 + Background}" 71 "Salariat Origin" 
		70 "Intermediate Origin" 69 "Farming Origin" 68 "Working Origin"
		66 "{bf:M3: M2 + Current SES }" 65 "Salariat Origin" 
		64 "Intermediate Origin" 63 "Farming Origin" 62 "Working Origin"
		60 "{bf:M4: M3 + Parental Educ.}" 59 "Salariat Origin" 
		58 "Intermediate Origin" 57 "Farming Origin" 56 "Working Origin" 
		54 "{bf:M5: M4 + Class ID}" 53 "Salariat Origin" 
		52 "Intermediate Origin" 51 "Farming Origin" 50 "Working Origin"
		49.1 " " , tstyle(major_notick) nogrid labcolor(black) tlcolor(black) 
		labsize(medsmall)) 
		xtitle("") xlabel(3.5(0.5)5, glcolor(balck) glwidth(medthin) 
		labcolor(black) tlcolor(black) labsize(medsmall) format(%5.1f)) 
		legend(off) 
		ymtick(77(1)74 71(1)68 65(1)62 59(1)56, tlcolor(black)) 
		aspectratio(0.85) 

		text(77.9 `est_11'  "`est_11'", place(c) color(black%90))
		text(76.9 `est_21'  "`est_21'", place(c) color(blue%90))
		text(76.1 `=`est_31'+0.03' "`est_31'", place(c) color(red%90))
		text(73.1 `est_41'  "`est_41'", place(c) color(green%90))
		
		text(71.9 `est_12'  "`est_12'", place(c) color(black%90))
		text(70.9 `est_22'  "`est_22'", place(c)  color(blue%90))
		text(70.1 `=`est_32'+0.03'   "`est_32'", place(c) color(red%90))
		text(67.1 `est_42'  "`est_42'", place(c) color(green%90))
		
		text(65.9 `est_13'  "`est_13'", place(c) color(black%90))
		text(62.9 `est_23'  "`est_23'", place(c) color(blue%90))
		text(63.9 `=`est_33'+0.03'  "`est_33'", place(c) color(red%90))
		text(61.1 `est_43'  "`est_43'", place(c) color(green%90))		
		
		text(59.9 `est_14'  "`est_14'", place(c) color(black%90))
		text(58.9 `=`est_24'+0.06'  "`est_24'", place(c) color(blue%90))				
		text(57.9 `=`est_34'+0.06'  "`est_34'", place(c) color(red%90))
		text(55.1 `est_44'  "`est_44'", place(c) color(green%90))	
		
		text(53.9 `est_15'  "`est_15'", place(c) color(black%90))
		text(52.9 `=`est_25'+0.06'   "`est_25'", place(c) color(blue%90))				
		text(51.9 `=`est_35'+0.06'  "`est_35'", place(c) color(red%90))
		text(49.1 `est_45'  "`est_45'", place(c) color(green%90))	
		
		xline(0, lcolor(black%20) lp(solid) ) ;
		

gr save graph/eqwlth-oegp.gph, replace ;
gr export graph/eqwlth-oegp.pdf, replace ;
# delimit cr


********************************************************************************
*** Make figures for current-class and Origin effects by survey year
********************************************************************************

use data/margins-eqwlth-oegp-by-year, clear

g var = _se^2
bys _m2: egen totalvar = total(var) if _m1 <.
gen inv_var = 1/var

# delimit ;

*** Marginal class origin ****************************************************;
* salariat origin ;
scatter  _margin _m1  if _m1 <. & _m2==1,
				color(black) symbol(Oh) msize(small) || 
rspike  _ci_lb _ci_ub _m1 if _m1 <. & _m2==1,
						lcolor(red%20) lwidth(thick)  || 
lpoly _margin _m1 [aw=inv_var]  if _m1 <. & _m2==1, 
		bw(3) legend(off) deg(1)
		title("Salariat Origin") xtitle("")
		ylabel(2.5(0.5)5.5, labcolor(black) tlcolor(black) labsize(medsmall) format(%5.1f)) 
		xlabel(1978 "78" 1986 "86" 1994 "94" 2002 "02" 2010 "10"  2018 "18"
        , nogrid glcolor(black) glwidth(medthin) 
		labcolor(black) tlcolor(black)  labsize(medsmall) nogrid) 
		xscale(lcolor(black)) xtitle("")
		lcolor(black) lpattern(longdash) lwidth(medthick) yscale(lcolor(black)) 
		aspectratio(1.5) ;
gr save graph/eqwlth-combined-salariat-oegp.gph, replace ;
	
* intermediate origin ;
scatter  _margin _m1  if _m1 <. & _m2==2 ,
				color(black) symbol(Oh) msize(small) || 
rspike  _ci_lb _ci_ub _m1 if _m1 <. & _m2==2 , 
						lcolor(blue%20) lwidth(thick)  || 
lpoly _margin _m1 [aw=inv_var]  if _m1 <. & _m2==2, 
		bw(3) legend(off) deg(1)
		title("Intermediate Origin") xtitle("")
		ylabel(2.5(0.5)5.5, labcolor(black) tlcolor(black) labsize(medsmall) format(%5.1f)) 
		xlabel(1978 "78" 1986 "86" 1994 "94" 2002 "02" 2010 "10"  2018 "18"
        , nogrid glcolor(black) glwidth(medthin) 
		labcolor(black) tlcolor(black)  labsize(medsmall) nogrid) 
		xscale(lcolor(black)) xtitle("")
		lcolor(black) lpattern(longdash) lwidth(medthick) yscale(lcolor(black)) 
		aspectratio(1.5) ;	
gr save graph/eqwlth-combined-intermediate-oegp.gph, replace ;

* farming origin ;
scatter  _margin _m1  if _m1 <. & _m2==3,
				color(black) symbol(Oh) msize(small) || 
rspike  _ci_lb _ci_ub _m1 if _m1 <. & _m2==3 , 
						lcolor(black%20) lwidth(thick)  || 
lpoly _margin _m1 [aw=inv_var]  if _m1 <. & _m2==3 , 
		bw(3) legend(off) deg(1)
		title("Farming Origin") xtitle("")
		ylabel(2.5(0.5)5.5, labcolor(black) tlcolor(black) labsize(medsmall) format(%5.1f)) 
		xlabel(1978 "78" 1986 "86" 1994 "94" 2002 "02" 2010 "10"  2018 "18"
        , nogrid glcolor(black) glwidth(medthin) 
		labcolor(black) tlcolor(black)  labsize(medsmall) nogrid) 
		xscale(lcolor(black)) xtitle("")
		lcolor(black) lpattern(longdash) lwidth(medthick) yscale(lcolor(black)) 
		aspectratio(1.5) ;
gr save graph/eqwlth-combined-farming-oegp.gph, replace ;

* working origin ;
scatter  _margin _m1  if _m1 <. & _m2==4 ,
				color(black) symbol(Oh) msize(small) || 
rspike  _ci_lb _ci_ub _m1 if _m1 <. & _m2==4, 
						lcolor(green%20) lwidth(thick)  || 
lpoly _margin _m1 [aw=inv_var]  if _m1 <. & _m2==4, 
		bw(3) legend(off) deg(1)
		title("Working Origin") xtitle("")
		ylabel(2.5(0.5)5.5, labcolor(black) tlcolor(black) labsize(medsmall) format(%5.1f)) 
		xlabel(1978 "78" 1986 "86" 1994 "94" 2002 "02" 2010 "10"  2018 "18"
        , nogrid glcolor(black) glwidth(medthin) 
		labcolor(black) tlcolor(black)  labsize(medsmall) nogrid) 
		xscale(lcolor(black)) xtitle("")
		lcolor(black) lpattern(longdash) lwidth(medthick) yscale(lcolor(black)) 
		aspectratio(1.5) ;
gr save graph/eqwlth-working-combined-oegp.gph, replace ;


* combined graphs ;
gr combine 
    graph/eqwlth-combined-salariat-oegp.gph 
	graph/eqwlth-combined-intermediate-oegp.gph
	graph/eqwlth-combined-farming-oegp.gph
	graph/eqwlth-working-combined-oegp.gph, imargin(medsmall) cols(4) ;
gr save graph/eqwlth-class-origin-combined-oegp.gph, replace ;

#delimit cr


*** Marginal current class ****************************************************

use data/margins-eqwlth-egp-by-year.dta, clear

g var = _se^2
bys _m2: egen totalvar = total(var) if _m1 <.
gen inv_var = 1/var

# delimit ;

* salariat class ;
scatter  _margin _m1  if _m1 <. & _m2==1 ,
				color(black) symbol(Oh) msize(small) || 
rspike  _ci_lb _ci_ub _m1 if _m1 <. & _m2==1, 
						lcolor(red%20) lwidth(thick)  || 
lpoly _margin _m1 [aw=inv_var]  if _m1 <. & _m2==1, 
		bw(3) legend(off) deg(1)
		title("Salariat Class") xtitle("")
		ylabel(2.5(0.5)5.5, labcolor(black) tlcolor(black) labsize(medsmall) format(%5.1f)) 
		xlabel(1978 "78" 1986 "86" 1994 "94" 2002 "02" 2010 "10"  2018 "18"
        , nogrid glcolor(black) glwidth(medthin) 
		labcolor(black) tlcolor(black)  labsize(medsmall) nogrid) 
		xscale(lcolor(black)) xtitle("")
		lcolor(black) lpattern(longdash) lwidth(medthick) yscale(lcolor(black)) 
		aspectratio(1.5) ;
gr save graph/eqwlth-salariat-combined-oegp.gph, replace ;
	
* intermediate class ;
scatter  _margin _m1  if _m1 <. & _m2==2 ,
				color(black) symbol(Oh) msize(small) || 
rspike  _ci_lb _ci_ub _m1 if _m1 <. & _m2==2, 
						lcolor(blue%20) lwidth(thick)  || 
lpoly _margin _m1 [aw=inv_var]  if _m1 <. & _m2==2, 
		bw(3) legend(off) deg(1)
		title("Intermediate Class") xtitle("")
		ylabel(2.5(0.5)5.5, labcolor(black) tlcolor(black) labsize(medsmall) format(%5.1f)) 
		xlabel(1978 "78" 1986 "86" 1994 "94" 2002 "02" 2010 "10"  2018 "18"
        , nogrid glcolor(black) glwidth(medthin) 
		labcolor(black) tlcolor(black)  labsize(medsmall) nogrid) 
		xscale(lcolor(black)) xtitle("")
		lcolor(black) lpattern(longdash) lwidth(medthick) yscale(lcolor(black)) 
		aspectratio(1.5) ;	
gr save graph/eqwlth-intermediate-combined-oegp.gph, replace ;

* farming/working class ;
scatter  _margin _m1  if _m1 <. & _m2==3 ,
				color(black) symbol(Oh) msize(small) || 
rspike  _ci_lb _ci_ub _m1 if _m1 <. & _m2==3 , 
						lcolor(black%20) lwidth(thick)  || 
lpoly _margin _m1 [aw=inv_var]  if _m1 <. & _m2==3 , 
		bw(3) legend(off) deg(1)
		title("Farming/Working Class") xtitle("")
		ylabel(2.5(0.5)5.5, labcolor(black) tlcolor(black) labsize(medsmall) format(%5.1f)) 
		xlabel(1978 "78" 1986 "86" 1994 "94" 2002 "02" 2010 "10"  2018 "18"
        , nogrid glcolor(black) glwidth(medthin) 
		labcolor(black) tlcolor(black)  labsize(medsmall) nogrid) 
		xscale(lcolor(black)) xtitle("")
		lcolor(black) lpattern(longdash) lwidth(medthick) yscale(lcolor(black)) 
		aspectratio(1.5) ;
gr save graph/eqwlth-farming-working-combined-oegp.gph, replace ;

* combined graphs ;
gr combine 
    graph/eqwlth-salariat-combined-oegp.gph 
	graph/eqwlth-intermediate-combined-oegp.gph
	graph/eqwlth-farming-working-combined-oegp.gph
	graph/eqwlth-farming-working-combined-oegp.gph // dummy graph
	, imargin(medsmall) cols(4) ;
gr save graph/eqwlth-current-class-combined-oegp.gph, replace ;
#delimit cr

log close
