-- USE Drug Analysis DATABASE
USE Drug_Analysis;
GO

CREATE SCHEMA gold ;
-- check old and young age in data set
select MIN(patientAge) from silver.main_drugs_details
select MAX(patientAge) from silver.main_drugs_details

-- patient segments
SELECT
	*,
	CASE WHEN PatientAge BETWEEN 10 AND 17 THEN 'Kids' 
		 WHEN PatientAge BETWEEN 18 AND 29 THEN 'Young'
	     WHEN PatientAge BETWEEN 30 AND 55 THEN 'Middle'
		 WHEN PatientAge BETWEEN 56 AND 100 THEN 'Elder'
	END AS age_segments
FROM silver.main_drugs_details

-- condition counts
SELECT * ,
CASE WHEN Seriousness IN ('severe','fatal') THEN 1 
     ELSE 0
END AS critical_count
FROM silver.main_drugs_details

-- LOAD  DATA INTO GOLD LAYER TABLE 
SELECT 
	*
FROM silver.main_drugs_details

CREATE OR ALTER VIEW gold.fact_drug_details
AS
	SELECT
		ReportID AS report_id,
		PatientAge AS patient_age,
		CASE WHEN PatientAge BETWEEN 10 AND 17 THEN 'Kids' 
			 WHEN PatientAge BETWEEN 18 AND 29 THEN 'Young'
			 WHEN PatientAge BETWEEN 30 AND 55 THEN 'Middle'
			 WHEN PatientAge BETWEEN 56 AND 100 THEN 'Elder'
		END AS age_segments,
			Gender AS gender,
			DrugName AS drug_name,
			Dosage AS dosage,
			DurationDays AS duration_days,
			ADR_Code AS ADR_code,
			Seriousness AS seriousness,
			OnsetDays AS on_set_days,
		CASE WHEN Seriousness IN ('severe','fatal') THEN 1 
		 ELSE 0
	END AS critical_count
	FROM silver.main_drugs_details

-- check view 
select 
	SUM(critical_count) 
from gold.fact_drug_details


-- second table

CREATE OR ALTER VIEW gold.dim_concomitant_drugs
AS
SELECT
	ReportID AS report_id,
	ConcomitantDrugs AS concomitant_drugs
FROM silver.concomitant_drugs

-- check view
SELECT * from gold.dim_concomitant_drugs