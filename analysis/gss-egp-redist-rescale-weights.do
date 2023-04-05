tab year
local N `r(N)'
local levels `r(r)'
bys year: egen wtcomb_sum = total(wtcomb)
bys year: sum wtcomb wtcomb_sum 
gen wt_scaled = (`N'/`levels')*(wtcomb / wtcomb_sum) 
bys year: sum wt_scaled 
bys year: corr wtcomb wt_scaled