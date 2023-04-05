set more off
capture clear
capture log close
cls

log using log/03-gss-egp-redist-eqwlth-estimation.log, replace

use data/gss-1972-and-later-filled-in-recoded-imputed-in-sample.dta, clear

********************************************************************************
*** Sample selection
********************************************************************************
*** drop missing on outcome variable
keep if eqwlth <. | eqwlthy <.


********************************************************************************
*** Reweight according to sample size
********************************************************************************
do analysis/gss-egp-redist-rescale-weights.do


********************************************************************************
*** Over-time trends in EQWLTH
********************************************************************************
reg eqwlthr i.year i.yver [pw=wt_scaled]
margins i.year, level(95) saving(data/eqwlth-trend.dta, replace)


********************************************************************************
*** Current-class and Origin effects all years combined
********************************************************************************
*** drop military
drop if egp10_6_rf == 6 | oegp10_6_rf == 6

*** estimation *****************************************************************
*** macro covariates 
global m1 i.year##oegp10_4_rf i.yver 
global m2 c.age_pl_rf##c.age_pl_rf i.race_rf i.sex_rf i.reg16_rf i.relig16_rf i.parbornr_rf i.res16_rf
global m3  i.year##egp10_3_rf i.oegp10_4_rf#i.egp10_3_rf c.educ_pl_rf c.realinc_rf
global m4 maeduc_rf paeduc_rf
global m5 i.class_rf


*** M1: unconditional					
reg eqwlthr $m1  [pw = wt_scaled] 
// margins oegp10_4_rf, pwcompare(effects) saving(data/margins-eqwlth-m1.dta, replace)
margins i.oegp10_4_rf, saving(data/margins-eqwlth-m1.dta, replace)
// contrast i.oegp10_4_rf, effects  post  
// estimates store m1

// ** For comparison, current-class differences
// reg eqwlthr i.year##egp10_3_rf i.yver  [pw = wt_scaled] 
// margins i.egp10_3_rf,

*** M2: + adjustment for background					
reg eqwlthr $m1 $m2    [pw = wt_scaled]
// margins oegp10_4_rf, pwcompare(effects) saving(data/margins-eqwlth-m2.dta, replace)
margins i.oegp10_4_rf, saving(data/margins-eqwlth-m2.dta, replace)
// contrast i.oegp10_4_rf, effects  post
// estimates store m2

*** M3: + adjustment for parental education					
reg eqwlthr $m1 $m2 $m3  [pw = wt_scaled]
// margins oegp10_4_rf, pwcompare(effects) saving(data/margins-eqwlth-m3.dta, replace)
margins i.oegp10_4_rf, saving(data/margins-eqwlth-m3.dta, replace)
// contrast i.oegp10_6_rf, effects  post
// estimates store m2
				
*** M4: + adjustment for current SES					
reg eqwlthr $m1 $m2 $m3 $m4  [pw = wt_scaled] 
// margins oegp10_4_rf, pwcompare(effects) saving(data/margins-eqwlth-m4.dta, replace) 
margins i.oegp10_4_rf, saving(data/margins-eqwlth-m4.dta, replace) 
// contrast i.oegp10_4_rf, effects  post
// estimates store m3

*** M5: + adjustment for subjective class					
reg eqwlthr $m1 $m2 $m3 $m4 $m5  [pw = wt_scaled] 
// margins oegp10_4_rf, pwcompare(effects) saving(data/margins-eqwlth-m5.dta, replace)
margins i.oegp10_4_rf, saving(data/margins-eqwlth-m5.dta, replace)


********************************************************************************
*** Current-class and Origin effects by survey year
********************************************************************************
*** estimation
reg eqwlthr $m1 $m2 i.year##i.egp10_3_rf i.oegp10_4_rf#i.egp10_3_rf  [pw = wt_scaled]
margins i.year##oegp10_4_rf , 	///
saving(data/margins-eqwlth-oegp-by-year.dta, replace) level(95)
margins i.year##i.egp10_3_rf , 	///
saving(data/margins-eqwlth-egp-by-year.dta, replace) level(95)
		
log close
