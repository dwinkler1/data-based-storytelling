library(colorspace)
library(COVID19)
library(esquisse)
library(palmerpenguins)
# comment
# load covid data for austrian states
covid_at <- covid19("AT", level = 2) # comment
data("penguins") 

esquisser(data = penguins, viewer = "browser")
?esquisser
esquisser(data = covid_at)

hcl_wizard()
