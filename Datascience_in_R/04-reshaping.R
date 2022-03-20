library(tidyverse)
library(skimr)

top10_songs <- read_csv("data/top10_charts.csv")
# drop_na will remove all rows with missing values (i.e., all song/day combinations where a song is not both in at and global charts)
charts_wide <- pivot_wider(top10_songs, 
                           names_from = region, 
                           values_from = c(streams, rank)) %>% drop_na
charts_wide
skim(charts_wide)

charts_long <- pivot_longer(charts_wide, cols = at:global, 
              names_to = "region",
              values_to = "streams")
charts_long
skim(charts_long)

## The following command loads data for the 2000 billboard rankings per week:
data("billboard")
skim(billboard)
### 1. Select the variables "artist", "track", "date.entered", and "wk1" to "wk65"
### Hint: see ?select and also see the script 02-data_prep: "col_select"
### 2. Reshape the data to long format where each row contains the ranking of a song in a given week (keep all missing values!)
### 3. Reshape the long format back to wide format where each row contains a song and the chart ranking is contained in the columns
