-- ============================================
-- Layoffs Data Cleaning Project (MySQL)
-- File: 03_cleaning_steps.sql
-- Notes:
-- - Completed by following a guided YouTube tutorial.
-- - Steps executed, modified and documented for learning.
-- ============================================

-- 1) Select database
USE world_layoffs;

-- 2) Create staging table (copy of raw)
DROP TABLE IF EXISTS layoffs_staging;
CREATE TABLE layoffs_staging LIKE layoffs;
INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- 3) Identify duplicates (exact match across all columns)
-- (Preview duplicates)
WITH duplicate_cte AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
                   `date`, stage, country, funds_raised_millions
      ORDER BY company
    ) AS row_num
  FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- 4) Create a deduped staging table and remove duplicates
DROP TABLE IF EXISTS layoffs_staging2;
CREATE TABLE layoffs_staging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off TEXT,
  percentage_laid_off TEXT,
  `date` TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions TEXT,
  row_num INT
);

INSERT INTO layoffs_staging2
SELECT
  *,
  ROW_NUMBER() OVER (
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
                 `date`, stage, country, funds_raised_millions
    ORDER BY company
  ) AS row_num
FROM layoffs_staging;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- 5) Standardize text (trim, consistent labels)
UPDATE layoffs_staging2 SET company = TRIM(company);

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- 6) Convert date column (from MM/DD/YYYY text to DATE)
-- Preview conversion:
-- SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y') FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 7) Clean numeric columns stored as text
UPDATE layoffs_staging2
SET total_laid_off = NULL
WHERE total_laid_off = '' OR total_laid_off REGEXP '[^0-9]';

UPDATE layoffs_staging2
SET funds_raised_millions = NULL
WHERE funds_raised_millions = '' OR funds_raised_millions REGEXP '[^0-9]';

UPDATE layoffs_staging2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '';

UPDATE layoffs_staging2
SET percentage_laid_off = REPLACE(percentage_laid_off, '%', '')
WHERE percentage_laid_off LIKE '%';

-- 8) Alter numeric column types
ALTER TABLE layoffs_staging2
MODIFY COLUMN total_laid_off INT;

ALTER TABLE layoffs_staging2
MODIFY COLUMN funds_raised_millions INT;

ALTER TABLE layoffs_staging2
MODIFY COLUMN percentage_laid_off DECIMAL(5,2);

-- Note:
-- percentage_laid_off values are stored as fractions (0–1).
-- Verified using MIN/MAX checks; no further normalization required.

-- 9) Handle NULL/blank industry and remove unusable rows
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Fill missing industry using another row with same company
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Remove rows where both key layoff measures are NULL
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- 10) Drop helper column
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- 11) Create final clean table
DROP TABLE IF EXISTS layoffs_clean;

CREATE TABLE layoffs_clean AS
SELECT *
FROM layoffs_staging2;

-- 12) Add primary key (id) to final table
ALTER TABLE layoffs_clean
ADD COLUMN id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY;

-- 13) Add helpful indexes (TEXT columns require prefix length)
CREATE INDEX idx_layoffs_clean_company ON layoffs_clean(company(255));
CREATE INDEX idx_layoffs_clean_industry ON layoffs_clean(industry(255));
CREATE INDEX idx_layoffs_clean_date ON layoffs_clean(`date`);






