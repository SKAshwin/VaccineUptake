* Catholic DiD
* Get data over mid July-mid september
* Treatment on 18 August 2021

* Try DiD 10-18 avg vs 18-26 avg, Catholic weighted
* Try the DiD method with many time periods as well (a panel regression of sorts)

frame reset
macro drop _all
global raw_dir "/home/elven/Documents/College/metrics_project/data/raw"
global cleaned_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global reg_ready_dir "/home/elven/Documents/College/metrics_project/data/regression_ready"
global est_dir "/home/elven/Documents/College/metrics_project/estimates"
global tables_dir "/home/elven/Documents/College/metrics_project/raw_tables"
global time_invariant "time_invariant_standardized"
global vaccuptake "COVID-19_Vaccinations_in_the_United_States_County_Catholic_DID.csv"

cd "$raw_dir"
import delim "$vaccuptake", varn(1) clear

keep date fips recip_county recip_state administered_dose1_pop_pct administered_dose1_recip_18plusp ///
	series_complete_pop_pct series_complete_18pluspop_pct ///
	booster_doses_vax_pct booster_doses_18plus_vax_pct ///
	administered_dose1_recip series_complete_yes census2019

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
rename administered_dose1_recip dose1cnt
rename series_complete_yes fullvaxcnt

gen date_parsed = date(date, "MDY")
format %td date_parsed
drop date
rename date_parsed date
order fips date state county_name
xtset fips date

sort date state fips
xtset fips date
gen dFullvaxcnt = d.fullvaxcnt
gen dDose1cnt = d.dose1cnt

gen dFullvaxpct = dFullvaxcnt/census2019 *100
gen dDose1pct = dDose1cnt/census2019 *100

cd "$cleaned_dir"
merge m:1 fips using "$time_invariant"
keep if _m == 3

gen treated = 1 if date >= td(18aug2021)
replace treated = 0 if treated == .

gen t = date - td(18aug2021)
gen t2 = t^2

encode state, gen(statecode)

reg fullvaxpct t t2 c.catholic#i.treated catholic c.catholic#c.t c.catholic#c.t2 c.t#i.statecode i.statecode

gen tfixed = date - td(1july2021)

reg fullvaxpct catholic c.catholic#c.t c.catholic#c.t2 repvotes2020pct c.repvotes2020pct#c.t i.tfixed i.statecode
