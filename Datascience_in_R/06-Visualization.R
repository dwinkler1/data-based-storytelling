library(tidyverse)
library(skimr)
library(colorspace)

penguins <- read_csv("data/penguins.csv")

## Anatomy of a ggplot
### ggplots are based on layers
### Always start with the 'ggplot' function
### 'aes' define the aesthetics: axes, colors, ...
plt <- ggplot(penguins, aes(x = species))
### 'geom's define the type of visualization
plt + geom_bar()
### 'aes' can be added to just one layer
plt + geom_bar(aes(fill = island))
plt <- ggplot(penguins, aes(x = fct_infreq(species))) +
  labs(x = "species")
plt + geom_bar(aes(fill = island))

## plots can be exported using 'ggsave'
### by default that exports the last plot
ggsave("penguin_counts.png")
### Equivalent 
ggsave("penguin_counts.png", 
       plot = plt + geom_bar(aes(fill = island)))
### You can set the dimensions of the plot
plt_out <- plt + geom_bar(aes(fill = island))
ggsave("penguin_counts_wider.png", 
       plt_out,
       width = 10, height = 5)
### Default unit is inches 
ggsave("penguin_counts_wider.png", 
       plt_out,
       width = 25.4, height = 12.7,
       units = "cm")
### We can scale the plot
ggsave("penguin_counts_scaled.png", 
       plt_out,
       width = 10, height = 5, scale = 0.5)

## Most important plot types
### Counts: bar
### Compare total counts per species
plt + geom_bar(aes(fill=island))
### Compare count per species and island
plt + geom_bar(aes(fill = island), position = "dodge")
plt + 
  geom_bar(aes(fill = fct_infreq(island)), 
               position = "dodge") +
  labs(fill = "island")
### Compare shares
plt + geom_bar(aes(fill = island), position = "fill") 

### Distribution
### Histogram, Density, Boxplots
p_hist <- ggplot(penguins, aes(x = body_mass_g, fill = species)) +
  geom_histogram()
p_hist
### Faceting
p_hist + facet_wrap(~species, nrow = 3)
### 'alpha' sets transparency
p_dens <- ggplot(penguins, aes(x = body_mass_g, fill = species)) +
  geom_density(alpha = 0.5)
p_dens

p_box <- ggplot(penguins, aes(x = body_mass_g, fill = species)) +
  geom_boxplot()
p_box
p_box + coord_flip()

### Faceting by two variables
p_box + 
  coord_flip() +
  facet_grid(sex ~ island)

### Dotplot
penguins %>% 
  group_by(species) %>%
  summarise(avg_weight = mean(body_mass_g, na.rm=TRUE)) %>%
  ggplot(aes(y = fct_reorder(species, avg_weight), x = avg_weight)) +
  geom_point() +
  theme_minimal() +
  theme(axis.title.y = element_blank()) +
  labs(x = "Average weight")

penguins %>% 
  group_by(species) %>%
  summarise(avg_weight = mean(body_mass_g, na.rm=TRUE),
            sd_weight = sd(body_mass_g, na.rm = TRUE)) %>%
  ggplot(aes(y = fct_reorder(species, avg_weight), x = avg_weight)) +
  geom_pointrange(aes(xmin = avg_weight - sd_weight, xmax =avg_weight + sd_weight)) +
  theme_minimal() +
  theme(axis.title.y = element_blank()) +
  labs(x = "Average weight")

## Time series
top10 <- read_csv("data/top10_charts.csv")
streams <- top10 %>% 
  filter(region == "global") %>% 
  group_by(day) %>% 
  summarize(streams = sum(streams))
streams

ggplot(streams, aes(x = day, y = streams)) +
  geom_line(color = 'darkblue') 

options(scipen = 999)
### Add some formatting
ggplot(streams, aes(x = day, y = streams)) +
  geom_line(color = 'darkblue') +
  scale_y_continuous(labels = scales::comma)

## Labels and themeing
ggplot(streams, aes(x = day, y = streams)) +
  geom_line(color = 'darkblue') +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal()

ggplot(streams, aes(x = day, y = streams)) +
  geom_line(color = 'darkblue') +
  scale_y_continuous(labels = scales::comma, limits = c(0, NA)) +
  theme_minimal() +
  theme(axis.line = element_line())

Sys.setlocale("LC_ALL", "en_US.UTF-8")

ggplot(streams, aes(x = day, y = streams)) +
  geom_line(color = 'darkblue') +
  scale_y_continuous(labels = scales::comma, limits = c(0, NA)) +
  theme_minimal() +
  theme(axis.line = element_line(),
        axis.title.x = element_blank())


ggplot(streams, aes(x = day, y = streams)) +
  geom_line(color = 'darkblue') +
  scale_y_continuous(labels = scales::comma, 
                     limits = c(0, NA), # Start y-axis at 0
                     expand = c(0, NA)) + # do not expand below 0
  theme_minimal() +
  theme(axis.line = element_line(),
        axis.title = element_blank()) +
  labs(title = "Daily global streams of top 200")

streams <- arrange(streams, day)
streams$change_streams <- c(NA, diff(streams$streams))
streams$is_positive <- factor(streams$change_streams > 0)
plt_diff <- ggplot(streams, aes(x = day, y = change_streams, fill = is_positive)) +
  geom_bar(stat = 'identity', show.legend = FALSE) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Change in streams", 
       subtitle = "compared to previous day",
       caption = "Source: Spotify") +
  theme_minimal() +
  theme(axis.title = element_blank())
plt_diff

## Annotations
plt_diff +
  annotate("text", 
           x = as.Date('2020-11-20'), 
           y = 42000000, 
           label = "Christmas",
           hjust = 0,
           color = scales::hue_pal()(2)[2]
           )

plt_diff +
  annotate("rect", 
           xmin = as.Date('2020-12-20'),
           xmax = as.Date('2020-12-30'),
           ymin = -70000000,
           ymax = 65000000, 
           fill = 'firebrick',
           alpha = 0.2
  ) +
  annotate("text",
           x = as.Date('2020-11-20'), 
           y = 42000000, 
           label = "Christmas time",
           color = 'firebrick')

ggplot(streams, aes(x = day, y = change_streams, fill = change_streams)) +
  geom_bar(stat = 'identity') +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_continuous_diverging(labels = scales::comma) +
  labs(title = "Change in streams", 
       subtitle = "compared to previous day",
       caption = "Source: Spotify") +
  theme_minimal() +
  theme(axis.title = element_blank())

## Multiple variables
plt_mult <- ggplot(penguins, aes(x = body_mass_g, y = bill_depth_mm, color = sex)) +
  geom_point() +
  facet_wrap(~species)
plt_mult
## Add OLS line
plt_mult + geom_smooth(method = 'lm', se = FALSE)
