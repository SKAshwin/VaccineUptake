frame reset
macro drop _all
global raw_dir "/home/elven/Documents/College/metrics_project/data/raw"
global cleaned_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global synth_dir "/home/elven/Documents/College/metrics_project/synth"
global time_invariant "time_invariant_standardized"
global vaccuptake "COVID-19_Vaccinations_in_the_United_States_County_Colorado_DID.csv"


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
gen t = date - td(25may2021)
xtset fips t

gen dFullvaxcnt = d.fullvaxcnt
gen dDose1cnt = d.dose1cnt

gen dFullvaxpct = dFullvaxcnt/census2019 *100
gen dDose1pct = dDose1cnt/census2019 *100

cd "$cleaned_dir"
merge m:1 fips using "$time_invariant"
keep if _m == 3

bysort state: egen statepop = total(totalpop)
gen statepopshare = totalpop/statepop

gen treated = 1 if date >= td(25may2021) & fips == 8013
replace treated = 0 if treated == .

order t

replace t = t+24

*8013
drop if (state == "CO" & fips != 8013 & fips != 8123 & fips != 8121) 
drop if inlist(state, "CT", "NJ", "MN", "OH", "MD", "NY", "OR", "DE", "NM")
drop if inlist(state, "WA", "KY", "NC", "MA", "ME", "IL", "LA", "NV", "MI")
drop if inlist(state, "MO", "WV", "AR", "CA")

keep if inlist(state, "KS", "OK", "NE", "TX", "WY", "AZ", "MO", "CO", "IA")

gen treatedgroup = 1 if state == "CO"
replace treatedgroup = 0 if treatedgroup == .

gen treatedperiod = td(25may2021) if state == "CO"

* READ WHAT BIAS CORRECTION IS ABOUT
* Expand to full list of variables and full counties, and move on

rename median_family_income_2020 medfamilinc

cd "$synth_dir"

xtset fips date

*allsynth dose1pct repvotes2020pct black fullcollege cases_per_capita whiteevangelical catholic poverty medfamilinc pop0to4pct pop5to9pct pop10to14pct pop15to19pct pop20to24pct pop25to29pct pop30to34pct pop35to39pct pop40to44pct pop45to49pct pop50to54pct pop55to59pct pop60to64pct pop65to69pct pop70to74pct pop75to79pct pop80to84pct, trunit(8013) trperiod(24) bcorrect(merge) gapfigure(bcorrect, save(county_synthcontrolresults_dose1_gph.svg, replace)) keep(county_synthcontrolresults_dose1, replace)

log using "synth_output"

allsynth dose1pct repvotes2020pct black fullcollege cases_per_capita whiteevangelical, stacked(trunits(treatedgroup) trperiods(treatedperiod), clear avgweights(statepopshare) figure(classic, save(county_synthcontrolresults_dose1_gph.svg, replace))) keep(county_synthcontrolresults_dose1, replace)

*allsynth dose1pct repvotes2020pct black fullcollege cases_per_capita whiteevangelical catholic poverty medfamilinc pop0to4pct pop5to9pct pop10to14pct pop15to19pct pop20to24pct pop25to29pct pop30to34pct pop35to39pct pop40to44pct pop45to49pct pop50to54pct pop55to59pct pop60to64pct pop65to69pct pop70to74pct pop75to79pct pop80to84pct, stacked(trunits(treatedgroup) trperiods(treatedperiod), clear avgweights(statepopshare) figure(classic, save(county_synthcontrolresults_dose1_gph.svg, replace))) keep(county_synthcontrolresults_dose1, replace)

translate synth_output.smcl synth_output.log
translate synth_output.smcl synth_output.pdf
