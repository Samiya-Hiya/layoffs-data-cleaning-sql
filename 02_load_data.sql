-- ============================================
-- Layoffs Data Cleaning Project (MySQL)
-- File: 02_load_data.sql
-- Purpose: Load the raw CSV into MySQL
-- Notes:
-- - Workbench import had issues, so LOAD DATA LOCAL INFILE was used.
-- - On macOS, Workbench may block LOCAL INFILE, so loading was done via Terminal mysql client.
-- ============================================

USE world_layoffs;

-- 1) Enable local_infile on server (may require admin privileges)
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

-- 2) Recommended: load via mysql terminal client
-- Terminal command used:
-- mysql --local-infile=1 -u root -p

-- 3) Load CSV into table
-- IMPORTANT: Replace the file path with your own CSV path.
LOAD DATA LOCAL INFILE '/Users/yourname/Downloads/layoffs.csv'
INTO TABLE layoffs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- 4) Verify row count after load
SELECT COUNT(*) FROM layoffs;
