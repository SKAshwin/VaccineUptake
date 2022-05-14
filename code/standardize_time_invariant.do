frame reset
macro drop _all
global cleaned_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global time_invariant "time_invariant"

cd "$cleaned_dir"
use "$time_invariant", clear

egen nmis=rmiss(*)
drop if state == "AK" | state == "HI" | state == "UT" | state == "PR"
drop if nmis > 0
* For some reason, Barnstable county missing from the vaccination records, so remove it
drop if fips == 25001
drop nmis

gen pop60to79 = pop60to64pct + pop65to69pct + pop70to74pct + pop75to79pct
gen above80 = pop80to84pct + pop85above

gen lcol = log(annual_col)
gen lmedincome = log(median_family_income_2020)

label var pop60to79 "pop60to64pct + pop65to69pct + pop70to74pct + pop75to79pct"
label var above80 "pop80to84pct + pop85above"
label var lcol "log(annual_col)"
label var lmedincome "log(median_family_income_2020)"

cd "$cleaned_dir"
save "time_invariant_standardized", replace

* If you wanna know who got culled
*. tab county_name if nmis > 2
*
*                              Area name |      Freq.     Percent        Cum.
*----------------------------------------+-----------------------------------
*                           Bedford city |          1       25.00       25.00
*                     Clifton Forge city |          1       25.00       50.00
*                   Oglala Lakota County |          1       25.00       75.00
*              Yellowstone National Park |          1       25.00      100.00
*----------------------------------------+-------------------------------
