# Layoffs Data Cleaning (MySQL)

Cleaned and prepared a layoffs dataset using MySQL.  
This project was completed by following a guided YouTube tutorial; I executed the steps myself, modified them and documented them to demonstrate understanding of a full data-cleaning workflow.

## What I did (cleaning tasks)
- Loaded the dataset into MySQL
- Created staging tables to protect the raw data
- Identified and removed duplicate rows using `ROW_NUMBER()`
- Standardized text fields (trimmed whitespace, normalized labels like “Crypto”, cleaned country names)
- Converted data types (TEXT → INT/DECIMAL, TEXT → DATE)
- Handled NULL/blank values and removed unusable rows
- Produced a final cleaned table: `layoffs_clean`
- Added indexes and a primary key for better query performance

## Final Output
- Final table: `layoffs_clean`
- Row count after cleaning: **1995**

## Tech Stack
- MySQL
- MySQL Workbench
- SQL

## Files in this repo
- `02_load_data.sql` — notes/commands used to load the data
- `03_cleaning_steps.sql` — full cleaning workflow
- `04_final_checks.sql` — verification queries (row counts, schema checks, sanity checks)

## Dataset Source
Public dataset originally shared in a YouTube tutorial and hosted on GitHub (used for learning/demo purposes).  
Source link: (https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv)



