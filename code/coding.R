# ============================================================
# Blog 5: The Geography of Income in Pennsylvania
# Data source: U.S. Census Bureau, ACS 5-year estimates (2022)
# ============================================================
library(tidyverse)
library(tidycensus)
library(sf)
library(ggplot2)
library(scales)
library(here)

census_api_key("11fa97dab08d2737c9cfb0b368e130d5270be4d5", install = TRUE)

# ============================================================

pa_income <- get_acs(
  geography = "tract",
  variables = "B19013_001",
  state = "PA",
  year = 2022,
  geometry = TRUE
)

nrow(pa_income)

# ============================================================
sum(is.na(pa_income$estimate))
sum(st_is_empty(pa_income$geometry))
keep <- !is.na(pa_income$estimate) & !st_is_empty(pa_income$geometry)
pa_clean <- pa_income[keep, ]
nrow(pa_clean)
dir.create(here("data", "clean"), recursive = TRUE, showWarnings = FALSE)
st_write(pa_clean, here("data", "clean", "pa_income_clean.shp"),
         delete_dsn = TRUE, quiet = TRUE)

# ============================================================

p1 <- pa_clean |>
  ggplot() +
  geom_sf(aes(fill = estimate), color = NA) +
  scale_fill_stepsn(
    colors = c("#2c7bb6", "#abd9e9", "#ffffbf", "#fdae61", "#d7191c"),
    breaks = quantile(pa_clean$estimate, probs = seq(0, 1, 0.2), na.rm = TRUE),
    name = "Median household\nincome (USD)",
    labels = dollar_format()
  ) +
  labs(
    title = "The Geography of Income in Pennsylvania",
    subtitle = "Median household income by census tract, 2022 ACS",
    caption = "Data source: U.S. Census Bureau, ACS 5-year estimates (2022)."
  ) +
  theme_void(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12),
    legend.position = "right"
  )

p1

# ============================================================

pa_clean <- pa_clean |>
  mutate(
    income_quintile = ntile(estimate, 5),
    quintile_label = factor(
      income_quintile,
      levels = 1:5,
      labels = c("Lowest 20%", "2nd", "Middle", "4th", "Highest 20%")
    )
  )

p2 <- pa_clean |>
  ggplot() +
  geom_sf(aes(fill = quintile_label), color = NA) +
  scale_fill_manual(
    values = c(
      "Lowest 20%" = "#2c7bb6",
      "2nd" = "#abd9e9",
      "Middle" = "#ffffbf",
      "4th" = "#fdae61",
      "Highest 20%" = "#d7191c"
    ),
    name = "Income quintile"
  ) +
  labs(
    title = "Income Quintiles Cluster Spatially in Pennsylvania",
    subtitle = "Each quintile contains 20% of census tracts",
    caption = "Data source: U.S. Census Bureau, ACS 5-year estimates (2022)."
  ) +
  theme_void(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12),
    legend.position = "right"
  )

p2

# ============================================================

philly <- pa_clean |>
  filter(grepl("Philadelphia County", NAME))

p3 <- philly |>
  ggplot() +
  geom_sf(aes(fill = estimate), color = "white", linewidth = 0.1) +
  scale_fill_stepsn(
    colors = c("#2c7bb6", "#abd9e9", "#ffffbf", "#fdae61", "#d7191c"),
    breaks = quantile(pa_clean$estimate, probs = seq(0, 1, 0.2), na.rm = TRUE),
    name = "Median household\nincome (USD)",
    labels = dollar_format()
  ) +
  labs(
    title = "Income Segregation Within Philadelphia",
    subtitle = "Median household income by census tract, 2022 ACS",
    caption = "Data source: U.S. Census Bureau, ACS 5-year estimates (2022)."
  ) +
  theme_void(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12),
    legend.position = "right"
  )

p3

# ============================================================

dir.create(here("output"), recursive = TRUE, showWarnings = FALSE)

ggsave(here("output", "pa_income_map.png"), plot = p1,
       width = 10, height = 7, dpi = 300)
ggsave(here("output", "pa_quintile_map.png"), plot = p2,
       width = 10, height = 7, dpi = 300)
ggsave(here("output", "philly_income_map.png"), plot = p3,
       width = 9, height = 8, dpi = 300)
