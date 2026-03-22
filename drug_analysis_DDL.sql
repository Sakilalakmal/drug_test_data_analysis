-- CREATE DATABASE FOR DRUG DATASET ANALYSIS
CREATE DATABASE Drug_Analysis

-- USE Drug Analysis DATABASE
USE Drug_Analysis;
GO
-- CREATE BRONZE LAYER 
CREATE SCHEMA bronze ; 

-- CREATE MAIN DRUG DETAILS TABLE
IF OBJECT_ID('bronze.main_drugs_details','U') IS NOT NULL
DROP TABLE bronze.main_drugs_details;
GO

CREATE TABLE bronze.main_drugs_details 
	(
		ReportID		NVARCHAR(50) PRIMARY KEY NOT NULL,
		PatientAge		NVARCHAR(5),
		Gender			NVARCHAR(20),
		DrugName		NVARCHAR(50),
		Dosage			NVARCHAR(20),
		DurationDays	NVARCHAR(10),
		ADR_Code		NVARCHAR(50),
		Seriousness		NVARCHAR(20),
		OnsetDays		NVARCHAR(10)

	)

-- CREATE CONCOMITANT DRUG DETAILS TABLE
IF OBJECT_ID('bronze.concomitant_drugs','U') IS NOT NULL
DROP TABLE bronze.concomitant_drugs;
GO 
CREATE TABLE bronze.concomitant_drugs
	(
		ReportID			NVARCHAR(50) NOT NULL,
		ConcomitantDrugs	NVARCHAR(50)
	)

-- INSERT DATA USING BULK INSERT 
PRINT '>> Truncating Table: bronze.main_drugs_details';
TRUNCATE TABLE bronze.main_drugs_details;

PRINT '>> Inserting Data Into: bronze.main_drugs_details';
BULK INSERT bronze.main_drugs_details
FROM 'D:\DE-DA\drug-dataset\main_drug.csv'
     WITH (
          FIRSTROW = 2,
          FIELDTERMINATOR = ',',
          TABLOCK
        );


-- INSERT DATA USING BULK INSERT 
PRINT '>> Truncating Table: bronze.concomitant_drugs';
TRUNCATE TABLE bronze.concomitant_drugs;

PRINT '>> Inserting Data Into: bronze.concomitant_drugs';
BULK INSERT bronze.concomitant_drugs
FROM 'D:\DE-DA\drug-dataset\concominent_drugs.csv'
     WITH (
          FIRSTROW = 2,
          FIELDTERMINATOR = ',',
          TABLOCK
        );

-- CHECK DATA INSIDE TABLES
SELECT * FROM bronze.main_drugs_details

SELECT * FROM  bronze.concomitant_drugs