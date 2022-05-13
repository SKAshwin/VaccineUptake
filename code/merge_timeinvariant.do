frame reset
macro drop _all
global raw_dir "/home/elven/Documents/College/metrics_project/data/raw"
global temp_dir "/home/elven/Documents/College/metrics_project/data/temp"
global cleaned_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global elections_cleaned "elections_clean"
global col_cleaned "epi_col"
global education_raw "Education.xls"
global religion_race_raw "prri_religion_subset_race.csv"
global religion_raw "prri_religion.csv"
global race_raw "DECENNIALPL2020.P1_data_with_overlays_2022-04-22T121216.csv"
global poverty_raw "PovertyEstimates.xls"
global age_cleaned "age_cleaned"
global cases_raw "cases01dec20.csv"

cd "$raw_dir"
import excel "$education_raw", cellrange(A5:AU3288) firstrow clear
drop if State=="US"
* Remove the states
drop if substr(FIPSCode, 3,5)=="000"

gen fips = real(FIPSCode)
order FIPSCode fips

rename AU fullcollege
rename AT somecollege
rename AS diploma
rename AR nodiploma

rename Areaname county_name
rename F rural_rating
rename G urbinfluence
rename State state

keep fips state county_name rural_rating urbinfluence fullcollege somecollege diploma nodiploma

cd "$cleaned_dir"
save education_cleaned, replace

capture frame drop col
frame create col
frame change col
	cd "$cleaned_dir"
	use "$col_cleaned", clear
	* drop metro areas
	drop if fips == .
frame change default

frlink 1:1 fips, frame(col)
frget rent taxes hcare monthly_col annual_col median_family_income mean_family_income, from(col)

label var rent "EPI 2020 Cost of living for 2 parents 2 children household: rent"
label var taxes "EPI 2020 Cost of living for 2 parents 2 children household: taxes"
label var hcare "EPI 2020 Cost of living for 2 parents 2 children household: healthcare"
label var monthly_col "EPI 2020 Cost of living for 2 parents 2 children household per month"
label var annual_col "EPI 2020 Cost of living for 2 parents 2 children household per annum"
label var median_family_income "EPI 2020 Median Income 2 parents 2 children household"
label var mean_family_income "EPI 2020 Mean Income 2 parents 2 children household"

rename median_family_income median_family_income_2020
rename mean_family_income mean_family_income_2020

drop col

capture frame drop religionrace
frame create religionrace
frame change religionrace
	cd "$temp_dir"
	import delim "$religion_race_raw", varn(1)
	rename fipscode fips
	
	label var allwhitechristians "All white Christians, PRRI 2020 Religion Census"
	label var whiteevangelicalprotestant "White Evangelical Protestants, PRRI 2020 Religion Census"
	label var whitemainlineprotestant "White Mainline Protestants, PRRI 2020 Religion Census"
	label var blackprotestant "Black Protestants, PRRI 2020 Religion Census"
	label var whitecatholic "White Catholics, PRRI 2020 Religion Census"
	label var hispaniccatholic "Hispanic Catholics, PRRI 2020 Religion Census"
	label var hispanicprotestant "Hispanic Protestants, PRRI 2020 Religion Census"
	label var mormon "Mormons, PRRI 2020 Religion Census"
frame change default

frlink 1:1 fips, frame(religionrace)
frget whitechristians=allwhitechristians whiteevangelical=whiteevangelicalprotestant /// 
        whiteprotestant=whitemainlineprotestant, from(religionrace)
frget blackprotestant whitecatholic hispaniccatholic hispanicprotestant mormon, from(religionrace)
drop religionrace

capture frame drop religion
frame create religion
frame change religion
	cd "$temp_dir"
	import delim "$religion_raw", varn(1) clear
	rename fipscode fips
	
	label var catholic "All Catholics, PRRI 2020 Religion Census"
	label var standardized "PRRI Religious Diversity Index, PRRI 2020 Religion Census"
frame change default

frlink 1:1 fips, frame(religion)
frget catholic, from(religion)
frget prri_diversity_index=standardized, from(religion)
drop religion

