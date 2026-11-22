-- 
-- PROJECT: Government CPSE Financial Performance Analysis
-- FILE: 04_Data_Validation.sql
-- PURPOSE: Validate imported MySQL data
--

-- 1. CPSE MASTER VALIDATION

-- Check imported record counts
SELECT COUNT(*) FROM cpse_master;

SELECT COUNT(*) FROM fact_profit_loss;

SELECT COUNT(*) FROM fact_turnover;

SELECT COUNT(*) FROM fact_st_borrowings;

SELECT COUNT(*) FROM fact_lt_borrowings;

SELECT COUNT(*) FROM fact_employee_benefits;

-- Check unique CPSE IDs
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT cpse_id) AS unique_cpse_ids
FROM cpse_master;

-- Check missing company names
SELECT COUNT(*) AS missing_company_names
FROM cpse_master
WHERE canonical_name IS NULL
   OR TRIM(canonical_name) = '';

-- Check duplicate company names
SELECT
    canonical_name,
    COUNT(*) AS name_count
FROM cpse_master
GROUP BY canonical_name
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS total_companies,
    COUNT(ministry) AS companies_with_ministry,
    COUNT(department) AS companies_with_department
FROM cpse_master;

SELECT COUNT(*) AS missing_ministry
FROM cpse_master
WHERE ministry IS NULL OR ministry = '';

SELECT COUNT(*) AS missing_department
FROM cpse_master
WHERE department IS NULL OR department = '';

SELECT 
	cpse_id,
    COUNT(*) AS duplicates_count
FROM cpse_master
GROUP BY cpse_id
HAVING COUNT(*) >1;

-- 2. PROFIT AND LOSS VALIDATION

-- Check missing CPSE IDs
SELECT COUNT(*)
FROM fact_profit_loss
WHERE cpse_id IS NULL;

-- Check duplicate CPSE IDs
SELECT 
	cpse_id,
    COUNT(*) AS duplicates_count
FROM fact_profit_loss
GROUP BY cpse_id
HAVING COUNT(*) >1;

-- Check missing profit/loss values for all three years
SELECT COUNT(*)
FROM fact_profit_loss
WHERE profit_loss_fy2024_25_lakh IS NULL;

SELECT COUNT(*)
FROM fact_profit_loss
WHERE profit_loss_fy2023_24_lakh IS NULL;

SELECT COUNT(*)
FROM fact_profit_loss
WHERE profit_loss_fy2022_23_lakh IS NULL;

-- Check profit/loss data status for FY 2024-25
SELECT
    fy2024_25_data_status,
    COUNT(*) AS total_records
FROM fact_profit_loss
GROUP BY fy2024_25_data_status;

-- FY 2024-25
-- Check companies reporting losses
SELECT COUNT(*)
FROM fact_profit_loss
WHERE profit_loss_fy2024_25_lakh <0;

-- Check companies reporting profits
SELECT COUNT(*)
FROM fact_profit_loss
WHERE profit_loss_fy2024_25_lakh >0;

-- Check companies reporting zero
SELECT COUNT(*)
FROM fact_profit_loss
WHERE profit_loss_fy2024_25_lakh =0;

-- Check genuine reported zeros
SELECT COUNT(*)
FROM fact_profit_loss
WHERE profit_loss_fy2024_25_lakh = 0
AND fy2024_25_data_status = 'Reported';

-- FY 2023-24
-- Check losses
SELECT COUNT(*)
FROM fact_profit_loss
WHERE profit_loss_fy2023_24_lakh <0;

-- Check profits
SELECT COUNT(*)
FROM fact_profit_loss
WHERE profit_loss_fy2023_24_lakh >0;

-- Check companies reporting zeros
SELECT COUNT(*)
FROM fact_profit_loss
WHERE profit_loss_fy2023_24_lakh =0;

-- FY 2022-23
-- Check losses
SELECT COUNT(*)
FROM fact_profit_loss
WHERE profit_loss_fy2022_23_lakh <0;

-- Check profits
SELECT COUNT(*)
FROM fact_profit_loss
WHERE profit_loss_fy2022_23_lakh >0;

-- Check companies reporting zeros
SELECT COUNT(*)
FROM fact_profit_loss
WHERE profit_loss_fy2022_23_lakh =0;

-- 3. Turnover validation

-- Check missing CPSE IDs
SELECT COUNT(*)
FROM fact_turnover
WHERE cpse_id IS NULL;

-- Check duplicate CPSE IDs
SELECT 
	cpse_id,
    COUNT(*) AS duplicates_count
FROM fact_turnover
GROUP BY cpse_id
HAVING COUNT(*) >1;

-- Check missing turnover values in all three years
-- FY 2024-25
SELECT COUNT(*)
FROM fact_turnover
WHERE turnover_fy2024_25_lakh IS NULL;

-- FY 2023-24
SELECT COUNT(*)
FROM fact_turnover
WHERE turnover_fy2023_24_lakh IS NULL;

