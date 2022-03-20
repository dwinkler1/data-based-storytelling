library(haven)
library(readxl)
library(tidyverse)
## Reading different formats
penguins <- read_csv("data/penguins.csv", col_select = species:year)
penguins_xl <- read_excel("data/penguins.xlsx", sheet = 1, range = "B1:I345")
penguins_spss <- read_sav("data/penguins.sav", col_select = species:year)

## Writing different formats
### Excel can read csv
write_csv(penguins, file = "data/penguins_output.csv")
write_sav(penguins, path = "data/penguins_output.sav")

## Exercise
### Read the the file "data/icecream.xlsx" and save it as a csv