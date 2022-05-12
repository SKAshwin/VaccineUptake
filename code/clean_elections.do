global raw_dir "/home/elven/Documents/College/metrics_project/data/raw"
global cleaned_dir "/home/elven/Documents/College/metrics_project/data/cleaned"
global elections_raw "countypres_2000-2020.csv"

*Uncomment on first run
*ssc inst unique

cd "$raw_dir"
import delim "$elections_raw", varn(1) clear
drop if year < 2016
* DC in 2020 wasn't given a fips code, for some reason
replace county_fips = 11001 if county_name == "DISTRICT OF COLUMBIA"
* There's a county called bedford virginia with... no votes and fips 51515 in 2016 only, for some reason
drop if county_fips == 51515
* Maine has overseas voters registered to a county
* And Rhode Island has some Federal Precinct that seems to have no associated county
* Both of these no fips code, drop
drop if county_fips == .
* Now, for some counties, a "TOTAL" row exists, and we can use that
* For other counties, the votes for a particular candidate in a particular year is split
* into its constituent parts (election day, vote by mail, etc)
* So you want to keep only the TOTAL row for county/candidate/year combos that have TOTAL rows
* You want to sum up everything else
egen hastotal = max(mode=="TOTAL"), by(county_fips state state_po  county_name year candidate party)
drop if mode != "TOTAL" & hastotal == 1
collapse (sum) candidatevotes (first) totalvotes, by(county_fips state state_po  county_name year candidate party)

* Have one row per county year, instead of one row per county-year-candidate
reshape wide candidate candidatevotes, i(county_fips year) j(party) string
order year state state_po county_fips county_name totalvotes candidateDEMOCRAT candidateREPUBLICAN ///
 candidatevotesDEMOCRAT candidatevotesREPUBLICAN candidateOTHER candidateLIBERTARIAN candidateGREEN candidatevotesDEMOCRAT

keep year state state_po county_fips county_name totalvotes candidatevotes*
rename (candidatevotesDEMOCRAT candidatevotesREPUBLICAN candidatevotesGREEN candidatevotesLIBERTARIAN candidatevotesOTHER) (demvotes repvotes grnvotes libvotes othvotes)

* Handle third parties, merge them together, as different counties treat
* green/lib as others, etc
replace grnvotes = 0 if grnvotes == . & year == 2020
replace libvotes = 0 if libvotes == . & year == 2020
replace othvotes = 0 if othvotes == . 
replace othvotes = othvotes + grnvotes + libvotes if year == 2020
drop grnvotes libvotes

* Have one row per county, different columns for different years
reshape wide totalvotes demvotes repvotes othvotes county_name, i(county_fips) j(year)

* Handle county name changes
drop county_name2016
rename county_name2020 county_name

order state state_po county_fips county_name totalvotes2020 demvotes2020 repvotes2020 othvotes2020 totalvotes2016 demvotes2016 repvotes2016 othvotes2016

local votegroups demvotes repvotes othvotes
local years 2020 2016
foreach year of local years {
	foreach votegroup of local votegroups  {
		gen `votegroup'`year'pct = `votegroup'`year'/totalvotes`year'*100
	}
}

cd "$cleaned_dir"

rename county_fips fips
save elections_clean, replace
