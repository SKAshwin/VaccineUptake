frame reset
macro drop _all
global raw_dir "/home/elven/Documents/College/metrics_project/data/raw"
global cleaned_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global reg_ready_dir "/home/elven/Documents/College/metrics_project/data/regression_ready"
global time_invariant "time_invariant"
global vaccuptake "COVID-19_Vaccinations_in_the_United_States_County_Colorado_DID.csv"
global adjacencymap "county_adjacency2010.dta"

****************************
* Treatnment: 25 May to 30 June

* Colorado (08) (Treated)

* Border with Kansas (20)
* Treated: 009 099 061 017 063 125
* Untreated: 129 187 075 071 199 181 023

* Border with Nebraska (31)
* Treated: 125 095 115 075 123
* Untreated: 057 029 135 101 049 033 105

* Border with Oklahoma
* Treated: 009
* Untreated: 025

global treatedlist "8009, 8099, 8061, 8017, 8063, 8125, 8095, 8115, 8075, 8123"
global untreated_kansas "20129, 20187, 20075, 20071, 20199, 20181, 20023"
global untreated_nebraska "31057, 31029, 31135, 31101, 31049, 31033, 31105"
global untreated_oklahoma "40025"
global untreatedlist "$untreated_kansas, $untreated_nebraska, $untreated_oklahoma"

cd "$cleaned_dir"
use "$time_invariant", replace

keep if inlist(fips, $treatedlist) | inlist(fips, $untreatedlist)
gen treatedgroup = 1 if state=="CO"
replace treatedgroup = 0 if treatedgroup == .

gen pop60to79 = pop60to64pct + pop65to69pct + pop70to74pct + pop75to79pct
gen above80 = pop80to84pct + pop85above

* REPORT THIS TO JUSTIFY CHOICE OF GROUPS
bysort treatedgroup: summarize repvotes2020pct black fullcollege cases_per_capita whiteevangelical catholic poverty median_family_income_2020 pop60to79 above80 

*** Generate Pairs ***

*** First filter down to relevant pairs in the adjacency map
*** IE keep pairs if one county in CO and one in neighbor state, OR
*** one in neighbor state and one in CO

cd "$cleaned_dir"
use "$adjacencymap", clear

gen fips = real(fipscounty)
gen fipsadjacent = real(fipsneighbor)

order fips fipscounty countyname fipsadjacent fipsneighbor neighborname
drop if fipsadjacent == fips

keep if (inlist(fips, $treatedlist) & inlist(fipsadjacent, $untreatedlist )) | ///
         (inlist(fips,  $untreatedlist) & inlist(fipsadjacent, $treatedlist ))

* Generate a pair ID, unique to each pair 
* Each pair ID should appear twice in this dataset!
gen pairidstring = fipscounty + "-" + fipsneighbor if fipscounty < fipsneighbor
replace pairidstring = fipsneighbor + "-" + fipscounty if fipscounty > fipsneighbor
encode pairidstring, gen(pairid)
drop fipscounty fipsneighbor

* Expand into panel, for later merging
expand 61
bysort fips fipsadjacent: gen t =_n
gen date = td(30apr2021) + t
format %td date
drop t

save "coloradodidpairs", replace

**** Estimate time

cd "$raw_dir"
import delim "$vaccuptake", varn(1) clear

keep date fips recip_county recip_state administered_dose1_pop_pct administered_dose1_recip_18plusp ///
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


keep if inlist(fips, $treatedlist) | inlist(fips, $untreatedlist)

gen date_parsed = date(date, "MDY")
format %td date_parsed
drop date
rename date_parsed date
order fips date state county_name

sort date state fips

cd "$cleaned_dir"
merge 1:m fips date using "coloradodidpairs"
drop _m
drop countyname

gen pairiddatestring = pairidstring + string(date,"%td")
encode pairiddatestring, gen(pairdateid)

drop if date <= td(25may2021)-7 | date >= td(25may2021)+7

gen treated = 1 if state=="CO" & date >= td(25may2021)
replace treated = 0 if treated == .

reg fullvaxpct treated i.pairdateid i.fips
reg dose1pct treated i.pairdateid i.fips
