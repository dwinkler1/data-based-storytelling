library(colorspace)
library(COVID19)
library(esquisse)
library(palmerpenguins)
# comment
# load covid data for austrian states
covid_at <- covid19(country = "AT", level = 2) # comment
sum(covid_at$tests, na.rm = TRUE)
data("penguins") 
saveRDS(covid_at, "covid_at.RDS")
covid_at <- readRDS("covid_at.RDS")

esquisser(data = penguins, viewer = "browser")
?esquisser
esquisser(data = covid_at, viewer = "browser")
plot(covid_at$date, covid_at$tests)
hcl_wizard()
library(readr)
charts_global_at <- read_csv("data/charts_global_at.csv")
View(charts_global_at)
library(readr)
movies <- read_csv(
  "https://raw.githubusercontent.com/fivethirtyeight/data/master/bechdel/movies.csv")
movies$domgross <- as.integer(movies$domgross)
movies$intgross <- as.integer(movies$intgross)
esquisser(movies, viewer = "browser")
