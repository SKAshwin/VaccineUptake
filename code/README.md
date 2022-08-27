The various code files can be broken down into the following tasks. Some never had their output used in the final product in the end. Make sure to only run code here after setting up the `/data/raw` folder (see `data/README.md`).

All files will have the directories they reference (e.g. the path to the cleaned data directory and the path to the cleaned)

## Parsing raw files into CSVs

The files under this section have to be executed before anything else. See `data/README.md` on how to acquire the raw data files for these programs to execute on. All the files here are in python.

* `county_adjacency.py` parses `data/raw/countyadjacency.txt` into a CSV file (dumped into `data/temp`), which lists every county in alphabetic order (the first entry of each row), and the rest of the entries in its rows are all the counties that the first column's county borders.

* `read_scraped_diversity_index.py` reads the output scraped from the PRRI website, which is stored in `data/raw/webscrape/prri_religion.html` and `data/raw/webscrape/prri_religion_subset_race.html`. Run the file with both options for `SOURCE` to parse both the religionxrace and the religion datasets. The parsed data is put in a CSV file in `data/temp`. Each row has each county and their population, and the share of various religious and racial groups (and intersections, for the religion_subset_race parsing).

* `read_scraped_col.py` reads the output scraped from the EPI cost-of-living website, which is stored in `data/raw/webscrape/epi_col.json`. The parsed data is put in a CSV file in `data/temp`. It contains information on the average price of a basket of goods, subdivided into smaller baskets (rent, healthcare etc); this is parsed into a CSV, with each row corresponding to a county.


## Cleaning data into dta files

Some further data-cleaning, for the data already in tabular form in a CSV, converting all the CSVs into dta files. All these files are stata do files.

* `epi_col.do` converts the EPI cost-of-living data from the temporary CSV file (see above) into a stata dta file.

* `clean_age.do` cleanes the age breakdown by county data in `data/raw/cc-est2019-alldata.csv` and converts it to a stata dta file.

* `clean_elections.do` cleans the election data in `data/raw/countypres_2000-2020.csv` and restructures it to have each row correspond to a county, and records several election results per county, and stores the results in a stata dta file.

* `clean_unemployment.do` cleans and restructures the unemployment data in `data/raw/laucntycur14.xlsx` and stores the results in a stata dta file.

## Merging data into master datasets

The various datasets are merged into larger datasets for models to be estimated on.

* `merge_timeinvariant.do` merges all the county characteristics stored in all the cleaned datasets above (and a few raw datasets) into a giant cross-section of time-invariant characteristics of all of the counties.

* `standardize_time_invariant.do` keeps only counties for which we have *all* the time invariant characteristics - IE prunes every county for which we have missing data. This is to ensure that every regression runs on the same set of counties, instead of it changing based on the exact covariates used, affecting which counties can be included in each regression. The resulting `time_invariant_standardized` is the basic dataset used by the estimation code.

## Estimating models

Several models are estimated: a set of simple cross-sections, a panel to see the change in the _coefficients_ on the time-invariant regressors over time, several difference-in-difference based specifications (including the Dube 2010 inspired methodology that forms the best founded part of the work) and then the synthetic controls. Not all of the results were used.

* `cross_section.do` estimates several cross-sectional models of vaccine uptake by county (with different measures of uptake and different model specifications) and tests each of these models for heteroskedasticity.

* `did_neighborcounty_naive.do` implements a difference-in-differences to measure the effects of the Colorado and Kentucky vaccine lottery, using their neighboring states' counties as untreatred units. The treated units are the counties of Colorado/Kentucky (done separately) that border the neighboring states, and similarly the untreated units are the neighbors' border counties. This is a fairly weak methodology (its unclear that the bordered counties are such good controls and nothing else happened to them as a whole in the treatment period). Results unused in the end.

* `did_neighborcounty.do` implements Dube (2010)'s method to control for border county pair-time fixed effects (see the manuscript or the main README), on Kentucky to measure the effect of its vaccine lottery. Several errors are made in this do-file, which was a first attempt; for example, clustered standard errors are not used. Results unused in the end.

* `did_neighborcounty_colorado.do` implements Dube (2010)'s method to control for border county pair-time fixed effects on Colorado to measure the effect of its vaccine lottery. This is the correct implementation, using robust standard errors and also checking if the effects of the policy changed over time.

* `catholicdid.do` is a silly attempt to use a papal announcement on 18 August 2021 as an exogenous shock which may have caused greater vaccine uptake in counties with more Catholics. Results unused in the end.

* `coloradosynthcontrol.do` uses a synthetic control method to estimate the effect of the vaccine lottery in Colorado, using the other states that did not have a vaccine lottery over the period as components of a synthetic Colorado.

* `coloradosynthcontrol_bycounty.do` attempts the same as the above,but with the synthetic Colorado constructed at the county-level, with each Colorado county having a synthetic control counterpart created using all untreated counties in similar states. Due to computational contraints, not feasible.

## Generating tables/figures