
-- USE Drug Analysis DATABASE
USE Drug_Analysis;
GO

-- CREATE A PROCEDURE FOR SILVER LAYER DATA LOAD 
-- USE EXEC silver.data_load

CREATE OR ALTER PROCEDURE silver.data_load 
AS BEGIN

-- Load data into silver tables silver.main_drugs_details
PRINT 'Cleaning and Loading silver.main_drugs_details Table (SILVER) --'
TRUNCATE TABLE silver.main_drugs_details;
PRINT 'Loading data into silver.main_drugs_details...'
INSERT INTO silver.main_drugs_details
    (
    ReportID			,
		PatientAge		,
		Gender			,
		DrugName		,
		Dosage			,
		DurationDays	,
		ADR_Code		,
		Seriousness		,
		OnsetDays		
    )
SELECT
	ReportID AS report_id,
	TRY_CAST(NULLIF(PatientAge,'') AS INT) AS patient_age,
	NULLIF(Gender,'') AS gender,
	NULLIF(DrugName,'') AS drug_name,
	NULLIF(Dosage,'') AS dosage,
	TRY_CAST(NULLIF(DurationDays,'') AS INT) AS duration_days,
	NULLIF(ADR_Code,'') AS ADR_code,
	NULLIF(Seriousness,'') AS seriousness ,
	TRY_CAST(NULLIF(OnsetDays,'') AS INT) AS on_set_dayss
FROM bronze.main_drugs_details

-- Load data into silver tables silver.concomitant_drugs
PRINT 'Cleaning and Loading silver.concomitant_drugs Table (SILVER) --'
TRUNCATE TABLE silver.concomitant_drugs;
PRINT 'Loading data into silver.concomitant_drugs...'
INSERT INTO silver.concomitant_drugs
	(
		ReportID			,
		ConcomitantDrugs	
	)
SELECT
	ReportID AS report_id,
	ConcomitantDrugs AS concomitant_drugs
FROM bronze.concomitant_drugs;

END;