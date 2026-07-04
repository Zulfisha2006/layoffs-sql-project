-- Exploratory data analysis

SELECT*
FROM layoffs_staging2;

SELECT MAX(total_laid_off),MAx(percentage_laid_off)
FROM layoffs_staging2;


# companies who have fired all employees

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;


SELECT company,sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`),MAX(`date`)
FROM layoffs_staging2;


# WHich industry affected most

SELECT industry,sum(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


# WHich country affected most

SELECT country,sum(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


# total laid off by year

SELECT YEAR(`date`),sum(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`) 
ORDER BY 2 DESC;

SELECT stage,sum(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

# Progression of layoff

WITH rolling_total as (

SELECT SUBSTRING(`date`,1,7) as `month`, SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1
)

SELECT `month`,total_off,sum(total_off) over(order by `month`) as rolling_Total
FROM rolling_total;
   
   
   -- employee lay off per year in difff company
   
SELECT company,YEAR(`date`),sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC
;

WITH company_year (company,years,total_laid_off) as 
(
   SELECT company,YEAR(`date`) as years,sum(total_laid_off)
   FROM layoffs_staging2
   GROUP BY company,YEAR(`date`)
   ORDER BY 3 DESC

),
  
  company_year_rank as
  (
  SELECT*,
  dense_rank()OVER(PARTITION BY years ORDER BY total_laid_off desc) AS laid_off_rank
  FROM company_year
  WHERE years is not null

  )
  
  SELECT *
  FROM company_year_rank
  WHERE laid_off_rank <=5;