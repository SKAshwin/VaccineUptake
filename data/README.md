## Loading Raw Data (Quick Start)

The quickest way to obtain the raw data to replicate the paper is, on a unix system, to simply run (from this directory):

```bash
bash download_data.sh
```

Otherwise, visit [this site](https://downloads.skashwin.com/projects/VaccineUptake/VaccUptake_raw_data.zip) to download the zip file containing all the raw datasets. Then unzip the contents into a folder `/raw` in this directory. Then create empty folders `/cleaned`, `/regression_ready` and `/temp` in this directory (used by the code files).

## Data and Sources

If you want to manually compile the data from its original sources, refer to this section. Store all raw files in a folder `/raw` within this folder, with the same names. All links below (except for the BLS link, which could not easily be archived) are webarchive links and so should be permanently accessible.

* Unemployment rates by county. `raw/laucmtycur14.xlsx` contains unemployment rates by county, fetched from https://www.bls.gov/lau/#tables

* Cost of living by county. `raw/webscrape/epi_col.json` contains data on the cost of a "modest" living in each county for a family of 2 adults and 2 children. See [here](https://web.archive.org/web/20220918043822/https://www.epi.org/publication/family-budget-calculator-documentation/) for documentation on how it is compiled. It was scraped from [here](https://web.archive.org/web/20220918043518/https://www.epi.org/resources/budget/budget-map/).

* Above also includes median/mean income by county.

* Religious breakdowns by county. `raw/webscrape/prri_religion.html` and `raw/webscrape/prri_religion_subset_race.html` have data on religious affiliations in each US county, broken down into different subsets (the latter is more fine-grained). Also has populations by county. This was scraped from [here](https://web.archive.org/web/20220918043904/https://www.prri.org/research/2020-census-of-american-religion/), and that page has details on how it was compiled.

* Vaccination rates by county by day. Taken for 31 December 2021, 30 September 2021, and then a 1 May - 30 June period in 2021. Taken from [here](https://web.archive.org/web/20220918044034/https://data.cdc.gov/Vaccinations/COVID-19-Vaccinations-in-the-United-States-County/8xkx-amqh/data).

* 2020 and 2016 Election results by county. `raw/countypres_2000-2020.csv` contains information on all Presidential elections since 2000, and even breaks down the ballots cost into in-person and mail-in ballots. Obtained from [here](https://web.archive.org/web/20220918044232/https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/VOQCHQ).

* Racial breakdown by county. `raw/DECENNIALPL2020.P1_data_with_overlays_2022-04-22T121216.csv` contains data from 2020 on total population, and what specific race people belonged to (including all varieties of mixed race people). Obtained from the 2020 Decennial Redestricting Data: [here](https://web.archive.org/web/20220918045132/https://data.census.gov/cedsci/table?q=P1%3A%20RACE%20county&tid=DECENNIALPL2020.P1). 

* Educational attainment by county. `raw/Education.xls` contains data from the Census' from the 1970s on, and education attainment for every decade since and 2015-2019 (we're only really interested in the last one). Also has data on rural status and urban influence that is duplicated in the poverty file (see below). Gives information on the % (and raw numbers) of people with less than a high school diploma, a diploma, some college, and 4 years of college or more. Obtained from [here](https://web.archive.org/web/20220918045401/https://www.ers.usda.gov/data-products/county-level-data-sets/download-data/).

* Poverty by county. `raw/PovertyEstimates.xls` contain the Census' Small Area Income and Poverty Estimates, which contains data on the number of people (and % of people) in poverty, child poverty specifically, as well as median income. It also classifies each county's rural or uban influence using the Rural-urban continuum code and the urban influence code (2013). Data as of 2019. Also obtained from [here](https://web.archive.org/web/20220918045401/https://www.ers.usda.gov/data-products/county-level-data-sets/download-data/).

* Age by county. `raw/cc-est2019-alldata.csv` contains data from the Census on each county's age breakdown into various categories (see [website](https://web.archive.org/web/20220918045958/https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/2010-2019/cc-est2019-alldata.pdf) for what each number means) as well as racial data by age. Obtained for 2019 from [here](https://web.archive.org/web/20220918045845/https://www.census.gov/data/tables/time-series/demo/popest/2010s-counties-detail.html). 

* COVID-19 Deaths and Cases in 2020, by county. `raw/cases01dec20.csv` contains information on cases and deaths in every region of every country of the world, taken from the CSSE COVID-19 Data Repository maintained by John Hopkins, [here](https://web.archive.org/web/20220918050153/https://github.com/CSSEGISandData/COVID-19).

* A county adjacency map, for the matched pair design, taken from [here](https://web.archive.org/web/20220918050047/https://www.nber.org/research/data/county-adjacency). 

## Webscraping

The contents of `raw/webscrape` were scraped from some websites. The collection of 3 Postman requests needed to replicate this (as of the time of writing this) is stored in `metrics project webscrape.postman_collection.json`. Full documentation on the exact http requests made is available [here](https://web.archive.org/web/20220918050406/https://documenter.getpostman.com/view/6196102/UyxdKp8F).

