# Run once:
#install.packages(c(
# "data.table", "arrow", "palmerpenguins", "dplyr", "tidyr", "janitor"
#))
# data.table::fread => csv
# arrow => many formats (see https://arrow.apache.org/docs/r/articles/read_write.html) 
#  
install.packages("palmerpenguins")
library(palmerpenguins)
penguins_raw
library(dplyr)
library(tidyr)
library(janitor)

penguins_raw
p <- clean_names(penguins_raw)
p

# Aggregate
p |>
    summarize(
        avg_flipper_length_mm = mean(flipper_length_mm, na.rm = TRUE),
        avg_body_mass_g = mean(body_mass_g, na.rm = TRUE)
    )

# Mutate
p <- p |>
    mutate(
        flipper_length_cm = flipper_length_mm / 10,
        body_mass_kg = body_mass_g / 1000
    )
p

# Select (horizontal)
body_flipper <- p |>
    select(
        species,
        sex,
        starts_with("flipper"),
        starts_with("body"),
        -ends_with("kg")
    )
body_flipper

# Filter (vertical)
## Filters "in" rows
b_f_nomiss <- body_flipper |>
    filter(!is.na(sex), !is.na(flipper_length_mm), !is.na(body_mass_g))
coalesce(body_flipper$sex, "MISSING")
b_f_nomiss

# Arrange
b_f_nomiss |>
    arrange(species, desc(flipper_length_mm))

# Group By
species_means <- b_f_nomiss |>
    group_by(species, sex) |>
    summarize(
        s_avg_flip_len = mean(flipper_length_mm),
        s_avg_bmass = mean(body_mass_g),
        s_obs = n()
    )
species_means

# Join
## Inner Join
species_means |>
    inner_join(b_f_nomiss, by = "species")

# special join data
dfa <- data.frame(g = c("a", "a", "b", "c"), x = 1:4)
dfb <- data.frame(g = c("a", "b", "b", "d"), y = 5:8)
dfa
dfb
# Only return groups in both datasets
inner_join(dfa, dfb, by = "g")
# Return all groups in both datasets
full_join(dfa, dfb, by = "g")
# Return all groups in first dataset
left_join(dfa, dfb, by = "g")
# Return groups not in second dataset
anti_join(dfa, dfb, by = "g")


