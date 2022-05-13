frame reset
macro drop _all
global raw_dir "/home/elven/Documents/College/metrics_project/data/raw"
global temp_dir "/home/elven/Documents/College/metrics_project/data/temp"
global cleaned_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global unemployment_raw "laucntycur14.xlsx"

cd "$raw_dir"
import excel "$unemployment_raw", cellrange(A5:I45086) firstrow

* First Row is empty
drop if _n == 1

* Some variable name fixing
rename Code statefips
rename C countyfips
gen fips = real(statefips+countyfips)

rename I unrate 

* Remove irrelevant variables
drop Employed Unemployed Force LAUSCode

* Clean Period
replace Period = subinstr(Period, "-", "", .)
replace Period = "Mar22" if Period == "Mar22 p"

* One row per county
reshape wide unrate, i(fips) j(Period) string

* order it logically
order fips statefips countyfips CountyName unrateFeb21 unrateMar21 unrateApr21 ///
	unrateMay21 unrateJun21 unrateJul21 unrateAug21 unrateSep21 unrateOct21 ///
	unrateNov21 unrateDec21 unrateJan22 unrateFeb22 unrateMar22  
	
cd "$cleaned_dir"
save "unemployment_cleaned"
