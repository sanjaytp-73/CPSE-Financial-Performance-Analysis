-- 1. Top 10 most profitable CPSEs in FY 2024-25

SELECT
	company_name_source AS company_name,
	profit_loss_fy2024_25_lakh AS profit
FROM fact_profit_loss
WHERE profit_loss_fy2024_25_lakh >0
ORDER BY profit_loss_fy2024_25_lakh DESC
LIMIT 10;

-- 2. Top 10 loss-making CPSEs in FY 2024-25

SELECT
	company_name_source AS company_name,
	profit_loss_fy2024_25_lakh AS loss
FROM fact_profit_loss
WHERE profit_loss_fy2024_25_lakh <0
ORDER BY profit_loss_fy2024_25_lakh
LIMIT 10;

-- 3. Total profit and total loss in FY 2024-25

SELECT
    'Total Profit' AS metric,
    SUM(profit_loss_fy2024_25_lakh) AS amount_lakh
FROM fact_profit_loss
WHERE profit_loss_fy2024_25_lakh > 0

UNION ALL

SELECT
    'Total Loss' AS metric,
    SUM(profit_loss_fy2024_25_lakh) AS amount_lakh
FROM fact_profit_loss
WHERE profit_loss_fy2024_25_lakh < 0;

-- 4. Total profit across three financial years

SELECT 
	'FY 2024-25' AS financial_year,
	SUM(profit_loss_fy2024_25_lakh) AS total_profit
FROM fact_profit_loss
WHERE profit_loss_fy2024_25_lakh >0

UNION ALL

SELECT 
	'FY 2023-24' AS financial_year,
	SUM(profit_loss_fy2023_24_lakh) AS total_profit
FROM fact_profit_loss
WHERE profit_loss_fy2023_24_lakh >0

UNION ALL

SELECT 
	'FY 2022-23' AS financial_year,
	SUM(profit_loss_fy2022_23_lakh) AS total_profit
FROM fact_profit_loss
WHERE profit_loss_fy2022_23_lakh >0;

-- 5. Total loss across three financial years

SELECT 
	'FY 2024-25' AS financial_year,
	SUM(profit_loss_fy2024_25_lakh) AS total_loss
FROM fact_profit_loss
WHERE profit_loss_fy2024_25_lakh <0

UNION ALL

SELECT 
	'FY 2023-24' AS financial_year,
	SUM(profit_loss_fy2023_24_lakh) AS total_loss
FROM fact_profit_loss
WHERE profit_loss_fy2023_24_lakh <0

UNION ALL

SELECT 
	'FY 2022-23' AS financial_year,
	SUM(profit_loss_fy2022_23_lakh) AS total_loss
FROM fact_profit_loss
WHERE profit_loss_fy2022_23_lakh <0;

-- 6. Net profit or loss across three financial years

SELECT
	'FY 2024-25' AS financial_year,
    SUM(CASE WHEN profit_loss_fy2024_25_lakh > 0 THEN profit_loss_fy2024_25_lakh ELSE 0 END) AS total_profit,
    SUM(CASE WHEN profit_loss_fy2024_25_lakh < 0 THEN profit_loss_fy2024_25_lakh ELSE 0 END) AS total_loss,
    SUM(profit_loss_fy2024_25_lakh) AS net_profit_loss
FROM fact_profit_loss

UNION ALL

SELECT
	'FY 2023-24' AS financial_year,
    SUM(CASE WHEN profit_loss_fy2023_24_lakh > 0 THEN profit_loss_fy2023_24_lakh ELSE 0 END) AS total_profit,
    SUM(CASE WHEN profit_loss_fy2023_24_lakh < 0 THEN profit_loss_fy2023_24_lakh ELSE 0 END) AS total_loss,
    SUM(profit_loss_fy2023_24_lakh) AS net_profit_loss
FROM fact_profit_loss

UNION ALL

