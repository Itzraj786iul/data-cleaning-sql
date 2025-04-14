-- DATA CLEANING

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null values or blank values
-- 4. Remove Any Columns

-- Create staging table
CREATE TABLE layoffs_stagging
LIKE layoffs;

SELECT distinct locationf
FROM layoffs_stagging;

-- Insert data into staging table
INSERT INTO layoffs_stagging
SELECT *
FROM layoffs;

-- Identify duplicate records
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
               `date`, stage, country, funds_raised_millions
           ) AS row_num
    FROM layoffs_stagging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Check specific company data
SELECT *
FROM layoffs_stagging
WHERE company = 'Casper';


WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
               `date`, stage, country, funds_raised_millions
           ) AS row_num
    FROM layoffs_stagging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;





CREATE TABLE `layoffs_stagging2` (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` INT DEFAULT NULL,
    `percentage_laid_off` TEXT,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised_millions` INT DEFAULT NULL,
    `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_stagging2
WHERE row_num>1; 

INSERT INTO layoffs_stagging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_stagging;


DELETE
FROM layoffs_stagging2
WHERE row_num>1; 


SELECT *
FROM layoffs_stagging2;


-- STANDARDIZING DATA
SELECT company,trim(company)
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET company=trim(company)	;


SELECT distinct industry
FROM layoffs_stagging2
order by 1
;



UPDATE  layoffs_stagging2
SET industry='Crypto'
WHERE industry like 'Crypto%';


SELECT distinct country,Trim(trailing  '.' from country)
FROM layoffs_stagging2
order by 1
;

update layoffs_stagging2
set country =Trim(trailing  '.' from country)
where country like  'United States%';
	

SELECT `date`
FROM layoffs_stagging2
;


update layoffs_stagging2
set `date`=str_to_date(`date`,'%m/%d/%Y');


alter table layoffs_stagging2
modify column 	`date` date;


select *
from layoffs_stagging2
where total_laid_off is null 
and percentage_laid_off is null ;

update layoffs_stagging2
set industry=null
where industry = '';

select *
from layoffs_stagging2
where industry is null
or industry='' ;

select *
from layoffs_stagging2
where company='Airbnb' ;

SELECT t1.industry,t2.industry
FROM layoffs_stagging2 t1
join layoffs_stagging2 t2
   on t1.company=t2.company
   and t1.location=t2.location
where (t1.industry is null or t1.industry='')
and t2.industry is not null
;


update layoffs_stagging2 t1
join layoffs_stagging2 t2
  on t1.company=t2.company
set t1.industry=t2.industry
where t1.industry is null 
and t2.industry is not null;

select *
from layoffs_stagging2
where company like 'Bally%';

select *
from layoffs_stagging2;


select *
from layoffs_stagging2
where total_laid_off is null 
and percentage_laid_off is null ;


delete
from layoffs_stagging2
where total_laid_off is null 
and percentage_laid_off is null; 	

select *
from layoffs_stagging2;

alter table layoffs_stagging2 
drop column  row_num;