frame reset
macro drop _all
global raw_dir "/home/elven/Documents/College/metrics_project/data/raw"
global cleaned_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global reg_ready_dir "/home/elven/Documents/College/metrics_project/data/regression_ready"
global est_dir "/home/elven/Documents/College/metrics_project/estimates"
global tables_dir "/home/elven/Documents/College/metrics_project/raw_tables"
global synth_dir "/home/elven/Documents/College/metrics_project/synth"
global time_invariant "time_invariant_standardized"
global vaccuptake "COVID-19_Vaccinations_in_the_United_States_County_Colorado_DID.csv"
global stateuptake "COVID-19_Vaccination_Trends_in_the_United_States_National_and_Jurisdictional.csv"

cd "$cleaned_dir"
use "$time_invariant"
bysort state: egen statepop = total(totalpop)
gen statepopshare = totalpop/statepop

ds, has(type numeric)
collapse (mean) `r(varlist)' [aweight=statepopshare], by(state)

drop fips
drop statepopshare

cd "$cleaned_dir"
save "state_time_invariant", replace

cd "$raw_dir"
import delim "$stateuptake", varn(1) clear
keep if date_type == "Admin"

keep date location admin_dose_1_daily administered_dose1_pop_pct series_complete_daily series_complete_pop_pct

rename location state
rename admin_dose_1_daily dDose1cnt
rename administered_dose1_pop_pct dose1pct
rename series_complete_daily dFullvaxcnt
rename series_complete_pop_pct fullvaxpct

gen date_parsed = date(date, "MDY")
format %td date_parsed
drop date
rename date_parsed date
gen t = date - td(25may2021)

encode state, gen(statecode)

xtset statecode t

cd "$cleaned_dir"
merge m:1 state using "state_time_invariant"
keep if _m == 3

drop if inlist(state, "CT", "NJ", "MN", "OH", "MD", "NY", "OR", "DE", "NM")
drop if inlist(state, "WA", "KY", "NC", "MA", "ME", "IL", "LA", "NV", "MI")
drop if inlist(state, "MO", "WV", "AR", "CA")

gen dFullvaxpct = dFullvaxcnt/statepop
gen dDose1pct = dDose1cnt/statepop

replace t = t+40
rename median_family_income_2020 medfamilinc

cd "$synth_dir"

log using "synth_output", replace

allsynth dose1pct repvotes2020pct black fullcollege cases_per_capita whiteevangelical catholic poverty medfamilinc pop0to4pct pop5to9pct pop10to14pct pop15to19pct pop60to64pct pop65to69pct pop70to74pct pop75to79pct pop80to84pct pop85abovepct, trunit(7) trperiod(40) bcorrect(merge) gapfigure(bcorrect, save(synthcontrolresults_dose1_gph.svg, replace)) keep(synthcontrolresults_dose1, replace) pvalues

allsynth fullvax repvotes2020pct black fullcollege cases_per_capita whiteevangelical catholic poverty medfamilinc pop0to4pct pop5to9pct pop10to14pct pop15to19pct pop60to64pct pop65to69pct pop70to74pct pop75to79pct pop80to84pct pop85abovepct, trunit(7) trperiod(40) bcorrect(merge) gapfigure(bcorrect, save(synthcontrolresults_fullvax_gph.svg, replace)) keep(synthcontrolresults_fullvax, replace) pvalues

allsynth dDose1pct repvotes2020pct black fullcollege cases_per_capita whiteevangelical catholic poverty medfamilinc pop0to4pct pop5to9pct pop10to14pct pop15to19pct pop60to64pct pop65to69pct pop70to74pct pop75to79pct pop80to84pct pop85abovepct, trunit(7) trperiod(40) bcorrect(merge) gapfigure(bcorrect, save(synthcontrolresults_ddose1_gph.svg, replace)) keep(synthcontrolresults_ddose, replace) pvalues

allsynth dFullvaxpct repvotes2020pct black fullcollege cases_per_capita whiteevangelical catholic poverty medfamilinc pop0to4pct pop5to9pct pop10to14pct pop15to19pct pop60to64pct pop65to69pct pop70to74pct pop75to79pct pop80to84pct pop85abovepct, trunit(7) trperiod(40) bcorrect(merge) gapfigure(bcorrect, save(synthcontrolresults_dfullvax_gph.svg, replace)) keep(synthcontrolresults_dfullvax, replace) pvalues

translate synth_output.smcl synth_output.log, replace
translate synth_output.smcl synth_output.pdf, replace
