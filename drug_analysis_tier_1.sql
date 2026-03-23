-- USE Drug Analysis DATABASE
USE Drug_Analysis;
GO

-- Total Reports
SELECT 
	COUNT(*) AS total_record_count 
FROM gold.fact_drug_details

-- Total Critical Cases
SELECT 
	SUM(critical_count) AS critical_cases 
FROM gold.fact_drug_details

-- % of Critical Cases
SELECT 
	COUNT(*) AS total_records,
	SUM(critical_count) AS critical_cases ,
	CONCAT(CAST(SUM(critical_count) * 100 / COUNT(*) AS DECIMAL(18,2)),'%') AS critical_rate
FROM gold.fact_drug_details

-- Reports by Gender

SELECT
	gender,
	count(*) report_by_gender
FROM gold.fact_drug_details
GROUP BY gender

-- Critical Cases by Gender
SELECT
	gender,
	SUM(critical_count) AS critical_by_gender
FROM gold.fact_drug_details
GROUP BY gender

-- Reports by Age segment

SELECT 
	age_segments,
	COUNT(*) AS segment_count
FROM gold.fact_drug_details
GROUP BY age_segments

-- Critical Cases by Age Segment
SELECT
	age_segments,
	SUM(critical_count) AS critical_cases_count
FROM gold.fact_drug_details
GROUP BY age_segments

-- Top 10 Drugs by Usage
SELECT TOP(10)
	drug_name,
	COUNT(*) AS count
FROM gold.fact_drug_details
GROUP BY drug_name
ORDER BY COUNT(*) DESC

-- Top 10 Drugs Causing Critical Cases
SELECT TOP(10)
	drug_name,
	SUM(critical_count) AS critical_cases_count
FROM gold.fact_drug_details
GROUP BY drug_name
ORDER BY SUM(critical_count) DESC

 -- ===== using window function =====
 SELECT * FROM (
 SELECT 
	drug_name,
	SUM(critical_count) AS critical_cases_count,
	RANK() OVER (ORDER BY SUM(critical_count) DESC) AS critical_cases_rank
 FROM gold.fact_drug_details
 GROUP BY drug_name
 )t
 WHERE critical_cases_rank <= 10

 -- youngest patient with critical case
 SELECT 
	MIN(patient_age) AS youngest_critical_case
 	from gold.fact_drug_details
 WHERE critical_count = 1

-- Oldest patient with critical case
 SELECT 
	MAX(patient_age) AS oldest_critical_case
 	from gold.fact_drug_details
 WHERE critical_count = 1

 -- concomitant drug frequency
 SELECT TOP(10)
	concomitant_drugs,
	COUNT(*) AS frequency
FROM gold.dim_concomitant_drugs
WHERE concomitant_drugs IS NOT NULL
GROUP BY concomitant_drugs
ORDER BY COUNT(*) DESC

-- which segment has the most concomitant drugs
SELECT TOP(1)
	fact.age_segments,
	COUNT(dim.concomitant_drugs) AS concomitant_drugs_count
FROM gold.fact_drug_details AS fact
LEFT JOIN gold.dim_concomitant_drugs AS dim
ON fact.report_id = dim.report_id
WHERE dim.concomitant_drugs IS NOT NULL
GROUP BY fact.age_segments
ORDER BY COUNT(dim.concomitant_drugs) DESC

   -- == using window function to find the segment with most concomitant drugs == 
SELECT * FROM (
SELECT
	fact.age_segments,
	COUNT(dim.concomitant_drugs) AS concomitant_drugs_count,
	RANK() OVER (ORDER BY COUNT(dim.concomitant_drugs) DESC) AS concomitant_drugs_rank
FROM gold.fact_drug_details AS fact
LEFT JOIN gold.dim_concomitant_drugs AS dim
ON fact.report_id = dim.report_id
WHERE dim.concomitant_drugs IS NOT NULL
GROUP BY fact.age_segments
) t
WHERE concomitant_drugs_rank = 1