SELECT
	'FY 2022-23' AS financial_year,
    SUM(CASE WHEN profit_loss_fy2022_23_lakh > 0 THEN profit_loss_fy2022_23_lakh ELSE 0 END) AS total_profit,
    SUM(CASE WHEN profit_loss_fy2022_23_lakh < 0 THEN profit_loss_fy2022_23_lakh ELSE 0 END) AS total_loss,
    SUM(profit_loss_fy2022_23_lakh) AS net_profit_loss
FROM fact_profit_loss;

-- 7. Year-wise Financial Summary

WITH yearly_summary AS (

    SELECT
        'FY 2022-23' AS financial_year,
        1 AS year_order,
        SUM(CASE WHEN profit_loss_fy2022_23_lakh > 0 THEN profit_loss_fy2022_23_lakh ELSE 0 END) AS total_profit,
        SUM(CASE WHEN profit_loss_fy2022_23_lakh < 0 THEN profit_loss_fy2022_23_lakh ELSE 0 END) AS total_loss,
        SUM(profit_loss_fy2022_23_lakh) AS net_profit_loss
    FROM fact_profit_loss

    UNION ALL

    SELECT
        'FY 2023-24',
        2,
        SUM(CASE WHEN profit_loss_fy2023_24_lakh > 0 THEN profit_loss_fy2023_24_lakh ELSE 0 END),
        SUM(CASE WHEN profit_loss_fy2023_24_lakh < 0 THEN profit_loss_fy2023_24_lakh ELSE 0 END),
        SUM(profit_loss_fy2023_24_lakh)
    FROM fact_profit_loss

    UNION ALL

    SELECT
        'FY 2024-25',
        3,
        SUM(CASE WHEN profit_loss_fy2024_25_lakh > 0 THEN profit_loss_fy2024_25_lakh ELSE 0 END),
        SUM(CASE WHEN profit_loss_fy2024_25_lakh < 0  THEN profit_loss_fy2024_25_lakh ELSE 0 END),
        SUM(profit_loss_fy2024_25_lakh)
    FROM fact_profit_loss
),
yearly_comparison AS (
    SELECT
        financial_year,
        year_order,
        total_profit,
        total_loss,
        net_profit_loss,
        LAG(net_profit_loss) OVER (
            ORDER BY year_order
        ) AS previous_year_net_profit
    FROM yearly_summary
)
SELECT
    financial_year,
    total_profit,
    total_loss,
    net_profit_loss,
    previous_year_net_profit,
    net_profit_loss - previous_year_net_profit AS yoy_change
FROM yearly_comparison
ORDER BY year_order;

-- 8.Top 10 CPSEs by Turnover in FY 2024-25

SELECT 
	t.cpse_id,
	c.canonical_name AS company_name,
	t.turnover_fy2024_25_lakh
FROM fact_turnover t
LEFT JOIN cpse_master c
	ON t.cpse_id=c.cpse_id
ORDER BY turnover_fy2024_25_lakh DESC
LIMIT 10;

-- 9.Profit/Loss of the Top 10 CPSEs by Turnover in FY 2024-25

SELECT 
	t.cpse_id,
	c.canonical_name AS company_name,
	t.turnover_fy2024_25_lakh,
	pl.profit_loss_fy2024_25_lakh
FROM fact_turnover t
LEFT JOIN cpse_master c
	ON t.cpse_id=c.cpse_id
LEFT JOIN fact_profit_loss pl
	ON t.cpse_id=pl.cpse_id
ORDER BY t.turnover_fy2024_25_lakh DESC
LIMIT 10;

-- 10. Total CPSE Turnover Across Three Financial Years

SELECT
    SUM(turnover_fy2022_23_lakh) AS total_turnover_fy_2022_23,
    SUM(turnover_fy2023_24_lakh) AS total_turnover_fy_2023_24,
    SUM(turnover_fy2024_25_lakh) AS total_turnover_fy_2024_25
FROM fact_turnover;

-- 11. Available Turnover Records Across Three Financial Years

