The various code files can be broken down into the following tasks. Some never had their output used in the final product in the end. Make sure to only run code here after setting up the `/data/raw` folder (see `data/README.md`).

## Raw Data Acquisition and Cleaning

The files under this section have to be executed before anything else. See `data/README.md` on how to acquire the raw data files for these programs to execute on.

* `county_adjacency.py` parses `data/raw/countyadjacency.txt` into a CSV file (dumped into `data/temp`), which lists every county in alphabetic order (the first entry of each row), and the rest of the entries in its rows are all the counties that the first column's county borders.

* `read_scraped_diversity_index.py` reads the output scraped from the PRRI website, which is stored in `data/raw/webscrape/prri_religion.html` and `data/raw/webscrape/prri_religion_subset_race.html`. Run the file with both options for `SOURCE` to parse both the religionxrace and the religion datasets. The parsed data is put in a CSV file in `data/temp`. Each row has each county and their population, and the share of various religious and racial groups (and intersections, for the religion_subset_race parsing).

* `read_scraped_col.py` reads the output scraped from the EPI cost-of-living website, which is stored in `data/raw/webscrape/epi_col.json`. It contains information on the average price of a basket of goods, subdivided into smaller baskets (rent, healthcare etc); this is parsed into a CSV, with each row corresponding to a county.


## Assembling data into dta files

## Estimating models

## Generating tables/figures