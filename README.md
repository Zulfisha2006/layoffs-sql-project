Global Layoffs — SQL Data Cleaning & Exploratory Data Analysis

Overview

This project uses MySQL to clean and analyze a real-world dataset of global company layoffs (2020–2023). The goal was to take a messy, raw dataset and turn it into a clean, analysis-ready table, then extract meaningful insights about which industries, countries, and companies were hit hardest — and how layoffs trended over time.


Dataset

Source: Global tech/company layoffs dataset, ~2,360 rows
Fields: company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions


Tools Used

MySQL (MySQL Workbench)
Window functions, CTEs, joins, aggregate functions


Part 1: Data Cleaning

Raw data had duplicate rows, inconsistent text formatting, missing values, and incorrect data types. Steps taken:


1. Staged the data — created working copies (layoffs_staging, layoffs_staging2) so the raw table stayed untouched.
2. Removed duplicates — used ROW_NUMBER() inside a CTE  to identify exact duplicate rows, then deleted rows where row_num > 1.
3. Standardized text data — trimmed whitespace from company names, merged inconsistent category labels (e.g. "Crypto", "Cryptocurrency", "CryptoCurrency" → "Crypto"; "United States" vs "United States." → "United States").
4. Fixed data types — converted date from text to a proper DATE type using STR_TO_DATE(), and converted percentage_laid_off from text to DECIMAL so it could be used in calculations.
5. Handled missing values — backfilled missing industry values using a self-join on matching company + location, then deleted rows where both total_laid_off and percentage_laid_off were NULL, since those rows had no usable metric for analysis.
6. Dropped helper columns — removed the temporary row_num column once deduplication was complete.


Part 2: Exploratory Data Analysis

Key questions explored:


1. Which companies laid off 100% of their staff, and how much funding had they raised?
2. Which industries and countries were affected the most?
3. How did total layoffs trend by year and by company funding stage?
4. What was the month-by-month rolling total of layoffs over the full period?
5. Which 5 companies had the highest layoffs in each year? (using DENSE_RANK())


Key Findings


1. The dataset covers layoffs from 2020-03-11 to 2023-03-06.
2. Consumer Industry had the highest total layoffs, at 45182 employees.
3. United States was the most affected country, with 256559 total layoffs.
4. 2022 was the year which saw the highest number of layoffs overall, at 160661.
5. Amazon had the single largest layoff event, cutting 18150 employees.


Files


1_data_cleaning.sql — full data cleaning script
2_eda.sql — exploratory data analysis queries
layoffs.csv — raw dataset


What I Learned


- How to safely deduplicate data using window functions when no unique ID exists
- Backfilling missing values using self-joins instead of dropping data unnecessarily
- Writing CTEs to build rolling totals and rank top performers within groups using DENSE_RANK()
- Making deliberate, defensible decisions about what data to drop vs. keep
