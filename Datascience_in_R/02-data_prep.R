library(tidyverse)
library(skimr)

penguins <- read_csv("data/penguins.csv", col_select = species:year)
skim(penguins)

## Character variables should be factors (very few unique values)
penguins <- penguins %>% 
  mutate(species = as.factor(species),
         island = as.factor(island),
         sex = as.factor(sex))

skim(penguins)

## Select single variable
penguins$species

## Add new variable based on other variables
penguins <- penguins %>% 
  mutate(is_large_male = body_mass_g > median(body_mass_g, na.rm = TRUE) & sex == "male")
penguins$is_large_male

## Add new variable from external data
penguins$row_index <- 1:nrow(penguins)

skim(penguins)

## Example with setting labels
data1 <- data.frame(education = c(1, 0, 1, 2, 0, 0, 0))
data1 <- data1 %>% mutate(education = factor(education,
                                    levels = c(0,1,2), 
                                    labels = c("high-school", "undergraduate", "graduate")))

skim(data1)

## Exercise 
### 1. Read the file "data/food_demographics.csv" 
### 2. Convert the variables starting with "marital_" and "education_" to factors with labels "yes" and "no"
### 3. Add a variable that indicates whether a household has above median income and a dependent lives there (either Kid or Teen)


