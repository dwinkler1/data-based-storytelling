library(tidyverse)

top10_songs <- read_csv("data/top10_charts.csv")
skim(top10_songs)
top10_meta <- read_csv("data/top10_meta.csv")
skim(top10_meta)

top10 <- left_join(top10_songs, top10_meta, by = "trackID")
skim(top10)

## Two datasets for same group
data1 <- data.frame(group = c('a', 'a', 'b','c'), value = c(1,2,3,4))
data2 <- data.frame(group2 = c('a', 'c', 'd'), value2 = factor(c("abc", "def", "ghi")))

## All from left - matching from right
left_join(data1, data2, by = c("group" = "group2"))
## All from right - matching from left
right_join(data1, data2, by = c("group" = "group2"))
## All from left and right
full_join(data1, data2, by = c("group" = "group2"))
## Only matching
inner_join(data1, data2, by = c("group" = "group2"))
## return only left if it has a match in right
semi_join(data1, data2, by = c("group" = "group2"))
## return only left if it does not have a match in right
anti_join(data1, data2, by = c("group" = "group2"))

## Exercise
### 1. Read the files "data/food_demographics.csv" and "data/food_customer.csv"
### 2. Join the two files (note that we have demographics but no customer data for 10 households)
### 2.1. Which variable should you choose for merging?
### 2.2. What type of join do you prefer in this situation? Why?
