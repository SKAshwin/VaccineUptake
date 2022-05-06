global temp_dir "/home/elven/Documents/College/metrics_project/data/temp"
global dta_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global csv_name "epi_col.csv"
global dta_name "epi_col.dta"

cd "$temp_dir"

import delim "$csv_name", clear

drop related_areas
drop value
label variable rent "Per month"
label variable food "Per month"
label variable child_care "Per month"
label variable transportation "Per month"
label variable hcare "Per month"
label variable other "Per month"
label variable taxes "Per month"
rename total monthly_col 
rename total_annual annual_col
label variable monthly_col "Total monthly cost of living"
label variable annual_col "Total annual cost of living"

cd "$dta_dir"
save "$dta_name", replace
