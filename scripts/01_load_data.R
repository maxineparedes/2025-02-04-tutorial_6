# 01_load_data.R

# author: Maxine Paredes
# date: 2024/04/20

library(tidyverse)
library(palmerpenguins)
library(tidymodels)
library(docopt)

"this script summarizes and visualizes the data,
and prepares it for modeling by selecting relevant variables
Usage: scripts/01_load_data.R --output=<output_file>
" -> doc

# parses cmd-line arguments
opt <- docopt(doc)

# loads and cleans data
clean_penguins <- penguins %>%
  drop_na()

# save cleaned data
write_csv(clean_penguins, opt$output)

# cmd to run: Rscript scripts/01_load_data.R --output=data/clean_penguins.csv
print("the penguins are clean!")