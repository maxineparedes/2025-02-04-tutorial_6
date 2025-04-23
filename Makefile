.PHONY: all clean

all: 
	make data/clean_penguins.csv
	make data/processed_penguins.csv results/tables/summary_table.csv results/images/bill_length_boxplot.png
	make data/train_data.csv data/test_data.csv results/models/penguin_model.rds
	make results/models/conf_matrix.rds results/tables/conf_matrix.csv
	make report

# download penguins and remove entries with missing entries
data/clean_penguins.csv: scripts/01_load_data.R 
	Rscript scripts/01_load_data.R \
		--output=data/clean_penguins.csv


# summarizes and visualizes data and selects relevant variables
data/processed_penguins.csv results/tables/summary_table.csv results/images/bill_length_boxplot.png: scripts/02_methods.R
	Rscript scripts/02_methods.R \
		--data_input=data/clean_penguins.csv \
		--data_output=data/processed_penguins.csv \
		--summary_table=results/tables/summary_table.csv \
		--boxplot_image=results/images/bill_length_boxplot.png

# creates train and test split and kknn model
data/train_data.csv data/test_data.csv results/models/penguin_model.rds: scripts/03_model.R
	Rscript scripts/03_model.R \
		--input_data=data/processed_penguins.csv \
		--train_path=data/train_data.csv \
		--test_path=data/test_data.csv \
		--penguin_model=results/models/penguin_model.rds

# generates predictions, computes a confusion matrix, and saves the results for the final report
results/models/conf_matrix.rds results/tables/conf_matrix.csv: scripts/04_results.R
	Rscript scripts/04_results.R \
		--penguin_model=results/models/penguin_model.rds \
		--test_data=data/test_data.csv \
		--conf_mat=results/models/conf_matrix.rds \
		--conf_mat_table=results/tables/conf_matrix.csv 

report: quarto.qmd
	quarto render quarto.qmd --to html --output-dir docs
	quarto render quarto.qmd --to pdf --output-dir docs
