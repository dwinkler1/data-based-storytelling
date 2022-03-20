## Before: mutate => returns same number of rows
## Now: summarize => reduce rows by function
library(tidyverse)
library(skimr)
penguins <- read_csv("data/penguins.csv", col_select = species:year)
skim(penguins)
## Summary statistics like skimr
p_summary <- penguins %>% 
  summarize(n_missing_sex = n_missing(sex), 
            complete_rate_sex = 1-(n_missing_sex/n()),
            n_unique_sex = n_unique(sex),
            mean_weight = mean(body_mass_g, na.rm = TRUE),
            sd_weight = sd(body_mass_g, na.rm = TRUE),
            percentiles_weight = list(quantile(body_mass_g, c(0, 0.25, 0.50, 0.75, 1), na.rm = TRUE)),
            first_quartile_weight = quantile(body_mass_g, 0.25, na.rm = TRUE),
            median_weight = median(body_mass_g, na.rm = TRUE),
            third_quartile_weight = quantile(body_mass_g, 0.75, na.rm = TRUE)
  )
p_summary
p_summary$percentiles_weight
unnest_wider(p_summary, col = percentiles_weight)

## Automatic summary across multiple variables
a_summary <- penguins %>% 
  summarize_if(is.numeric, 
               list(mean = \(x) mean(x, na.rm = TRUE), 
                    median = \(x) median(x, na.rm = TRUE))) 
a_summary
### Convert to long format
a_summary %>%
  pivot_longer(cols = 1:ncol(a_summary))
### Shorthand
a_summary %>%
  pivot_longer(cols = everything())

## Select variables like mutate_at
penguins %>%
  summarize_at(vars(bill_length_mm:body_mass_g), 
               list(mean = \(x) mean(x, na.rm=TRUE)))

penguins %>%
  summarize_at(c("body_mass_g", "bill_length_mm"), 
               list(mean = \(x) mean(x, na.rm=TRUE)))


## Group-wise statistics
penguins %>% 
  group_by(species) %>% 
  summarize(n_missing_sex = n_missing(sex), 
            complete_rate_sex = 1-(n_missing_sex/n()),
            n_unique_sex = n_unique(sex),
            mean_weight = mean(body_mass_g, na.rm = TRUE),
            sd_weight = sd(body_mass_g, na.rm = TRUE),
            percentiles_weight = list(quantile(body_mass_g, c(0, 0.25, 0.50, 0.75, 1), na.rm = TRUE)),
            first_quartile_weight = quantile(body_mass_g, 0.25, na.rm = TRUE),
            median_weight = median(body_mass_g, na.rm = TRUE),
            third_quartile_weight = quantile(body_mass_g, 0.75, na.rm = TRUE)
  )
group_summary <- penguins %>% 
  group_by(species, island) %>% 
  summarize(n_missing_sex = n_missing(sex), 
            complete_rate_sex = 1-(n_missing_sex/n()),
            n_unique_sex = n_unique(sex),
            mean_weight = mean(body_mass_g, na.rm = TRUE),
            sd_weight = sd(body_mass_g, na.rm = TRUE),
            percentiles_weight = list(quantile(body_mass_g, c(0, 0.25, 0.50, 0.75, 1), na.rm = TRUE)),
            first_quartile_weight = quantile(body_mass_g, 0.25, na.rm = TRUE),
            median_weight = median(body_mass_g, na.rm = TRUE),
            third_quartile_weight = quantile(body_mass_g, 0.75, na.rm = TRUE)
  )
## Keeps data grouped by first group!
group_summary

## Summarize the summary
group_summary %>% 
  ungroup %>% 
  summarize(mean_of_means = mean(mean_weight))
group_summary %>% 
  summarize(mean_of_means = mean(mean_weight))

## Make missing data explicit
### Here: which species-island combinations are not observed
group_summary <- ungroup(group_summary)
group_summary %>%
  complete(species, island)

## Get all combinations of two variables
group_summary %>%
  expand(species, island)


## Combine multiple summary with groups
penguins %>% 
  group_by(species, island) %>% 
  summarise_if(is.numeric,
               list(
                 mean = \(x) mean(x, na.rm = TRUE),
                 median = \(x) median(x, na.rm = TRUE),
                 sd = \(x) sd(x, na.rm = TRUE)
               )) %>%
  pivot_longer(cols = bill_length_mm_mean:year_sd)


## Exercise
### 1. Read the file "data/top10_2020.csv"
### 2. Summarize:
#### 2.1 first and last day observed
#### 2.2 the average number of streams
#### 2.3 the number of unique artists
### 3. Add new variables with the scaled song features
### 4. Summarize the song features for explicit and non-explicit songs separately
#### 4.3 Which summary statistics do you choose?
#### 4.2 Which differences do you see?

