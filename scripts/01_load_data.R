# 01_load_data.R

# author: Maxine Paredes
# date: 2024/04/20

# this scripts loads and reads the data. 
# it also conducts the initial cleaning, and
# removes missing values

# Usage: Rscript 01_load_data.R

library(tidyverse)
library(palmerpenguins)
library(tidymodels)

# loads and cleans data
clean_penguins <- penguins %>%
  drop_na()

# save cleaned data
write_csv(clean_penguins, "data/clean_penguins.csv")
