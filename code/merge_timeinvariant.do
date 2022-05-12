frame reset
global raw_dir "/home/elven/Documents/College/metrics_project/data/raw"
global temp_dir "/home/elven/Documents/College/metrics_project/data/temp"
global cleaned_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global elections_cleaned "elections_clean"
global col_cleaned "epi_col"
global education_raw "Education.xls"
global religion_race_raw "prri_religion_subset_race.csv"
global religion_raw "prri_religion.csv"
global race_raw "DECENNIALPL2020.P1_data_with_overlays_2022-04-22T121216.csv"

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

drop col

capture frame drop religionrace
frame create religionrace
frame change religionrace
	cd "$temp_dir"
	import delim "$religion_race_raw", varn(1)
	rename fipscode fips
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
frame change default

frlink 1:1 fips, frame(religion)
frget catholic, from(religion)
frget prri_diversity_index=standardized, from(religion)
drop religion
/*
capture frame drop race
frame create race
frame change race
	cd "$raw_dir"
	import delim "$race_raw",varn(1) clear
	* first row has some description
	drop if _n==1
	gen fips = real(substr(geo_id, 10, 14))
	order fips
*/
