library(colorspace)
library(COVID19)
library(esquisse)
library(palmerpenguins)

covid_at <- covid19("AT", level = 2)
data("penguins")

esquisser(data = penguins)

esquisser(data = covid_at)

hcl_wizard()
