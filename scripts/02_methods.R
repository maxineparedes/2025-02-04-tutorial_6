# 02_methods.R

# author: Maxine Paredes
# date: 2024/04/20

library(tidyverse)
library(readr)
library(docopt)

"this script summarizes and visualizes the data,
and prepares it for modeling by selecting relevant variables
Usage: Rscript scripts/02_methods.R --data_input=<input_file> --data_ouput=<data_ouput> --summary_table=<summary_table> --boxplot_image=<boxplot_image>
" -> doc

# parses the cmd-line arguments
opt <- docopt(doc)

# load the cleaned data
data <- read_csv(opt$data_input)

# Summary statistics
glimpse(data)
summary_stats <- summarise(
  data,
  mean_bill_length = mean(bill_length_mm),
  mean_bill_depth = mean(bill_depth_mm)
)

# save summary stats to file (for reporting)
write_csv(summary_stats, opt$summary_table)

# Visualizations
boxplot <- ggplot(data, aes(x = species, y = bill_length_mm, fill = species)) +
  geom_boxplot() +
  theme_minimal()

# save the image
ggssave(opt$boxplot_image, boxplot)

# Prepare data for modeling
processed_data <- data %>%
  select(species, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
  mutate(species = as.factor(species))

# save processed data
write_csv(processed_data, data_ouput)

# cmd to run: Rscript scripts/02_methods.R --data_input=data/clean_penguins.csv --data_ouput=data/processed_penguins.csv --summary_table=results/tables/summary_table.png --boxplot_image=results/images/bill_length_boxplot.png