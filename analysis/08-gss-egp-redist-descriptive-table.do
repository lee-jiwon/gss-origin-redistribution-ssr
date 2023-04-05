set more off
capture clear
capture log close
cls

log using log/08-gss-egp-redist-descriptive-table.log, replace

use data/gss-1972-and-later-filled-in-recoded-imputed-in-sample.dta, clear

// need to install estout (if not already)
/// ssc install estout, replace

********************************************************************************
*** Reweight according to sample size
********************************************************************************
do analysis/gss-egp-redist-rescale-weights.do

********************************************************************************
*** Descriptives
********************************************************************************
global varlist /// 
		age_pl_rf i.sex_rf i.race_rf i.parbornr_rf i.reg16_rf i.res16_rf ///
		i.relig16_r educ_pl_rf maeduc_rf paeduc_rf realinc_rf ///
		i.egp10_6_rf i.class_rf

*** inpendent variables
mean $varlist [pw=wt_scaled], cformat(%9.2f)
estimates store S1
mean $varlist [pw=wt_scaled] if oegp10_6_rf == 1,  cformat(%9.2f)
estimates store S2
mean $varlist [pw=wt_scaled] if oegp10_6_rf == 2,  cformat(%9.2f)
estimates store S3
mean $varlist [pw=wt_scaled] if oegp10_6_rf == 3,  cformat(%9.2f)
estimates store S4
mean $varlist [pw=wt_scaled] if oegp10_6_rf == 4,  cformat(%9.2f)
estimates store S5
mean $varlist [pw=wt_scaled] if oegp10_6_rf == 6,  cformat(%9.2f)
estimates store S6

esttab S1 S2 S3 S4 S5 S6 using  docs/descriptives-indep.csv, main(b) aux(sd) nostar label   nonumber replace ///
 mtitle("All" "Salariat" "Intermediate" "Farming" "Working" "Military" )

*** EQWLTH
mean eqwlthr [pw=wt_scaled], cformat(%9.2f)
estimates store S1
mean eqwlthr [pw=wt_scaled] if oegp10_6_rf == 1,  cformat(%9.2f)
estimates store S2
mean eqwlthr [pw=wt_scaled] if oegp10_6_rf == 2,  cformat(%9.2f)
estimates store S3
mean eqwlthr [pw=wt_scaled] if oegp10_6_rf == 3,  cformat(%9.2f)
estimates store S4
mean eqwlthr [pw=wt_scaled] if oegp10_6_rf == 4,  cformat(%9.2f)
estimates store S5
mean eqwlthr [pw=wt_scaled] if oegp10_6_rf == 6,  cformat(%9.2f)
estimates store S6
esttab S1 S2 S3 S4 S5 S6 using  docs/descriptives-eqwlth.csv, main(b) aux(sd) nostar label  nonumber replace ///
mtitle("All" "Salariat" "Intermediate" "Farming" "Working" "Military" )


*** TAX
mean taxr [pw=wt_scaled], cformat(%9.2f)
estimates store S1
mean taxr [pw=wt_scaled] if oegp10_6_rf == 1,  cformat(%9.2f)
estimates store S2
mean taxr [pw=wt_scaled] if oegp10_6_rf == 2,  cformat(%9.2f)
estimates store S3
mean taxr [pw=wt_scaled] if oegp10_6_rf == 3,  cformat(%9.2f)
estimates store S4
mean taxr [pw=wt_scaled] if oegp10_6_rf == 4,  cformat(%9.2f)
estimates store S5
mean taxr [pw=wt_scaled] if oegp10_6_rf == 6,  cformat(%9.2f)
estimates store S6
esttab S1 S2 S3 S4 S5 S6 using  docs/descriptives-taxr.csv, main(b) aux(sd) nostar label  nonumber replace ///
mtitle("All" "Salariat" "Intermediate" "Farming" "Working" "Military" )


log close


