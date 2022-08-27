frame reset
macro drop _all
global raw_dir "/home/elven/Documents/College/metrics_project/data/raw"
global cleaned_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global reg_ready_dir "/home/elven/Documents/College/metrics_project/data/regression_ready"
global time_invariant "time_invariant"
global vaccuptake "COVID-19_Vaccinations_in_the_United_States_County_Colorado_DID.csv"

****************************
* Treatnment: 25 May to 30 June

* Colorado (08) (Treated)

* Border with Kansas (20)
* Treated: 009 099 061 017 063 125
* Untreated: 129 187 075 071 199 181 023

* Border with Nebraska (31)
* Treated: 125 095 115 075 123
* Untreated: 057 029 135 101 049 033 105

* Wyoming border dodgier for "similarity" (https://www.nytimes.com/interactive/2021/upshot/2020-election-map.html)
* Border with Wyoming (56)
* Treated: 123 069 (a city here maybe!) 057 107 081
* Untreated: 021 001 007 037

cd "$cleaned_dir"
use "$time_invariant", replace

keep if inlist(fips, 8009, 8099, 8061, 8017, 8063, 8125, 8095, 8115, 8075, 8123) | inlist(fips, 20129, 20187, 20075, 20071, 20199, 20181, 20023) | inlist(fips, 31057, 31029, 31135, 31101, 31049, 31033, 31105)

gen treatedgroup = 1 if state=="CO"
replace treatedgroup = 0 if treatedgroup == .

gen pop60to79 = pop60to64pct + pop65to69pct + pop70to74pct + pop75to79pct
gen above80 = pop80to84pct + pop85above

* REPORT THIS TO JUSTIFY CHOICE OF GROUPS
bysort treatedgroup: summarize repvotes2020pct black fullcollege cases_per_capita whiteevangelical catholic poverty median_family_income_2020 pop60to79 above80 

**** ACTUAL DID ****

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


keep if inlist(fips, 8009, 8099, 8061, 8017, 8063, 8125, 8095, 8115, 8075, 8123) | inlist(fips, 20129, 20187, 20075, 20071, 20199, 20181, 20023) | inlist(fips, 31057, 31029, 31135, 31101, 31049, 31033, 31105)

gen date_parsed = date(date, "MDY")
format %td date_parsed
drop date
rename date_parsed date
order fips date state county_name

sort date state fips

gen treated = 1 if state=="CO" & date >= td(25may2021)
replace treated = 0 if treated == .

encode state, gen(statecode)

didregress (fullvaxpct) (treated), group(statecode) time(date) 

****************************
* Treatment: 4 June to 25 Aug

* Kentucky (21) (Treated)

* Border with Tennesse (47)
* Treated: 075 105 083 035 221 047 219 141 213 003 171 057 053 231 147 235 013
* Untreated: 095 131 183 079 161 125 147 165 111 027 137 151 013 025

* Border with Indiana (18)
* Treated: 225 101 059 091 027 163 111 185 223 041 077 015
* Untreated: 129 163 173 147 123 025 061 043 019 077 155

cd "$cleaned_dir"
use "$time_invariant", replace

keep if inlist(fips, 21075, 21105, 21083, 21035, 21221, 21047, 21219, 21141, 21213, 21003, 21171, 21057, 21053, 21231, 21147, 21235, 21013, 21225, 21101, 21059, 21091, 21027, 21163, 21111, 21185, 21223, 21041, 21077, 21015) | inlist(fips, 47095, 47131, 47183, 47079, 47161, 47125, 47147, 47165, 47111, 47027, 47137, 47151, 47013, 47025) | inlist(fips, 18129, 18163, 18173, 18147, 18123, 18025, 18061, 18043, 18019, 18077, 18155)

gen treatedgroup = 1 if state=="KY"
replace treatedgroup = 0 if treatedgroup == .

gen pop60to79 = pop60to64pct + pop65to69pct + pop70to74pct + pop75to79pct
gen above80 = pop80to84pct + pop85above

* REPORT THIS TO JUSTIFY CHOICE OF GROUPS
bysort treatedgroup: summarize repvotes2020pct black fullcollege cases_per_capita whiteevangelical catholic poverty median_family_income_2020 pop60to79 above80 

*** ACTUAL DID ***

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


keep if inlist(fips, 21075, 21105, 21083, 21035, 21221, 21047, 21219, 21141, 21213, 21003, 21171, 21057, 21053, 21231, 21147, 21235, 21013, 21225, 21101, 21059, 21091, 21027, 21163, 21111, 21185, 21223, 21041, 21077, 21015) | inlist(fips, 47095, 47131, 47183, 47079, 47161, 47125, 47147, 47165, 47111, 47027, 47137, 47151, 47013, 47025) | inlist(fips, 18129, 18163, 18173, 18147, 18123, 18025, 18061, 18043, 18019, 18077, 18155)

gen date_parsed = date(date, "MDY")
format %td date_parsed
drop date
rename date_parsed date
order fips date state county_name

sort date state fips

gen treated = 1 if state=="KY" & date >= td(4jun2021)
replace treated = 0 if treated == .

encode state, gen(statecode)

didregress (fullvaxpct) (treated), group(fips) time(date) 
