# 03_model.R

# author: Maxine Paredes
# date: 2025/04/20

library(tidyverse)
library(tidymodels)
library(readr)
library(docopt)

"# This script splits the processed penguins data,
# fits a k-NN classification model, and saves the model + data splits.
Usage: Rscript scripts/03_model.R --input_data=<input_data> --train_path=<train_path> --test_path=<test_path> --penguin_model=<penguin_model>
" -> doc

opt <- docopt(doc)

data_split <- initial_split(doc$input_data, strata = species)
train_data <- training(data_split)
test_data <- testing(data_split)

# save train and test
write_csv(train_data, opt$train_path)
write_csv(test_data, opt$test_path)

# Define model
penguin_model <- nearest_neighbor(mode = "classification", neighbors = 5) %>%
  set_engine("kknn")

# Create workflow
penguin_workflow <- workflow() %>%
  add_model(penguin_model) %>%
  add_formula(species ~ .)

# Fit model
penguin_fit <- penguin_workflow %>%
  fit(data = train_data)

# save model
saveRDS(penguin_fit, opt$penguin_model)

# cmd to run: Rscript scripts/03_model.R --input_data=data/processed_penguins.csv --train_path=data/train_data.csv --test_path=data/test_data.csv --penguin_model=model/penguin_model.rds