-- Data Cleaning

select * 
from layoffs;

-- 1. Remove Duplicates
-- 2. Strandardize the Data
-- 3. Null valus and Blank values
-- 4. Remove any columns or rows

create table layoff_staging
like layoffs;

insert layoff_staging
select *
from layoffs;

select *,
row_number () over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) as row_num
from layoff_staging;

with duplicate_cte as
(
select *,
row_number () over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) as row_num
from layoff_staging
)
select *
from duplicate_cte
where row_num > 1;

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoff_staging2
where row_num > 1;

insert into layoff_staging2
select *,
row_number () over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) as row_num
from layoff_staging;

delete from layoff_staging2
WHERE row_num > 1;

select *
from layoff_staging2;

-- Standardizing Data

select company, trim(company)
from layoff_staging2;

update layoff_staging2
set company = trim(company);

select distinct industry
from layoff_staging2;

select *
from layoff_staging2
where industry like 'Crypto%';

update layoff_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct country, trim(trailing '.' from country)
from layoff_staging2
order by 1;

update layoff_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

select `date`
from layoff_staging2;

update layoff_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoff_staging2
modify column `date` date;

select * 
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;

update layoff_staging2
set industry = null
where industry = '';

select *
from layoff_staging2
where industry is null
or industry = '';

select *
from layoff_staging2
where company = "Bally's Interactive";

select t1.industry, t2.industry
from layoff_staging2 t1
join layoff_staging2 t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoff_staging2 t1
join layoff_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;

select * 
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete 
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoff_staging2;

alter table layoff_staging2
drop column row_num;