-- FY 2022-23
SELECT COUNT(*)
FROM fact_turnover
WHERE turnover_fy2022_23_lakh IS NULL;

-- Check turnover ranking
SELECT MAX(rank_fy2024_25) AS max_rank
FROM fact_turnover;

-- Check turnover ranking
SELECT MIN(rank_fy2024_25) AS min_rank
FROM fact_turnover;

-- Check duplicate turnover ranks
SELECT
	rank_fy2024_25,
	COUNT(*)
FROM fact_turnover
GROUP BY rank_fy2024_25
HAVING COUNT(*) >1;

-- FY 2024-25
-- Check highest turnover
SELECT
	company_name_source,
	turnover_fy2024_25_lakh
FROM fact_turnover
ORDER BY turnover_fy2024_25_lakh DESC
LIMIT 1;

-- Check lowest turnover
SELECT
	company_name_source,
	turnover_fy2024_25_lakh
FROM fact_turnover
ORDER BY turnover_fy2024_25_lakh
LIMIT 1;

-- Check total turnover across three years
SELECT
	SUM(turnover_fy2024_25_lakh) AS total_turnover_fy_2024_25,
	SUM(turnover_fy2023_24_lakh) AS total_turnover_fy_2023_24,
	SUM(turnover_fy2022_23_lakh) AS total_turnover_fy_2022_23
FROM fact_turnover;

-- Check average turnover across three years
SELECT 
	AVG(turnover_fy2024_25_lakh) AS avg_turnover_fy_2024_25,
	AVG(turnover_fy2023_24_lakh) AS avg_turnover_fy_2023_24,
	AVG(turnover_fy2022_23_lakh) AS avg_turnover_fy_2022_23
FROM fact_turnover;

-- Check negative turnover values
-- FY 2024-25
SELECT COUNT(*)
FROM fact_turnover
WHERE turnover_fy2024_25_lakh <0;

-- FY 2023-24
SELECT COUNT(*)
FROM fact_turnover
WHERE turnover_fy2023_24_lakh <0;

-- FY 2022-23
SELECT COUNT(*)
FROM fact_turnover
WHERE turnover_fy2022_23_lakh <0;

-- 4. Short-term borrowings validation

-- Check missing CPSE IDs
SELECT COUNT(*)
FROM fact_st_borrowings
WHERE cpse_id IS NULL;

-- Check duplicate CPSE IDs
SELECT
	cpse_id,
	COUNT(*)
FROM fact_st_borrowings
GROUP BY cpse_id
HAVING COUNT(*)>1;

-- Check missing total borrowings values
SELECT COUNT(*)
FROM fact_st_borrowings
WHERE total_borrowings_lakh IS NULL;

-- Check missing central government borrowings
SELECT COUNT(*)
FROM fact_st_borrowings
WHERE central_govt_lakh IS NULL;

-- Check missing state government borrowings
SELECT COUNT(*)
FROM fact_st_borrowings
WHERE state_govt_lakh IS NULL;

-- Check missing holding company borrowings
SELECT COUNT(*)
FROM fact_st_borrowings
WHERE holding_company_lakh IS NULL;

-- Check missing bank borrowings
SELECT COUNT(*)
FROM fact_st_borrowings
WHERE banks_lakh IS NULL;

-- Check missing foreign party borrowings
SELECT COUNT(*)
FROM fact_st_borrowings
WHERE foreign_parties_lakh IS NULL;

-- Check missing other borrowings
SELECT COUNT(*)
FROM fact_st_borrowings
WHERE others_lakh IS NULL;

-- Check borrowing component totals
SELECT
	cpse_id,
	total_borrowings_lakh,
	(central_govt_lakh+state_govt_lakh+holding_company_lakh+banks_lakh+foreign_parties_lakh+others_lakh) AS total_of_borrowings
FROM fact_st_borrowings;

SELECT
	cpse_id,
	total_borrowings_lakh,
	(central_govt_lakh+state_govt_lakh+holding_company_lakh+banks_lakh+foreign_parties_lakh+others_lakh) AS total_of_borrowings
FROM fact_st_borrowings
HAVING total_of_borrowings <> total_borrowings_lakh;

-- Check borrowing reporting dates
SELECT COUNT(*)
FROM fact_st_borrowings
WHERE reporting_date IS NULL;

-- Check for incorrect reporting dates
SELECT COUNT(*)
FROM fact_st_borrowings
WHERE reporting_date <> '2025-03-31';

-- Check for negative borrowing values
SELECT COUNT(*)
FROM fact_st_borrowings
WHERE total_borrowings_lakh <0;

SELECT COUNT(*)
FROM fact_st_borrowings
WHERE central_govt_lakh <0
OR state_govt_lakh <0 
OR holding_company_lakh <0 
OR banks_lakh <0 
OR foreign_parties_lakh <0 
OR others_lakh <0;

