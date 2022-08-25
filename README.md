# Cambridge Part IIA Econometrics Project

40% of Cambridge students' overall grades on the Part IIA (Second Year) Econometrics course is decided by an econometrics project for which students have 12 days to complete a selected question (not viewed beforehand). The following question was picked:

## Question

At the end of 2021 the share of the population fully vaccinated against Covid-19 differed
widely across US States (see Figure 1).
a) Identify and evaluate the main economic and social factors giving rise to this
outcome.
b) On the basis of your answer to a), suggest how high vaccination rates might be
achieved across the entire United States

----

## Solution Idea

Question was addressed using county-level data in the United States. (see `data/` and the Navigation section below for how this data was assembled from about a dozen sources; see as well as the Data and Methods section of the final manuscript). Data was generally obtained from several repositories (eg the census) and some webscraping in some cases.

We first ran simple county-level regressions (no causal interpretation; see below for more sophisticated methodology), linking the share of the adult population vaccinated (the "vaccine uptake") with several county-level covariates, with state-level fixed effects. We also attempted this regression on a panel of counties, with their vaccine uptakes recorded for each month from May 2021 to March 2022, adding interactions with the covariates and time to watch the evolution of the slope estimates over time. With this, we observed greater polarization by party ID and by religion over time.

We however, still wanted to make _causal_ claims; the above regression just gives some rough correlations. To answer part (b) of the question, we need to show some factor causes changes in vaccine uptake. We decided to study vaccine lotteries - in particular, Colorado's vaccine lottery, where getting a first jab of the vaccine entitled you to entry into a lottery to win millions of dollars.

We tested this state-level intervention by using a design inspired by Dube et al (2010)'s minimum wage study. Using NBER's county-pair adjacency dataset, we constructed a panel/cluster dataset consisting of every county-pair on the Colorado border (consisting of one Colorado county and non-Colorado county, that was untreated, that were adjacent to one another. IE, a single county would appear in multiple pairs, for each county-pair it was a member of, and hence be in multiple rows on the same day) across 10 days from before the start of their lottery program (on 25 May) to 10 days after the end. We then estimate the effect of the lottery - which only took place in one half of each pair, after 25 May, and controlled for pair-specific time fixed effects (IE all shocks that affect both members of a pair on each day) and county fixed effects (initial differences between counties in uptake); in effect we used the non-Colorado member of each adjacency pair as a "control" for the other member. We find no effect of the vaccine lottery (using standard errors clustered at the county-pair level); although its possible this result was driven by a lack of efficiency in our estimators (variances were fairly high; computational limits prevented us from considering a larger panel, across time or considering more states with lotteries).

We then also attempted a state and county-level synthetic control design; only the state level design was feasible in the end, due to computational constraints. This methodology also found no effect of the vaccine lotteries.

## Navigation

The final report as submitted is located in `manuscript/2842A.pdf` ([see here](https://github.com/SKAshwin/VaccineUptake/blob/main/manuscript/2842A%20Question%201.pdf)), compiled using LaTeX (and a Word page used for the title page, as dictated by the requirements). The report had to adhere to a 2000-word limit not including table captions and text (hence the sheer amount of text stored in tables, to evade this limit), and then a maximum of 8 tables and figures.

The README in `data/` contains information on how to obtain the raw datasets, which should be stored in `data/raw` for the files in `code` to run (note: non of the raw data was committed to the repo, you would have to fetch it manually as per the README instructions).

All code is in `code`. See `code/README` for more details, but this generally involved python files to scrape or reformat the raw data sources, then stata files to assemble the various datasets, stata files to estimate the various models, and some stata files to generate relevant tables. Not all estimated models were ultimately used.

`estimates` contain the `.ster` files from all of the estimates of the various models that are output from the files in `code`.

`graphs` contains the graphs used in the manuscript (as is referenced by the LaTeX)

`raw_tables` contains the raw LaTeX output by the stata code (usually via `esttab`). The final tables are manually edited from this base, and located in `manuscript/tables`. The LaTeX scripts do **not** reference the contents of `raw_tables`, which are regenerated every time the code is run (so do not make manual edits on them).

`synth` contains the output of the various synthetic control estimates.