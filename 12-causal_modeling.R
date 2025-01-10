options(digits = 7, scipen = 999)
library(tidyverse)
library(patchwork)
library(gt)
library(ggeffects)
library(parameters)
library(marginaleffects)

# Omitted variable bias simulation
library(stargazer)
set.seed(11)
n <- 1000
d <- 100 * rnorm(n)
x <- -4 + 0.5 * d + 10 * rnorm(n)
y <- 25 + 10 * d + 10 * rnorm(n)
stargazer(
  lm(y ~ d + x),
  lm(y ~ x), ## gamma
  lm(y ~ d), ## beta
  lm(d ~ x), ## theta
  type = 'text')
## See coef of regression y ~ x
beta1 <- coef(lm(y~d))['d']
theta1 <- coef(lm(d~x))['x']
beta1 * theta1


## Diagrams in R
library(DiagrammeR)
mermaid("
graph LR
    Influencer-->Modern[Perceived as Modern]
    Modern-->Purchase
    Influencer-->Purchase
")


## Mediation simulation 
set.seed(11)
X <- 100 * rnorm(n)
M <- 10 + 0.5 * X + 5 * rnorm(n)
Y <- -25 + 0.2 * X + 3 * M + 10 * rnorm(n)
X_on_M <- lm(M ~ X)
avg_direct_effect <- lm(Y ~ X + M)
total_effect <- lm(Y ~ X)
stargazer(
  X_on_M, 
  avg_direct_effect, 
  total_effect, 
  type = 'text')

avg_causal_mediation_effect <- coef(X_on_M)['X'] * coef(avg_direct_effect)['M']
total_effect_alternative <- coef(avg_direct_effect)['X'] + avg_causal_mediation_effect
proportion_mediated <- avg_causal_mediation_effect / total_effect_alternative

mediation_effects <- tribble(
        ~effect,                                  ~value,
        "Average Causal Mediation Effect (ACME):", avg_causal_mediation_effect,
        "Average Direct Effect (ADE):",            coef(avg_direct_effect)['X'],
        "Total Effect:",                           coef(total_effect)['X'],
        "Total Effect (alternative):",             total_effect_alternative,
        "Proportion Mediated:",                    proportion_mediated)

gt(mediation_effects, rowname_col = 'effect')  |>
  tab_options(column_labels.hidden = TRUE) |>
  fmt_number(columns = value, decimals = 3) |>
  tab_header(title = "Causal Mediation Analysis")

## Download and source the PROCESS macro by Andrew F. Hayes
temp <- tempfile()
process_macro_dl <- "https://www.afhayes.com/public/processv43.zip"
download.file(process_macro_dl,temp)
files <- unzip(temp, list = TRUE)
fname <- files$Name[endsWith(files$Name, "process.R")]
source(unz(temp, fname))
unlink(temp)
rm(files)
rm(fname)
rm(process_macro_dl)
rm(temp)

## Run PROCESS
process(
  data.frame(Y, X, M), y = 'Y', x = 'X', m = 'M', model = 4,
  progress = 0, seed = 1, plot = 1
  )

## Annotated diagram in R
library(DiagrammeR)

mermaid("
graph LR
    Influencer-->|0.5***|Modern[Perceived as Modern]
    Modern-->|3.0***|Purchase
    Influencer-->|0.2***|Purchase
")


## Moderation simulation
set.seed(1)
X_mod <- rnorm(10000, 0, 5)
Moderator <- rnorm(10000, 0, 35) 
Y_mod <- -0.15 * X_mod + 0.002 * X_mod * Moderator + rnorm(10000, sd = 2)

moderation_df <- data.frame(y = Y_mod, x = X_mod - mean(X_mod), w = Moderator - mean(Moderator))
ggplot(moderation_df, aes(x = x, y = y, color = cut(w, 10))) + 
  geom_point(size = 0.1, alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE) +
  theme_minimal() +
  guides(color = guide_legend(title = "Moderator", nrow = 2)) +
  theme(legend.position = "top")

moderated_ols <- lm(y ~ x*w, data = moderation_df)
pred_resp <- predict_response(moderated_ols, c("x", "w"))
plot(johnson_neyman(pred_resp)) 

## Estimation in PROCESS
process(moderation_df, y = "y", x = "x", w="w", model=1, jn=1, seed=123)

## Comparison to OLS
summary(moderated_ols)

