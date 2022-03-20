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


## Sidebar: user functions
my_function <- function(x,y){
  x2 <- x^2
  y2 <- y^2
  result <- x2 + y2
  return(result)
}
oneliner <- \(x,y) x^2 + y^2
oneliner_old <- function(x, y) x^2 + y^2

my_function(1,2)
oneliner(1,2)
oneliner_old(1,2)

## Change multiple variables based on name
penguins %>% 
  ## Divide all variables with "bill" in the name by 10
  mutate_at(vars(matches('bill')), \(value) value/10) %>%
  ## Rename those variables from "_mm" to "_cm"
  rename_at(vars(matches('bill')), \(name) str_replace(name, 'mm', 'cm'))

## Common in stats/ml: Z score transform aka scale for numeric variables
### x = (x - mean(x))/sd(x) 
### Default: returns a matrix
penguins %>% 
  mutate_if(is.numeric, 
            list(scaled = \(x) as.vector(scale(x)),
                 scaled_manual = \(x) (x - mean(x, na.rm = TRUE))/sd(x, na.rm = TRUE))
            ) %>%
  ## sort columns by name
  ## "." syntax tells R where to put the output of previous line
  select(sort(names(.)))

## Example: bad factors
### 0 => no, 1 => yes, 2 => unknown
data0 <- data.frame(is_student = c(0,1,0,0,1), is_austrian = c(1,1,0,1,2))
data0 <- data0 %>% 
  mutate_at(vars(matches('is_')), \(var) factor(var, 
                                                levels = c(0, 1), 
                                                labels = c("no", "yes")))
skim(data0)

## Simple rename
## rename(data, new = old)
rename(data0,
       austrian = is_austrian,
       student = is_student)

## Note: vectorization
oneliner(c(1,2,3,4), c(2,3,4,5))
### Errors:
# c(1,2) + c(1,2,3)
### Works via recycling if length is multiple:
### Length 1 can always recycle!
c(1,2) + c(1,2,3,4)
c(1 + 1, 2 + 2, 1 + 3, 2 + 4)

## Select single variable
penguins$species

## Select multiple variables
select(penguins, species, bill_length_mm, year)
select(penguins, body_mass_g:year)
select(penguins, bill_length_mm:flipper_length_mm, year)
select(penguins, matches('bill'))
select(penguins, ends_with('mm'))
select(penguins, starts_with('bill'))
select(penguins, matches('length'))


## Remove variables
select(penguins, -year)
select(penguins, -(body_mass_g:year))
select(penguins, -matches('bill'))

## Remove duplicates
### Only fully duplicated rows (none in penguins)
distinct(penguins)
### Duplicated in specific column(s)
distinct(penguins, species)
distinct(penguins, species, island)
### Keep other columns
distinct(penguins, species, island, .keep_all = TRUE)

## Filter observations by value(s) in column(s)
### Single filter
filter(penguins, species == "Adelie")
### Multiple filter
filter(penguins, species == "Adelie", island == "Dream")
### Multiple possible values
filter(penguins, island %in% c("Dream", "Torgersen"))
### Inequalities
filter(penguins, bill_length_mm > 42)
filter(penguins, bill_length_mm >= 42)
filter(penguins, bill_length_mm < 42)
### Filter by range
filter(penguins, between(bill_length_mm, 42, 43))
filter(penguins, bill_length_mm >= 42, bill_length_mm <= 43)

## Check for equality of two data.frames
### With info on what is different
all_equal(
  filter(penguins, between(bill_length_mm, 42, 43)),
  filter(penguins, bill_length_mm >= 42, bill_length_mm <= 43)
)
all_equal(
  filter(penguins, between(bill_length_mm, 42, 43)),
  filter(penguins, bill_length_mm >= 42)
)

## Sort data
### First by species than descending by body mass (default ascending)
arrange(penguins, species, desc(body_mass_g))

## Add counts for groups
penguins <- add_count(penguins, species, island)
head(penguins);tail(penguins)
distinct(penguins, species, island, .keep_all = TRUE) %>% 
  ggplot(aes(y = n, x = island, fill = species)) + 
    geom_bar( stat="identity")

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
                                    labels = c("high-school", "undergraduate", "graduate")),
                          value = rnorm(7))

skim(data1)

## Add new observations to existing data
data2 <- data.frame(education = factor(c(1,0,0,2,NA,2),
                                       levels = c(0,1,2), 
                                       labels = c("high-school", "undergraduate", "graduate")),
                    value = rnorm(6)
                    )
data_full <- rbind(data1,data2)
skim(data_full)

## Handle missings
### Drop
#### All columns
drop_na(data2)
#### Specific column
drop_na(data2, value)

### replace
replace_na(data2, list(education = "graduate"))
#### coalesce will use first non-missing argument (could be two variables)
data2$education_alt <- "high-school"
data2
mutate(data2, education = coalesce(education, education_alt))

## Combined/separated columns
data3 <- data.frame(name = c("Daniel Winkler", "Peter Knaus"), grade = c(3, 1))
data3
separate(data3, name, into = c("first_name", "last_name"))

data4 <- data.frame(century = c('19', '19', '20', '19'), year = c('84', '60', '11', '00'), value = 1:4)
data4
unite(data4, century, year, col = "year", sep="")

## Exercise 
### 1. Read the file "data/food_demographics.csv" 
### 2. Convert the variables starting with "marital_" and "education_" to factors with labels "yes" and "no"
### 3. Add a variable that indicates whether a household has above median income and a dependent lives there (either Kid or Teen)
### 4. Sort the data by income (descending)
### 5. Make sure there are no duplicate rows in the data
### 6. Save a new data.frame including only customers who have purchased in the last 30 days
###   (variable: "Recency" indicates days since last purchase)



