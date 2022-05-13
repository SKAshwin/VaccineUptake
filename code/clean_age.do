macro drop _all
frames reset
global raw_dir "/home/elven/Documents/College/metrics_project/data/raw"
global cleaned_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global age_raw "cc-est2019-alldata.csv"

cd "$raw_dir"
import delim "$age_raw", varn(1)

* drop everything but total population
keep state county stname ctyname year agegrp tot_pop
* keep only 1 July 2019 estimates (YEAR=12)
keep if year==12
drop year

* rename age groups to good name
gen age_grp = "TOTAL" if agegrp == 0
replace age_grp = "0to4" if agegrp == 1
replace age_grp = "5to9" if agegrp == 2
replace age_grp = "10to14" if agegrp == 3
replace age_grp = "15to19" if agegrp == 4
replace age_grp = "20to24" if agegrp == 5
replace age_grp = "25to29" if agegrp == 6
replace age_grp = "30to34" if agegrp == 7
replace age_grp = "35to39" if agegrp == 8
replace age_grp = "40to44" if agegrp == 9
replace age_grp = "45to49" if agegrp == 10
replace age_grp = "50to54" if agegrp == 11
replace age_grp = "55to59" if agegrp == 12
replace age_grp = "60to64" if agegrp == 13
replace age_grp = "65to69" if agegrp == 14
replace age_grp = "70to74" if agegrp == 15
replace age_grp = "75to79" if agegrp == 16
replace age_grp = "80to84" if agegrp == 17
replace age_grp = "85above" if agegrp == 18
drop agegrp

* reshape to have total population by each age group
rename tot_pop pop
reshape wide pop, i(state county) j(age_grp) string

* rename, clean, label
forval i = 1/17{
	local start = (`i'-1)*5
	local end =  `start'+4
	di "`start'to`end'"
	
	gen pop`start'to`end'pct = pop`start'to`end'/popTOTAL*100
	label var pop`start'to`end'pct "Est. Proportion of county aged `start' to `end' on 1 July 2019, Census Bureau"
}

gen pop85abovepct = pop85above/popTOTAL *100
label var pop85abovepct "Est. Proportion of county aged 85 and above on 1 July 2019, Census Bureau"
order state county stname ctyname popTOTAL

* reconstruct FIPS code of county
gen fipsstring = string(state, "%02.0f") + string(county, "%03.0f")
gen fips = real(fipsstring)

order fips fipsstring

cd "$cleaned_dir"
save "age_cleaned", replace
