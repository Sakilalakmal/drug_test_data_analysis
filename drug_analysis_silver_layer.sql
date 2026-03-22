-- USE DRUG DATABASE
USE Drug_Analysis

-- CREATE BRONZE LAYER 
CREATE SCHEMA silver ; 
GO

-- CREATE silver TABLES

-- CREATE MAIN DRUG DETAILS TABLE silver
IF OBJECT_ID('silver.main_drugs_details','U') IS NOT NULL
DROP TABLE silver.main_drugs_details;
GO

CREATE TABLE silver.main_drugs_details 
	(
		ReportID		NVARCHAR(50) PRIMARY KEY NOT NULL,
		PatientAge		INT,
		Gender			NVARCHAR(20),
		DrugName		NVARCHAR(50),
		Dosage			NVARCHAR(20),
		DurationDays	INT,
		ADR_Code		NVARCHAR(50),
		Seriousness		NVARCHAR(20),
		OnsetDays		INT

	)

-- CREATE CONCOMITANT DRUG DETAILS TABLE
IF OBJECT_ID('silver.concomitant_drugs','U') IS NOT NULL
DROP TABLE silver.concomitant_drugs;
GO 
CREATE TABLE silver.concomitant_drugs
	(
		ReportID			NVARCHAR(50) NOT NULL,
		ConcomitantDrugs	NVARCHAR(50)
	)

	select * from silver.main_drugs_details

