## Question

At the end of 2021 the share of the population fully vaccinated against Covid-19 differed
widely across US States (see Figure 1).
a) Identify and evaluate the main economic and social factors giving rise to this
outcome.
b) On the basis of your answer to a), suggest how high vaccination rates might be
achieved across the entire United States

----

## Ideas

Planned focus: Media coverage on the vaccine, and FOX news
Solution: more attempt to engage in advocacy for the vaccine on these right-wing networks

Instrument for media coverage/Republican membership: FOX news channel position
Idea: more FOX news viewership → lower vaccination rates

Synthetic control for vaccine incentive programs: see https://jamanetwork.com/journals/jama/fullarticle/2781792 but maybe pick another state.

Use Vatican's statements to try and see how it influences Catholics: https://pubmed.ncbi.nlm.nih.gov/34960233/. This would work via a DiD type set up - counties with more Catholics should have their new vaccination gap emerge with other counties. Can use the statement by the Pope and North/South American bishops on 18 August 2021 to see if gap opened up between Catholics and other religious groups.

Use the proportion of votes in 2020 that were in person, after controlling for donald trump vote %, as a measure for how seriously COVID-19 is taken on average in that county (how much risk do people assess to themselves).

Reduced form regression: rural status, Republican membership, total cumulative covid cases/deaths in that county, demographic factors, educational attainment

throw some of these into a panel but exogeneity is questionable there?

Can also check for effect of income grants on vaccination rates. Can use the Biden stimulus checks: these were sent out over March 2021 (see https://www.aarp.org/money/taxes/info-2020/irs-timeline-to-send-stimulus-funds.html), and had equal nominal value, so vastly differing real values by county. Note the timing of these checks was staggered non-randomly’ based on whether previous income tax info was available. The vast majority of checks were on March 12/19 and April 2. The April 2 payment was for those with no previous tax return, and so likely the poorest, worth noting.

Bill was signed around March 11, though widely expected.

Can also use the expiry of the unemployment insurance top-up, but this was known in advance.

Can use Afghan invasion as instrument for local Biden approval. Note that only state level data will be available for approval rating, however.


https://www.census.gov/library/stories/2021/12/who-are-the-adults-not-vaccinated-against-covid.html

This tells us that why Adults arent vaccinated, as of end 2021. Almost no one (2%) is due to inability to access the vaccine.

https://www.census.gov/programs-surveys/household-pulse-survey/data.html

The household pulse survey has a tonne of state level information.

GENERAL NOTES ON FINDINGS:
* Deaths per capita is actually not predictive of future vaccination
* Cases per capita is; and positively so, but maybe this is a matter of reflecting more testing and so stronger attitudes towards covid
* In 30 September, Republican effect weaker, and interestingly Catholic premium also disappears

## Graphs

1. County level cross-section, showing beta coefficients, in two different periods, with state fixed effects. Generated already, but need to add a row for the White Test results. Comment on the beta coefficient sizes etc.

2. Trend graph, showing the change of the partial effects (linear and quadratic). Commentary on the groups entrenching.

3. Pair design summary statistics, showing similarities.

4. Pair design shaded counties

5. Pair design results + Synthetic control results

6. Synthetic control weights

7. Synthetic control graphs (depending on if they count for multiple)