frame reset
macro drop _all
eststo clear
global raw_dir "/home/elven/Documents/College/metrics_project/data/raw"
global cleaned_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global est_dir "/home/elven/Documents/College/metrics_project/estimates"
global tables_dir "/home/elven/Documents/College/metrics_project/raw_tables"
global time_invariant "time_invariant_standardized"
global vaccuptake "COVID-19_Vaccinations_in_the_United_States_County_Monthly.csv"

cd "$raw_dir"
import delim "$vaccuptake", varn(1)

keep date fips recip_county recip_state series_complete_pop_pct 

drop if fips == "UNK"
gen fipsnum = real(fips)
order fips fipsnum
drop fips
rename fipsnum fips

rename recip_county county_name
rename recip_state state
rename series_complete_pop_pct fullvaxpct

cd "$cleaned_dir"

merge m:1 fips using "$time_invariant"

* Drop the weird counties we're missing data for
keep if _m == 3
drop _m

encode state, gen(statecode)

gen date_parsed = date(date, "MDY")
format %td date_parsed
drop date
rename date_parsed date

xtset fips date
bysort fips: gen t = _n
order fips date t county_name state statecode

gen t2 = t^2

* We're missing 1 april data for some states, so
drop if date == td(1apr2022) 

eststo linear: reg fullvaxpct repvotes2020pct whiteevangelical catholic black poverty lmedincome lcol pop60to79 above80 fullcollege cases_per_capita i.statecode c.t#c.repvotes2020pct c.t#c.whiteevangelical c.t#c.catholic c.t#c.black c.t#c.poverty c.t#c.lmedincome c.t#c.lcol c.t#c.pop60to79 c.t#c.above80 c.t#c.fullcollege c.t#c.cases_per_capita c.t#i.statecode, vce(cluster fips)

eststo quadratic: reg fullvaxpct repvotes2020pct whiteevangelical catholic black poverty lmedincome lcol pop60to79 above80 fullcollege cases_per_capita i.statecode c.t#c.repvotes2020pct c.t#c.whiteevangelical c.t#c.catholic c.t#c.black c.t#c.poverty c.t#c.lmedincome c.t#c.lcol c.t#c.pop60to79 c.t#c.above80 c.t#c.fullcollege c.t#c.cases_per_capita c.t#i.statecode c.t2#c.repvotes2020pct c.t2#c.whiteevangelical c.t2#c.catholic c.t2#c.black c.t2#c.poverty c.t2#c.lmedincome c.t2#c.lcol c.t2#c.pop60to79 c.t2#c.above80 c.t2#c.fullcollege c.t2#c.cases_per_capita c.t2#i.statecode, vce(cluster fips)

cd "$tables_dir"
esttab using trends.tex, keep(c.t*) se replace
esttab, keep(c.t*) se
