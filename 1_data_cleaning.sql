-- DATA CLEANING

SELECT*
FROM layoffs;


-- 1. Remove Duplicates
-- 2. Standardized the data
-- 3.Null values or blank values
-- 4. Remove any columns




CREATE TABLE layoffs_staging
LIKE layoffs;


SELECT*
FROM layoffs_staging;

INSERT layoffs_staging
SELECT * FROM layoffs;

SELECT*
FROM layoffs_staging;


-- 1. remove duplicates

# here we dont have any unique id so we are using row number 
# if row num is 1 means there is only 1 row like this

SELECT *,
ROW_NUMBER() OVER(PARTITiON BY company,industry,total_laid_off,`date`) AS row_num
FROM layoffs_staging;


# Now checking if there are any duplicates using CTE

WITH cte_duplicate as
(   
SELECT *,
ROW_NUMBER() OVER(
PARTITiON BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
     )
     
SELECT *
FROM cte_duplicate
WHERE row_num>1;  

# now here we cant delete or udate or cte so we will create new table then add an extra column row num there ten delte easily   

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num`INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITiON BY 
company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE 
FROM layoffs_staging2
WHERE row_num>1;
     
     # Now checking that we have nothing in duplicate
SELECT *
FROM layoffs_staging2
WHERE row_num>1;     



-- Standardizing Data

SELECT company,TRIM(company)   # Trimming extra space
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company=TRIM(company);     # HERE WE have updated our company column with trimed one

SELECT *
FROM layoffs_staging2;  
-- 1

SELECT DISTINCT industry      # here we have two same industry but labelled as distinct
FROM layoffs_staging2            # srypto,cryptography,cryptography all are same
ORDER BY 1;


SELECT *     
FROM layoffs_staging2
WHERE industry like "Crypto%";

UPDATE layoffs_staging2
SET industry="Crypto"
WHERE industry like "Crypto%";  


-- 2

SELECT DISTINCT country       # found two usa as distinct
FROM layoffs_staging2
ORDER BY 1;


UPDATE layoffs_staging2
SET country="United States"
WHERE country like "United States%";



-- 3  converting string to date datatype
SELECT `date`,                  # USING these we have only change its look not datatype
STR_TO_DATE(`Date`,"%m/%d/%Y") 
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`=STR_TO_DATE(`Date`,"%m/%d/%Y");

ALTER TABLE layoffs_staging2            # here we have changed datatype
MODIFY COLUMN `date` DATE;




-- 3. NUll and blank values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND  percentage_laid_off IS NULL ;


--  now here where industry has null and blank values


SELECT *
FROM layoffs_staging2
WHERE industry IS null 

;


SELECT *
FROM layoffs_staging2
WHERE company="Bally's Interactive";



UPDATE layoffs_staging2
SET industry=null
WHERE industry='';

SELECT *
FROM layoffs_staging2 as t1
JOIN layoffs_staging2 as t2
  ON t1.company=t2.company
  AND t1.location=t2.location
WHERE t1.industry IS NULL  
AND t2.industry IS NOT NULL  ;
  
  
-- Now update

UPDATE layoffs_staging2 as t1
JOIN layoffs_staging2 as t2
  ON t1.company=t2.company
  AND t1.location=t2.location
  SET t1.industry=t2.industry
WHERE t1.industry IS NULL  
AND t2.industry IS NOT NULL  ;


-- now check table
SELECT*
FROM layoffs_staging2
WHERE industry is NULL ;


# here we have so many rows of laid off and perc laid off WHICH are null so we will delete this

DELETE
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS null;



# NOW check

SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS null;


# now we dont need that row_num column in our tablw that we have added , so drop it

ALTER TABLE layoffs_staging2
DROP column row_num;

# now check

select *
from layoffs_staging2;
