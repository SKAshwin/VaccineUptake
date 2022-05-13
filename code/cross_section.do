frame reset
macro drop _all
global raw_dir "/home/elven/Documents/College/metrics_project/data/raw"
global cleaned_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global reg_ready_dir "/home/elven/Documents/College/metrics_project/data/regression_ready"
global time_invariant "time_invariant"
global vaccuptake_31Dec "COVID-19_Vaccinations_in_the_United_States_County_31Dec2021.csv"
global vaccuptake_30Sep "COVID-19_Vaccinations_in_the_United_States_County_30Sep2021.csv"

cd "$raw_dir"
import delim "$vaccuptake_31Dec", varn(1)

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

gen lcol = log(annual_col)
gen lmedincome = log(median_family_income_2020)

*gen deaths_100k = deaths_per_capita * 100000

gen pop60to79 = pop60to64pct + pop65to69pct + pop70to74pct + pop75to79pct
gen above80 = pop80to84pct + pop85above

reg fullvaxpct repvotes2020pct whiteevangelical catholic black poverty lmedincome lcol pop60to79 above80 i.rural_rating fullcollege cases_per_capita i.statecode , r beta
di e(r2_a)

reg fullvaxpct repvotes2020pct whiteevangelical catholic black poverty lmedincome lcol pop*pct fullcollege cases_per_capita i.rural_rating i.statecode, r beta
di e(r2_a)
