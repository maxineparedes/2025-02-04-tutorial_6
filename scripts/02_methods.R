# 02_methods.R

# author: Maxine Paredes
# date: 2024/04/20

# this script summarizes and visualizes the data,
# and prepares it for modeling by selecting relevant variables

library(tidyverse)
library(readr)

# load the cleaned data
data <- read_csv("data/clean_penguins.csv")

# Summary statistics
glimpse(data)
summary_stats <- summarise(
  data,
  mean_bill_length = mean(bill_length_mm),
  mean_bill_depth = mean(bill_depth_mm)
)

# save summary stats to file (for reporting)
write_csv(summary_stats, "results/summary_stats.csv")

# Visualizations
boxplot <- ggplot(data, aes(x = species, y = bill_length_mm, fill = species)) +
  geom_boxplot() +
  theme_minimal()

# save the image
ggssave("results/bill_length_boxplot.png", boxplot)

# Prepare data for modeling
processed_data <- data %>%
  select(species, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
  mutate(species = as.factor(species))

# save processed data
write_csv(processed_data, "data/processed_penguins.csv")