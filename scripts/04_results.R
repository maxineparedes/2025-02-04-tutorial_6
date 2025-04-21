# 04_results.R

# author: Maxine Paredes
# date: 2024/04/20

library(tidyverse)
library(tidymodels)
library(readr)
library(docopt)

"This script loads the trained model and test data,
generates predictions, computes a confusion matrix,
and saves the results for the final report.
Usage: scripts/04_results.R --penguin_model=<penguin_model> --test_data=<test_data> --conf_mat=<conf_mat> --conf_mat_table=<conf_mat_table>
" -> doc

opt <- docopt(doc)

# Load model and test data
penguin_fit <- readRDS(opt$penguin_model)
test_data <- read_csv(opt$test_data) %>%
  mutate(species = as.factor(species))

# Predict class
predictions <- predict(penguin_fit, test_data, type = "class") %>%
  bind_cols(test_data)

# Compute confusion matrix
conf_mat_result <- conf_mat(predictions, truth = species, estimate = .pred_class)

# Save raw confusion matrix object
saveRDS(conf_mat_result, opt$conf_mat)

# Save tidy summary
conf_mat_table <- as_tibble(summary(conf_mat_result))
write_csv(conf_mat_table, opt$conf_mat_table)

# cmd to run: Rscript scripts/04_results.R --penguin_model=results/models/penguin_model.rds --test_data=data/test_data.csv --conf_mat=results/models/conf_matrix.rds --conf_mat_table=results/tables/conf_matrix.csv
print("we did it!!!")