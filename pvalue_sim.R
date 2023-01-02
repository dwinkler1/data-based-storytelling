set.seed(123)
effect_sizes <- seq(0, 10, length.out = 1000)
sample_sizes <- seq(2, 1000, length.out = 1000)
sim_input <- expand.grid(effect_sizes, sample_sizes)

p_values <- vector('numeric', nrow(sim_input))
pb <- progress::progress_bar$new(total = length(p_values))
for (iter in 1:length(p_values)) {
  effect_size <- sim_input[iter, 1]
  sample_size <- sim_input[iter, 2]
  p_values[iter] <- t.test(rnorm(sample_size, effect_size), mu = 0)$p.value
  pb$tick()
}

results <- cbind(sim_input, p_values)
names(results) <- c("effect_size", "sample_size", "p_value")

small_effects <- results[results$effect_size >= 0.1 & results$effect_size <= 0.2, ]
plot(small_effects$p_value, small_effects$sample_size)
abline(h = 100)

large_effects <-results[results$effect_size >= 0.3 & results$effect_size <= 0.4, ]
plot(large_effects$p_value, large_effects$sample_size)
abline(h = 100)

library(dplyr)
library(ggplot2)
library(latex2exp)
effect_size <- 0.3
sample_sizes <- 2:200
ndraws <- 30
p_values <- matrix(0, ndraws * length(sample_sizes), ncol = ndraws)
d_values <- matrix(0, ndraws * length(sample_sizes), ncol = ndraws)
for (s in seq_along(sample_sizes)) { 
  samp_size <- sample_sizes[s]
  for (i in 1:ndraws) {
     draw <- rnorm(samp_size, effect_size) 
     p_values[s,i] <- t.test(draw, mu = 0)$p.value
     d_values[s,i] <- cohensD(draw, mu = 0)
  }
}

p_df <- data.frame(p_values)
total_df <- cbind(data.frame(size = sample_sizes), p_df)
total_long <- tidyr::pivot_longer(total_df, 2:ncol(total_df)) |> 
  dplyr::select(-name)

ggplot(total_long, aes(x = size, y = value)) +
  geom_point() +
  theme_minimal() +
  labs(x = "Sample Size", y = "p-value", title = "p-values for different sample sizes", 
       subtitle = TeX("$H_0$: $\\mu = 0$, true: $\\mu = 0.3$"))


d_df <- data.frame(d_values)
dtotal_df <- cbind(data.frame(size = sample_sizes), d_df)
dtotal_long <- tidyr::pivot_longer(dtotal_df, 2:ncol(dtotal_df)) |> 
  dplyr::select(-name)
ggplot(dtotal_long, aes(x = size, y = value)) +
  geom_point() +
  theme_minimal() +
  labs(x = "Sample Size", y = "p-value", title = "p-values for different sample sizes", 
       subtitle = TeX("$H_0$: $\\mu = 0$, true: $\\mu = 0.3$"))



total_long |>
  group_by(size) |>
  summarize(power = sum(value <= 0.05)/length(value)) |>
  ggplot(aes(x = size, y = power)) +
    geom_point()
