set more off
capture clear
capture log close
cls

log using log/05-gss-egp-redist-tax-estimation.log, replace

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
*** Model fit comparison
********************************************************************************
*** drop military
drop if egp10_6_rf == 6 | oegp10_6_rf == 6

global period i.year
global period_origin i.year i.oegp10_4_rf
global period_peduc i.year peduc
global period_origin_peduc i.year i.oegp10_4_rf peduc
global period_class i.year i.egp10_3_rf
global period_class_origin i.year i.egp10_3_rf i.oegp10_4_rf
global period_class_peduc i.year i.egp10_3_rf peduc
global period_class_educ_inc i.year realinc_rf educ_pl_rf i.oegp10_4_rf
global period_class_educ_inc_origin i.year realinc_rf educ_pl_rf i.egp10_3_rf i.oegp10_4_rf
global period_class_educ_inc_peduc i.year realinc_rf educ_pl_rf i.egp10_3_rf peduc

qui logit taxr  $period  [pw=wt_scaled]
estat ic
mat m1 = r(S)

qui logit taxr  $period_origin  [pw=wt_scaled]
estat ic
mat m2 = r(S)

qui logit taxr  $period_peduc [pw=wt_scaled]
estat ic
mat m3 = r(S)

qui logit taxr $period_origin_peduc [pw=wt_scaled]
estat ic
mat m4 = r(S)

qui logit taxr $period_class  [pw=wt_scaled]
estat ic
mat m5 = r(S)

qui logit taxr $period_class_origin [pw=wt_scaled]
estat ic
mat m6 = r(S)

qui logit taxr $period_class_peduc  [pw=wt_scaled]
estat ic
mat m7 = r(S)

qui logit taxr $period_class_educ_inc  [pw=wt_scaled]
estat ic
mat m8 = r(S)

qui logit taxr $period_class_educ_inc_origin  [pw=wt_scaled]
estat ic
mat m9 = r(S)

qui logit taxr $period_class_educ_inc_peduc  [pw=wt_scaled]
estat ic
mat m10 = r(S)

********************************************************************************
*** Generate an Excel spreadsheet
********************************************************************************

putexcel set docs/model-comparison.xlsx, sheet("TAX", replace) modify
 
putexcel B1 = "df"  C1="AIC" D1="BIC" ///
		 E1 = "AIC Diff." 	 F1 = "BIC Diff." ///
		 A2 = "Model a" A3 = "Model b" A4 = "Model c" A5 = "Model d" ///  
		 A6 = "Model e" A7 = "Model f" A8 = "Model g" A9 = "Model h" ///  
		 A10 = "Model i"  A11 = "Model J"  
		 
forval i = 1(1)10 {
	
	local j = `i' + 1
	
	mat AIC_diff = m`i'[1,5] - m1[1,5] 
	mat BIC_diff =  m`i'[1,6] - m1[1,6] /// AIC, BIC deviations from baseline

 putexcel ///
	B`j' = m`i'[1,4] ///
	C`j' = m`i'[1,5]  D`j' = m`i'[1,6] ///
	E`j' = AIC_diff[1,1]  F`j' = BIC_diff[1,1] 
}

log close
