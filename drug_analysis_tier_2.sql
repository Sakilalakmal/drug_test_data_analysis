-- USE Drug Analysis DATABASE
USE Drug_Analysis;
GO

-- Which drugs have the highest critical rate
SELECT 
	drug_name,
	CONCAT(CAST(SUM(critical_count) * 100 / COUNT(*) AS DECIMAL(18,2)),'%') AS critical_rate
FROM gold.fact_drug_details
GROUP BY drug_name
ORDER BY critical_rate DESC

-- Do age groups influence critical outcomes per drug?
SELECT * FROM (
	SELECT
		drug_name,
		age_segments,
		SUM(critical_count) AS critical_count,
		RANK() OVER(PARTITION BY age_segments ORDER BY SUM(critical_count) DESC) AS rank_per_segment
	FROM gold.fact_drug_details
	GROUP BY drug_name , age_segments
	) t
	WHERE rank_per_segment = 1
ORDER BY critical_count DESC

-- Are concomitant drugs increasing risk

WITH concomitant_reports AS (
    SELECT DISTINCT report_id
    FROM gold.dim_concomitant_drugs
)
SELECT
    COUNT(*) AS total_reports,
    SUM(f.critical_count) AS total_critical_cases,
    CAST(SUM(f.critical_count) * 100.0 / COUNT(*) AS DECIMAL(18,2)) AS overall_critical_rate,

    SUM(CASE WHEN c.report_id IS NOT NULL THEN 1 ELSE 0 END) AS reports_with_concomitant,
    SUM(CASE WHEN c.report_id IS NOT NULL THEN f.critical_count ELSE 0 END) AS critical_cases_with_concomitant,
    CAST(
        SUM(CASE WHEN c.report_id IS NOT NULL THEN f.critical_count ELSE 0 END) * 100.0
        / NULLIF(SUM(CASE WHEN c.report_id IS NOT NULL THEN 1 ELSE 0 END), 0)
        AS DECIMAL(18,2)
    ) AS critical_rate_with_concomitant
FROM gold.fact_drug_details AS f
LEFT JOIN concomitant_reports AS c
    ON f.report_id = c.report_id;