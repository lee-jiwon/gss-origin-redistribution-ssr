# gss-origin-redistribution-ssr

## Overview

#### This repository provides replication materials for:

* Lee, Jiwon. 2023. ”Consider Your Origins: Social Class and Preference for Redistribution in the United States from 1977 to 2018.” Social Science Research 110: 102840

## Road map of code 

The content below is copied from the file, roadmap-for-gss-origin-redistribution-ssr.txt, which can be found in the docs folder of the repository.

### Notes

1.  The working directory in Stata should be set to the top directory (i.e., the one that includes the folders: analysis, data, docs, graph, log, old).  If using as a GitHub repository, and when stored locally in a folder "GitHub," the working directory would be set as the main repository folder for the project:

    GitHub/gss-origin-redistribution-ssr

preceded, as necessary, by any machine-specific location information that indicates where the GitHub folder is located.


2.  The data file (stata .dta file)

	gss-1972-and-later-filled-in-recoded-imputed-in-sample.dta

must be downloaded from [HERE](https://www.dropbox.com/scl/fo/ys78iii2eo952ab7bx9dq/h?dl=0&rlkey=cs33pcs5btwses89loy8rp9rm) and placed into the /data folder before executing any do-files. 

This data file contains imputed and recoded variables, with "_pl" denoting logical imputation using 2006-2014 GSS panels, and "_rf" representing variables with model imputations using the -MissForest- package in R, merged to the original GSS 1972-2018 cross-sectional cumulative years data (release 1, "GSS7218_R1.dta")


3.  It is recommended that do files must be run in order and can be run with the file:

	do-all-to-replicate-lee-2023-ssr



### Roadmap for the code

1.	analysis/01-gss-egp-redist-class-distribution.do, log

Plot the distribution of class origins and current classes (Figure 1 in Lee 2023). 


	Takes in:
		data/gss-1972-and-later-recoded-and-imputed.dta [external data]
		[Note: This data file contains imputed and recoded variables, with "_pl" denoting logical imputation using 2006-2014 GSS panels, 
		and "_rf" representing variables with model imputations using the -MissForest- package
		in R, merged to the original GSS 1972-2018 cross-sectional cumulative years data (release 1, "GSS7218_R1.dta")]

	Calls: 
		 analysis/gss-egp-redist-rescale-weights.do

	Yields: 
		graph/egp6-dist-survey-year.gph, pdf
		graph/oegp6-dist-survey-year.gph, pdf
		graph/egp6-oegp6-dist-survey-year.gph, png, pdf (Figure 1)



2.	analysis/02-gss-egp-redist-eqwlth-model-fit, log

Compare model fit for various models for EQWLTH

	Takes in:
		data/gss-1972-and-later-recoded-and-imputed.dta 

	Calls: 
		 analysis/gss-egp-redist-rescale-weights.do

	Yiedls:
		docs/model-comparison.xlsx (sheet "EQWLTH", Table 4 panel a)



3.	analysis/03-gss-egp-redist-eqwlth-estimation.do, log

Estimate models for EQWLTH and store the results

	Takes in:
		data/gss-1972-and-later-recoded-and-imputed.dta

	Calls: 
		 analysis/gss-egp-redist-rescale-weights.do

	Yields: 
		data/eqwlth-trend.dta 

		data/margins-eqwlth-m1.dta
		data/margins-eqwlth-m2.dta
		data/margins-eqwlth-m3.dta
		data/margins-eqwlth-m4.dta
		data/margins-eqwlth-m5.dta

		data/margins-eqwlth-oegp-by-year.dta
		data/margins-eqwlth-egp-by-year.dta



4.	analysis/04-gss-egp-redist-eqwlth-mk-graphs.do, log

Call in the estimates and make figures with it for EQWLTH

	Takes in:
		rawdata/income-inequality-census-equ-adjusted.xls (for Figure 2)
		data/eqwlth-trend.dta

		data/margins-eqwlth-m1.dta
		data/margins-eqwlth-m2.dta
		data/margins-eqwlth-m3.dta
		data/margins-eqwlth-m4.dta
		data/margins-eqwlth-m5.dta

		data/margins-eqwlth-oegp-by-year.dta
		data/margins-eqwlth-egp-by-year.dta

	Yields: 
		graph/eqwlth-trend.gph, pdf (figure 2-a)	
		graph/eqwlth-oegp.gph, pdf (figure 3-a)

		graph/eqwlth-combined-salariat-oegp.gph
		graph/eqwlth-combined-intermediate-oegp.gph
		graph/eqwlth-combined-farming-oegp.gph
		graph/eqwlth-working-combined-oegp.gph
		graph/eqwlth-class-origin-combined-oegp.gph (figure 4-a)

 		graph/eqwlth-salariat-combined-oegp.gph
		graph/eqwlth-intermediate-combined-oegp.gph
		graph/eqwlth-farming-working-combined-oegp.gph
		graph/eqwlth-current-class-combined-oegp.gph (figure 4-b)


5.	analysis/05-gss-egp-redist-tax-model-fit.do, log	

Compare model fit for various models for TAX

	Takes in:
		data/gss-1972-and-later-recoded-and-imputed.dta

	Calls: 
		 analysis/gss-egp-redist-rescale-weights.do

	Yiedls:
		docs/model-comparison.xlsx (sheet "TAX", Table 4 panel a)



6. 	analysis/06-gss-egp-redist-tax-estimation.do, log

Estimate models for TAX and store the results

	Takes in:
		data/gss-1972-and-later-recoded-and-imputed.dta

	Yields: 
		data/margins-tax-trends.dta

		data/margins-tax-m1.dta
		data/margins-tax-m2.dta
		data/margins-tax-m3.dta
		data/margins-tax-m4.dta
		data/margins-tax-m5.dta

		data/margins-tax-oegp-by-year.dta
		data/margins-tax-egp-by-year.dta



7.	analysis/07-gss-egp-redist-tax-mk-graphs.do, log

Call in the estimates and make figures with it for TAX

	Takes in:
		rawdata/marginal-tax-rate.xlsx

		data/margins-tax-egp-by-year.dta
		data/margins-tax-oegp-by-year.dta

	Yields: 
		data/margins-tax-trends.dta
		graph/tax-trend.pdf, gph
		graph/eqwlth-tax-trend.pdf, gph (Figure 2)

		graph/tax-oegp.gph, pdf (Figure 3-b)

		graph/tax-salariat-origin.gph
		graph/tax-intermediate-origin.gph
		graph/tax-farming-origin.gph
		graph/tax-working-origin.gph
		graph/tax-class-origin-combined.gph (Figure 5-a)

		graph/tax-salariat-class.gph
		graph/tax-intermediate-class.gph
		graph/tax-farming-working-class.gph
		graph/tax-current-class-combined.gph (Figure 5-b)
	


8.	analysis/08-gss-egp-redist-descriptive-table.do, log

Generate the tables with descriptive statistics 

	Takes in:
		data/gss-1972-and-later-recoded-and-imputed.dta
	Yields:
		docs/descriptives-indep.csv (Table S3)
		docs/descriptives-eqwlth.csv (Table 3 top panel)
		docs/descriptives-taxr.csv (Table 3 bottom panel)
