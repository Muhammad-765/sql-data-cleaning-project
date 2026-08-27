# SQL Data Cleaning & Transformation Project

A practical MySQL data-cleaning project focused on preparing a real-world layoffs dataset for reliable analysis.

## Project Overview

This project demonstrates an end-to-end SQL data-cleaning workflow using MySQL. The raw layoffs dataset was inspected, staged, cleaned, standardized, and prepared for downstream analysis.

The project focuses on data quality rather than exploratory analysis, with particular attention to duplicate records, inconsistent text values, date formatting, missing values, and records without meaningful layoff information.

## Objectives

- Create a safe staging environment without modifying the raw dataset.
- Identify and remove duplicate records.
- Standardize inconsistent text values.
- Convert date values from text into a proper SQL `DATE` type.
- Handle blank and `NULL` industry values.
- Remove records where both layoff measures are missing.
- Produce a cleaner dataset ready for analysis.

## Dataset

The raw dataset contains **2,361 records and 9 columns**:

- `company`
- `location`
- `industry`
- `total_laid_off`
- `percentage_laid_off`
- `date`
- `stage`
- `country`
- `funds_raised_millions`

## Data Cleaning Workflow

### 1. Staging the raw data

A staging table was created with the same structure as the original table. The raw data was then copied into the staging table so the original dataset remained unchanged.

### 2. Duplicate detection and removal

`ROW_NUMBER()` with `PARTITION BY` was used across the dataset columns to identify duplicate records.

The raw dataset contained **5 duplicate records**, which were removed from the staging table.

### 3. Text standardization

Several inconsistent text values were cleaned:

- Leading/trailing whitespace was removed from company names using `TRIM()`.
- Industry values beginning with `Crypto` were standardized to `Crypto`.
- Trailing periods were removed from country values such as `United States.`.

### 4. Date transformation

The original `date` values were stored as text. They were converted using:

- `STR_TO_DATE()`
- `ALTER TABLE ... MODIFY COLUMN`

The final column was converted to the MySQL `DATE` data type.

### 5. Handling missing industry values

Blank industry values were converted to `NULL`.

A self-`JOIN` was then used to populate missing industry values when another record for the same company contained a valid industry.

### 6. Removing unusable records

Records where both `total_laid_off` and `percentage_laid_off` were `NULL` were removed because they did not contain meaningful layoff information.

This removed **361 records** after duplicate removal.

### 7. Final cleanup

The temporary `row_num` column used for duplicate detection was removed from the final staging table.

## Results

| Stage | Records |
|---|---:|
| Raw dataset | 2,361 |
| Duplicate records removed | 5 |
| After duplicate removal | 2,356 |
| Records with both layoff measures missing | 361 |
| Final cleaned dataset | 1,995 |

The final dataset is substantially cleaner and better suited for further SQL analysis, visualization, or dashboard development.

## SQL Concepts & Techniques

- MySQL
- `CREATE TABLE ... LIKE`
- `INSERT INTO ... SELECT`
- Common Table Expressions (CTEs)
- Window functions
- `ROW_NUMBER()`
- `PARTITION BY`
- `TRIM()`
- `STR_TO_DATE()`
- `ALTER TABLE`
- `UPDATE`
- `DELETE`
- Self-joins
- `NULL` handling
- Duplicate detection
- Data standardization

## Project Structure

```text
sql-data-cleaning-project/
├── data/
│   └── layoffs_raw.csv
├── docs/
│   └── linkedin_project.md
├── sql/
│   └── data_cleaning.sql
├── .gitignore
└── README.md
```

## How to Run

1. Create a MySQL database.
2. Import the raw `layoffs_raw.csv` dataset into a table named `layoffs`.
3. Open `sql/data_cleaning.sql` in MySQL Workbench.
4. Run the script in sequence.
5. Review `layoff_staging2` after the cleaning process.
6. Use the resulting cleaned table for further analysis.

> The SQL script is intentionally kept as a separate file so the cleaning process can be reviewed step by step.

## Skills Demonstrated

This project demonstrates practical skills in:

**SQL • MySQL • Data Cleaning • Data Transformation • Data Quality • CTEs • Window Functions • Data Validation • Missing-Value Handling • Duplicate Detection**

## Next Step

The cleaned dataset can be used for a follow-up exploratory data analysis project, such as analyzing layoffs by company, industry, country, funding stage, date, and percentage of workforce affected.