-- 5. Long-term borrowings validation

-- Check missing CPSE IDs
SELECT COUNT(*)
FROM fact_lt_borrowings
WHERE cpse_id IS NULL;

-- Check duplicate CPSE IDs
SELECT
	cpse_id,
	COUNT(*)
FROM fact_lt_borrowings
GROUP BY cpse_id
HAVING COUNT(*)>1;

-- Check missing total borrowings values
SELECT COUNT(*)
FROM fact_lt_borrowings
WHERE total_borrowings_lakh IS NULL;

DESCRIBE fact_lt_borrowings;

-- Check missing borrowing components
SELECT COUNT(*)
FROM fact_lt_borrowings
WHERE central_govt_lakh IS NULL
OR state_govt_lakh IS NULL
OR holding_company_lakh IS NULL
OR banks_lakh IS NULL
OR foreign_parties_lakh IS NULL
OR others_lakh IS NULL;

-- Check borrowing component totals
SELECT
	cpse_id,
	total_borrowings_lakh,
	(central_govt_lakh+state_govt_lakh+holding_company_lakh+banks_lakh+foreign_parties_lakh+others_lakh) AS total_of_borrowings
FROM fact_lt_borrowings;

SELECT
	cpse_id,
	total_borrowings_lakh,
	(central_govt_lakh+state_govt_lakh+holding_company_lakh+banks_lakh+foreign_parties_lakh+others_lakh) AS total_of_borrowings
FROM fact_lt_borrowings
HAVING total_of_borrowings <> total_borrowings_lakh;

-- Check borrowing reporting dates
SELECT COUNT(*)
FROM fact_lt_borrowings
WHERE reporting_date IS NULL;

-- Check for incorrect reporting dates
SELECT COUNT(*)
FROM fact_lt_borrowings
WHERE reporting_date <> '2025-03-31';

-- Check for negative borrowing values
SELECT COUNT(*)
FROM fact_lt_borrowings
WHERE total_borrowings_lakh <0;

SELECT COUNT(*)
FROM fact_lt_borrowings
WHERE central_govt_lakh <0
OR state_govt_lakh <0 
OR holding_company_lakh <0 
OR banks_lakh <0 
OR foreign_parties_lakh <0 
OR others_lakh <0;

SELECT
    cpse_id,
    company_name_source,
    central_govt_lakh,
    state_govt_lakh,
    holding_company_lakh,
    banks_lakh,
    foreign_parties_lakh,
    others_lakh,
    total_borrowings_lakh
FROM fact_lt_borrowings
WHERE central_govt_lakh < 0
OR state_govt_lakh < 0
OR holding_company_lakh < 0
OR banks_lakh < 0
OR foreign_parties_lakh < 0
OR others_lakh < 0;
-- Note: One negative component (-370 lakh) was found for
-- Broadcast Engineering Consultants India Ltd.
-- Verified against original Statement 10; retained as reported.
-- Total borrowings reconcile correctly to 87 lakh.

-- 6. Employee benefits validation

-- Check missing cognate-group names
SELECT COUNT(*)
FROM fact_employee_benefits
WHERE cognate_group IS NULL;

-- Check duplicate cognate-group names
SELECT
	cognate_group,
	COUNT(*)
FROM fact_employee_benefits
GROUP BY cognate_group
HAVING COUNT(*) >1;

DESCRIBE fact_employee_benefits;

-- Check missing employee benefit expenses
SELECT COUNT(*)
FROM fact_employee_benefits
WHERE employee_benefit_expense_fy2024_25_lakh IS NULL;

-- Check negative employee benefit expenses
SELECT COUNT(*)
FROM fact_employee_benefits
WHERE employee_benefit_expense_fy2024_25_lakh < 0;

-- Check financial year
SELECT financial_year, COUNT(*) AS total_records
FROM fact_employee_benefits
GROUP BY financial_year;

-- Total employee benefit expense
SELECT SUM(employee_benefit_expense_fy2024_25_lakh) AS total_employee_benefits_lakh
FROM fact_employee_benefits;

-- 7. Final cross-table validation

SELECT pl.cpse_id
FROM fact_profit_loss pl
LEFT JOIN cpse_master c
	ON pl.cpse_id=c.cpse_id
WHERE c.cpse_id IS NULL

UNION ALL 

SELECT t.cpse_id
FROM fact_turnover t
LEFT JOIN cpse_master c
	ON t.cpse_id=c.cpse_id
WHERE c.cpse_id IS NULL

UNION ALL

SELECT st.cpse_id
FROM fact_st_borrowings st 
LEFT JOIN cpse_master c
	ON st.cpse_id=c.cpse_id
WHERE c.cpse_id IS NULL

UNION ALL

SELECT lt.cpse_id
FROM fact_lt_borrowings lt
LEFT JOIN cpse_master c
	ON lt.cpse_id=c.cpse_id
WHERE c.cpse_id IS NULL;