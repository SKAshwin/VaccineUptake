frame reset
macro drop _all
global raw_dir "/home/elven/Documents/College/metrics_project/data/raw"
global cleaned_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global reg_ready_dir "/home/elven/Documents/College/metrics_project/data/regression_ready"
global est_dir "/home/elven/Documents/College/metrics_project/estimates"
global time_invariant "time_invariant_standardized"
*global date 31Dec
global date 1Jun
global vaccuptake "COVID-19_Vaccinations_in_the_United_States_County_${date}2021.csv"

cd "$raw_dir"
import delim "$vaccuptake", varn(1)

keep fips recip_county recip_state administered_dose1_pop_pct administered_dose1_recip_18plusp ///
	series_complete_pop_pct series_complete_18pluspop_pct ///
	booster_doses_vax_pct booster_doses_18plus_vax_pct

drop if fips == "UNK"
gen fipsnum = real(fips)
order fips fipsnum
drop fips
rename fipsnum fips

rename recip_county county_name
rename recip_state state
rename administered_dose1_pop_pct dose1pct
rename administered_dose1_recip_18plusp dose1pct_adult
rename series_complete_pop_pct fullvaxpct
rename series_complete_18pluspop_pct fullvaxpct_adult
rename booster_doses_vax_pct boosterpct
rename booster_doses_18plus_vax_pct boosterpct_adult

cd "$cleaned_dir"

merge 1:1 fips using "$time_invariant"

* Drop the weird counties we're missing data for
keep if _m == 3
drop _m

encode state, gen(statecode)
order fips county_name state statecode

* Save the exact dataset used in the regression
cd "$reg_ready_dir"
save "cross_section_${date}", replace

cd "$est_dir"
reg fullvaxpct repvotes2020pct whiteevangelical catholic black poverty lmedincome lcol pop60to79 above80 i.rural_rating fullcollege cases_per_capita i.statecode , r beta
est save cross_section_fullvax_short_${date}, replace

* White Test
predict yhat
gen yhat2 = yhat^2
gen uhat = fullvaxpct - yhat
gen uhat2 = uhat^2
reg uhat2 yhat yhat2
est save cross_section_fullvax_short_${date}_white, replace
drop yhat yhat2 uhat uhat2

reg dose1pct repvotes2020pct whiteevangelical catholic black poverty lmedincome lcol pop60to79 above80 i.rural_rating fullcollege cases_per_capita i.statecode , r beta
est save cross_section_dose1_short_${date}, replace

* White Test
predict yhat
gen yhat2 = yhat^2
gen uhat = fullvaxpct - yhat
gen uhat2 = uhat^2
reg uhat2 yhat yhat2
est save cross_section_dose1_short_${date}_white, replace
drop yhat yhat2 uhat uhat2

reg fullvaxpct repvotes2020pct whiteevangelical catholic black poverty lmedincome lcol pop*pct fullcollege cases_per_capita i.rural_rating i.statecode, r beta
est save cross_section_fullvax_full_${date}, replace

* White Test
predict yhat
gen yhat2 = yhat^2
gen uhat = fullvaxpct - yhat
gen uhat2 = uhat^2
reg uhat2 yhat yhat2
est save cross_section_fullvax_full_${date}_white, replace
drop yhat yhat2 uhat uhat2

reg dose1pct repvotes2020pct whiteevangelical catholic black poverty lmedincome lcol pop*pct fullcollege cases_per_capita i.rural_rating i.statecode, r beta
est save cross_section_dose1_full_${date}, replace

* White Test
predict yhat
gen yhat2 = yhat^2
gen uhat = fullvaxpct - yhat
gen uhat2 = uhat^2
reg uhat2 yhat yhat2
est save cross_section_dose1_full_${date}_white, replace
drop yhat yhat2 uhat uhat2