SELECT
	COUNT(turnover_fy2022_23_lakh) AS fy_2022_23_records,
	COUNT(turnover_fy2023_24_lakh) AS fy_2023_24_records,
	COUNT(turnover_fy2024_25_lakh) AS fy_2024_25_records
FROM fact_turnover; 

-- 12. Year-on-Year Turnover Change

WITH turnover AS(
	SELECT
		SUM(turnover_fy2022_23_lakh) AS turnover_fy2022_23,
		SUM(turnover_fy2023_24_lakh) AS turnover_fy2023_24,
		SUM(turnover_fy2024_25_lakh) AS turnover_fy2024_25
	FROM fact_turnover
),
turnover_change AS(
	SELECT 
		*,
		(turnover_fy2023_24-turnover_fy2022_23) AS change_2023_24,
		(turnover_fy2024_25-turnover_fy2023_24) AS change_2024_25
	FROM turnover
)
SELECT
	*,
	ROUND(change_2023_24/turnover_fy2022_23*100,2) AS change_pct_2023_24,
	ROUND(change_2024_25/turnover_fy2023_24*100,2) AS change_pct_2024_25
FROM turnover_change;

DESCRIBE fact_st_borrowings;

-- 14. Total Short-Term Borrowings

SELECT SUM(total_borrowings_lakh) AS total_st_borrowings
FROM fact_st_borrowings;

-- 15. Top 10 CPSEs by Short-Term Borrowings

SELECT
	c.cpse_id,
    c.canonical_name AS company_name,
    st.total_borrowings_lakh
FROM fact_st_borrowings st
LEFT JOIN cpse_master c
	ON st.cpse_id=c.cpse_id
ORDER BY st.total_borrowings_lakh DESC
LIMIT 10;

-- 16. Total Long-Term Borrowings

SELECT SUM(total_borrowings_lakh) AS total_lt_borrowings
FROM fact_lt_borrowings;

-- 17. Top 10 CPSEs by Long-Term Borrowings

SELECT
	c.cpse_id,
    c.canonical_name AS company_name,
    lt.total_borrowings_lakh
FROM fact_lt_borrowings lt
LEFT JOIN cpse_master c
	ON lt.cpse_id=c.cpse_id
ORDER BY lt.total_borrowings_lakh DESC
LIMIT 10;

-- 18. Combined Borrowings

WITH st_borrowings AS(
	SELECT
		SUM(total_borrowings_lakh) AS total_st_borrowings
	FROM fact_st_borrowings
),
lt_borrowings AS(
	SELECT
		SUM(total_borrowings_lakh) AS total_lt_borrowings
	FROM fact_lt_borrowings
)
SELECT 
	(st.total_st_borrowings+lt.total_lt_borrowings) AS total_combined_borrowings
FROM st_borrowings st
CROSS JOIN lt_borrowings lt;

-- 19. Top 10 CPSEs by Combined Borrowings

-- 19. Top 10 CPSEs by Combined Borrowings

SELECT
    c.cpse_id,
    c.canonical_name AS company_name,
    st.total_borrowings_lakh AS short_term,
    lt.total_borrowings_lakh AS long_term,
    st.total_borrowings_lakh + lt.total_borrowings_lakh
        AS combined_borrowings
FROM fact_st_borrowings st
INNER JOIN fact_lt_borrowings lt
    ON st.cpse_id = lt.cpse_id
INNER JOIN cpse_master c
    ON st.cpse_id = c.cpse_id
ORDER BY combined_borrowings DESC
LIMIT 10;

-- Note:
-- This analysis includes only CPSEs with records in both
-- short-term and long-term borrowing datasets.
--
-- INNER JOIN excludes companies missing either record.
-- Missing borrowing values are not assumed to be zero.
-- Therefore, this ranking covers only companies with
-- both reported borrowing balances.


-- 20. Employee Benefit Expenses by Cognate Group

SELECT
    cognate_group,
    SUM(employee_benefit_expense_fy2024_25_lakh)
        AS total_employee_benefits
FROM fact_employee_benefits
GROUP BY cognate_group
ORDER BY total_employee_benefits DESC;