capture frame drop race
frame create race
frame change race
	cd "$raw_dir"
	import delim "$race_raw",varn(1) numericcols(3/9) clear
	* first row has some description
	drop if _n==1
	gen fips = real(substr(geo_id, 10, 14))
	order fips
	rename p1_002n totalpop
	rename p1_003n white
	rename p1_004n black
	rename p1_005n native
	rename p1_006n asian
	rename p1_007n pacific
	gen nonwhite = totalpop-white
	
	gen whitepct = white/totalpop * 100
	gen nonwhitepct = nonwhite/totalpop * 100
	gen blackpct = black/totalpop * 100
	gen nativepct = native/totalpop * 100
	gen asianpct = asian/totalpop * 100
	gen pacificpct = pacific/totalpop * 100
	
	label var totalpop "Total Population, 2020 census"
	label var white "Total White Population, 2020 census"
	label var nonwhite "Total Non-White Population, 2020 census"
	label var black "Total Black Population, 2020 census"
	label var native "Total American Indian/Alaskan Native Population, 2020 census"
	label var asian "Total Asian Population, 2020 census"
	label var pacific "Total Pacific Islander/Native Hawaiian Population, 2020 census"
	
	label var whitepct "White Proportion of Population, 2020 census"
	label var nonwhitepct "Nonwhite Proportion of Population, 2020 census"
	label var blackpct "Black Proportion of Population, 2020 census"
	label var nativepct "American Indian/Alaskan Native Proportion of Population, 2020 census"
	label var asianpct "Asian Proportion of Population, 2020 census"
	label var pacificpct "Pacific Islander/Native Hawaiian Proportion of Population, 2020 census"
frame change default

frlink 1:1 fips, frame(race)
frget totalpop=totalpop white=whitepct nonwhite=nonwhitepct black=blackpct native=nativepct asian=asianpct pacific=pacificpct, from(race)
drop race

capture frame drop povertyframe
frame create povertyframe
frame change povertyframe
	cd "$raw_dir"
	import excel "$poverty_raw", sheet("Poverty Data 2019") cellrange(A5:AH3198) firstrow clear
	drop if Stabr=="US"
	* Remove the states
	drop if substr(FIPStxt, 3,5)=="000"
	
	rename PCTPOVALL_2019 poverty
	rename MEDHHINC_2019 median_household_income_2019
	gen fips = real(FIPStxt)
	order fips
	
	label var poverty "Estimated percent of people of all ages in poverty 2019, SAIPE Estimates"
	label var median_household_income_2019 "Estimate of median household income 2019, SAIPE Estimates"
frame change default

frlink 1:1 fips, frame(povertyframe)
frget poverty median_household_income_2019, from(povertyframe)
drop povertyframe

capture frame drop age
frame create age
frame change age
	cd "$cleaned_dir"
	use "$age_cleaned", replace
frame change default

frlink 1:1 fips, frame(age)
frget *pct, from(age)
drop age

capture frame drop cases
frame create cases
frame change cases
	cd "$raw_dir"
	import delim "$cases_raw", varn(1)
	
	* filter down to just the U
	keep if country_region == "US"
	* Random garbage nonexistent counties
	drop if admin2 == "Unassigned"
	drop if fips >= 80000
	
	gen imputed_pop =  confirmed/(incident_rate/100000)
	gen deaths_per_capita = deaths/imputed_pop
	gen cases_per_capita = incident_rate/100000
	
	label var cases_per_capita "Per person COVID-19 cases 1 December 2020"
	label var deaths_per_capita "Per person COVID-19 deaths 1 December 2020"
frame change default

frlink 1:1 fips, frame(cases)
frget cases_per_capita deaths_per_capita, from(cases)
drop cases

capture frame drop votes
frame create votes
frame change votes
	cd "$cleaned_dir"
	use "$elections_cleaned"
	
	label var demvotes2020pct "Percentage of ballots cast for Democrat, 2020"
	label var repvotes2020pct "Percentage of ballots cast for Republican, 2020"
	label var othvotes2020pct "Percentage of ballots cast for Others, 2020"
	
	label var demvotes2016pct "Percentage of ballots cast for Democrat, 2016"
	label var repvotes2016pct "Percentage of ballots cast for Republican, 2016"
	label var othvotes2016pct "Percentage of ballots cast for Others, 2016"
frame change default

frlink 1:1 fips, frame(votes)
frget *pct, from(votes)
drop votes

cd "$cleaned_dir"
save "time_invariant", replace
