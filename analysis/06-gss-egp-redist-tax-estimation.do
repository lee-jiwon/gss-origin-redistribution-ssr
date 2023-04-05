set more off
capture clear
capture log close
cls

log using log/06-gss-egp-redist-tax-estimation.log, replace

use data/gss-1972-and-later-filled-in-recoded-imputed-in-sample.dta, clear

********************************************************************************
*** Sample selection
********************************************************************************

*** drop missing on all outcome variables
drop if tax >=. | tax==4

********************************************************************************
*** Reweight according to sample size
********************************************************************************
do analysis/gss-egp-redist-rescale-weights.do
 
********************************************************************************
*** Over-time trends in TAX
********************************************************************************
logit taxr i.year  [pw=wt_scaled]
margins i.year, level(95) saving(data/margins-tax-trends.dta, replace)

********************************************************************************
*** Current-class and Origin effects all years combined
********************************************************************************
*** drop military
drop if egp10_6_rf == 6 | oegp10_6_rf == 6

*** estimation *****************************************************************

*** macro covariates 
global m1 i.year##oegp10_4_rf 
global m2 c.age_pl_rf##c.age_pl_rf i.sex_rf i.race_rf i.reg16_rf i.relig16_rf i.parbornr_rf i.res16_rf
global m3 i.year##egp10_3_rf i.oegp10_4_rf#i.egp10_3_rf c.educ_pl_rf c.realinc_rf
global m4  maeduc_rf paeduc_rf
global m5 i.class_rf

*** M1: unconditional					
logit taxr $m1   [pw = wt_scaled] 
// margins oegp10_4_rf, pwcompare(effects) saving(data/margins-tax-m1.dta, replace)
margins i.oegp10_4_rf, saving(data/margins-tax-m1.dta, replace)
// contrast i.oegp10_4_rf, effects  post  
// estimates store m1

*** adjustment for education					
logit taxr $m1 $m2   [pw = wt_scaled]
// margins oegp10_4_rf, pwcompare(effects) saving(data/margins-tax-m2.dta, replace)
margins i.oegp10_4_rf, saving(data/margins-tax-m2.dta, replace)
// contrast i.oegp10_4_rf, effects  post
// estimates store m2

*** adjustment for education					
logit taxr $m1 $m2 $m3    [pw = wt_scaled]
// margins oegp10_4_rf, pwcompare(effects) saving(data/margins-tax-m3.dta, replace)
margins i.oegp10_4_rf,  saving(data/margins-tax-m3.dta, replace)
// contrast i.oegp10_4_rf, effects  post
// estimates store m2


*** estimation: adjustment for income					
logit taxr $m1 $m2 $m3 $m4   [pw = wt_scaled] 
// margins oegp10_4_rf, pwcompare(effects) saving(data/margins-tax-m4.dta, replace)
margins i.oegp10_4_rf, saving(data/margins-tax-m4.dta, replace)
// contrast i.oegp10_4_rf, effects  post
// estimates store m3


*** estimation: adjustment for income					
logit taxr $m1 $m2 $m3 $m4 $m5 [pw = wt_scaled] 
// margins oegp10_4_rf, pwcompare(effects) saving(data/margins-tax-m5.dta, replace)
margins i.oegp10_4_rf, saving(data/margins-tax-m5.dta, replace)


********************************************************************************
*** Current-class and Origin effects by survey year
********************************************************************************

logit taxr $m1 $m2 i.year##i.egp10_3_rf i.oegp10_4_rf#i.egp10_3_rf [pw = wt_scaled]
margins i.year##oegp10_4_rf , 	///
saving(data/margins-tax-oegp-by-year, replace) level(95)
margins i.year##i.egp10_3_rf , 	///
saving(data/margins-tax-egp-by-year, replace) level(95) 


log close					
