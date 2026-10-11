# The Geography of Income in Pennsylvania

A spatial analysis of median household income across all
census tracts in Pennsylvania, using 2022 ACS data.

## Research Question

**Where are high- and low-income areas concentrated in
Pennsylvania, and what does that spatial pattern reveal about
economic geography?**

The analysis examines income segregation at three scales: the
state, the metropolitan area, and the neighborhood.

## Data Source

| Item | Description |
|------|-------------|
| Source | U.S. Census Bureau, American Community Survey (ACS) |
| Table | B19013 (Median household income) |
| Vintage | 2022 ACS 5-year estimates |
| Geography | Census tract |
| Coverage | All 67 counties in Pennsylvania |
| Tracts | 3,382 (after removing missing/empty) |
| Access | Programmatic via the `tidycensus` R package |

Census tract data is used rather than county or city data
because tracts are small enough to reveal neighborhood-level
patterns that larger geographies would hide.

## Repository Structure

```
blog5/
├── data/
│   └── clean/
│       └── pa_income_clean.csv           # Cleaned tract-level data
├── code/
│   └── pa_income_maps.R                  # Full analysis script
├── output/
│   ├── pa_income_map.png                 # Figure 1
│   ├── pa_quintile_map.png               # Figure 2
│   └── philly_income_map.png             # Figure 3
├── posts/
│   └── index.qmd                         # Blog post
└── README.md
```

## How to Reproduce

1. Clone this repository
2. Set up your Census API key:
   ```r
   tidycensus::census_api_key("your_key", install = TRUE)
   ```
   Get a free key at https://api.census.gov/data/key_signup.html
3. Install required packages:
   ```r
   install.packages(c("tidycensus", "sf", "tidyverse", "here", "scales"))
   ```
4. Run:
   ```r
   source("code/pa_income_maps.R")
   ```

## Key Findings

**1. Income is concentrated at the state level.**
High-income tracts cluster in the Philadelphia and Pittsburgh
metropolitan areas. Low-income tracts cluster in inner cities
and older industrial towns. The rural middle of the state is
almost entirely middle-income.

**2. High-income tracts form contiguous regions, not scattered
neighborhoods.** In southeastern Pennsylvania, top-quintile
tracts form a large, connected block stretching from
Philadelphia into Chester and Montgomery counties.

**3. Philadelphia shows sharp neighborhood-level segregation.**
North Philadelphia and Kensington are almost entirely
bottom-quintile. Center City is only middle-quintile (not top).
The wealthiest tracts are in the northwest and along the
southern edge.

## Methodology Notes

- **Median, not mean.** Household income is right-skewed.
  The median is less affected by extreme values.
- **Quintile classification.** Tracts are divided into five
  equal groups (each containing 20% of tracts) to make the
  spatial pattern visible without the top-code distortion.
- **No cost-of-living adjustment.** A dollar in rural
  Pennsylvania buys more than a dollar in Philadelphia, but
  this analysis treats them as equal.

## Limitations

- **ACS estimates are uncertain.** Small differences between
  adjacent tracts may not be statistically significant.
- **Median income is a crude measure.** It ignores wealth,
  cost of living, and household size.
- **2022 snapshot.** Income geography changes slowly, but the
  picture would differ in other years.
- **Descriptive, not causal.** The maps show where income is
  concentrated, not why.

## Data Attribution

All data comes from the U.S. Census Bureau:

> U.S. Census Bureau, American Community Survey 5-year
> estimates (2022), table B19013. Retrieved via the
> `tidycensus` R package.

## License

This project is for educational purposes.