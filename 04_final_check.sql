-- ============================================
-- Layoffs Data Cleaning Project (MySQL)
-- File: 04_final_checks.sql
-- Purpose: Verify the cleaned output
-- ============================================

USE world_layoffs;

-- Row counts
SELECT COUNT(*) AS raw_rows FROM layoffs;
SELECT COUNT(*) AS cleaned_rows FROM layoffs_clean;

-- Check table schema
DESCRIBE layoffs_clean;

-- Quick sanity checks
SELECT MIN(`date`) AS min_date, MAX(`date`) AS max_date FROM layoffs_clean;
SELECT MIN(percentage_laid_off) AS min_pct, MAX(percentage_laid_off) AS max_pct FROM layoffs_clean;

-- Top 10 companies by total layoffs (example check)
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
GROUP BY company
ORDER BY total_laid_off DESC
LIMIT 10;
