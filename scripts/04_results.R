# 04_results.R

# author: Maxine Paredes
# date: 2024/04/20

"This script loads the trained model and test data,
generates predictions, computes a confusion matrix,
and saves the results for the final report.
Usage: Rscript scripts/04_results.R --penguin_model=<penguin_model> --test_data=<test_data> --conf_mat=results/conf_matrix.rds
" -> doc

opt <- docopt::docopt(opt)

library(tidyverse)
library(tidymodels)
library(readr)

# Load model and test data
penguin_fit <- readRDS(opt$penguin_model)
test_data   <- read_csv(opt$test_data)

# Predict class
predictions <- predict(penguin_fit, test_data, type = "class") %>%
  bind_cols(test_data)

# Compute confusion matrix
conf_mat_result <- conf_mat(predictions, truth = species, estimate = .pred_class)

# Save raw confusion matrix object
saveRDS(conf_mat_result, opt$conf_mat)

# Save tidy table version (optional)
conf_mat_table <- conf_mat_result %>% 
  as_tibble()

write_csv(conf_mat_table, opt$cont_mat_table)

# cmd to run: Rscript scripts/04_results.R --penguin_model=models/penguin_model.rds --test_data=data/test_data.csv --conf_mat=results/conf_matrix.rds --conf_mat_table=results/table/conf_matrix.csv