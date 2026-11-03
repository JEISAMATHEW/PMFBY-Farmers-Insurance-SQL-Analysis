-- =====================================================================
--  PMFBY Farmers Insurance Analysis - Schema & Data Load
--  Dataset : NDAP (National Data & Analytics Platform, NITI Aayog)
--            "Pradhan Mantri Fasal Bima Yojana (PMFBY)" district-level data
--  Source  : https://ndap.niti.gov.in/
-- =====================================================================

DROP DATABASE IF EXISTS ndap;
CREATE DATABASE ndap;
USE ndap;

CREATE TABLE FarmersInsuranceData (
    rowID INT PRIMARY KEY,
    srcYear INT,
    srcStateName VARCHAR(255),
    srcDistrictName VARCHAR(255),
    InsuranceUnits INT,
    TotalFarmersCovered INT,
    ApplicationsLoaneeFarmers INT,
    ApplicationsNonLoaneeFarmers INT,
    InsuredLandArea FLOAT,
    FarmersPremiumAmount FLOAT,
    StatePremiumAmount FLOAT,
    GOVPremiumAmount FLOAT,
    GrossPremiumAmountToBePaid FLOAT,
    SumInsured FLOAT,
    PercentageMaleFarmersCovered FLOAT,
    PercentageFemaleFarmersCovered FLOAT,
    PercentageOthersCovered FLOAT,
    PercentageSCFarmersCovered FLOAT,
    PercentageSTFarmersCovered FLOAT,
    PercentageOBCFarmersCovered FLOAT,
    PercentageGeneralFarmersCovered FLOAT,
    PercentageMarginalFarmers FLOAT,
    PercentageSmallFarmers FLOAT,
    PercentageOtherFarmers FLOAT,
    YearCode INT,
    Year_ VARCHAR(255),
    Country VARCHAR(255),
    StateCode INT,
    DistrictCode INT,
    TotalPopulation INT,
    TotalPopulationUrban INT,
    TotalPopulationRural INT,
    TotalPopulationMale INT,
    TotalPopulationMaleUrban INT,
    TotalPopulationMaleRural INT,
    TotalPopulationFemale INT,
    TotalPopulationFemaleUrban INT,
    TotalPopulationFemaleRural INT,
    NumberOfHouseholds INT,
    NumberOfHouseholdsUrban INT,
    NumberOfHouseholdsRural INT,
    LandAreaUrban FLOAT,
    LandAreaRural FLOAT,
    LandArea FLOAT
);

-- ---------------------------------------------------------------------
-- Load the CSV.
-- 1. local_infile must be enabled on both server and client (Workbench: Edit Connection > Advanced > Others > OPT_LOCAL_INFILE=1).
-- 2. Change the path below to wherever data.csv is on your machine.
-- Non-numeric values (blank, NA, NaN) in the percentage and land area columns are stored as NULL rather than 0, so averages are not distorted.
-- ---------------------------------------------------------------------
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'D:/Projects/PMFBY-Farmers-Insurance-SQL-Analysis/data.csv'
INTO TABLE FarmersInsuranceData
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(rowID, srcYear, srcStateName, srcDistrictName, InsuranceUnits, TotalFarmersCovered,
 ApplicationsLoaneeFarmers, ApplicationsNonLoaneeFarmers, InsuredLandArea,
 FarmersPremiumAmount, StatePremiumAmount, GOVPremiumAmount,
 GrossPremiumAmountToBePaid, SumInsured,
 @p_male, @p_female, @p_others, @p_sc, @p_st, @p_obc, @p_general,
 @p_marginal, @p_small, @p_other,
 YearCode, Year_, Country, StateCode, DistrictCode,
 TotalPopulation, TotalPopulationUrban, TotalPopulationRural,
 TotalPopulationMale, TotalPopulationMaleUrban, TotalPopulationMaleRural,
 TotalPopulationFemale, TotalPopulationFemaleUrban, TotalPopulationFemaleRural,
 NumberOfHouseholds, NumberOfHouseholdsUrban, NumberOfHouseholdsRural,
 @l_urban, @l_rural, @l_area)
SET
 PercentageMaleFarmersCovered    = IF(TRIM(@p_male)     REGEXP '^-?[0-9]+([.][0-9]+)?$', @p_male, NULL),
 PercentageFemaleFarmersCovered  = IF(TRIM(@p_female)   REGEXP '^-?[0-9]+([.][0-9]+)?$', @p_female, NULL),
 PercentageOthersCovered         = IF(TRIM(@p_others)   REGEXP '^-?[0-9]+([.][0-9]+)?$', @p_others, NULL),
 PercentageSCFarmersCovered      = IF(TRIM(@p_sc)       REGEXP '^-?[0-9]+([.][0-9]+)?$', @p_sc, NULL),
 PercentageSTFarmersCovered      = IF(TRIM(@p_st)       REGEXP '^-?[0-9]+([.][0-9]+)?$', @p_st, NULL),
 PercentageOBCFarmersCovered     = IF(TRIM(@p_obc)      REGEXP '^-?[0-9]+([.][0-9]+)?$', @p_obc, NULL),
 PercentageGeneralFarmersCovered = IF(TRIM(@p_general)  REGEXP '^-?[0-9]+([.][0-9]+)?$', @p_general, NULL),
 PercentageMarginalFarmers       = IF(TRIM(@p_marginal) REGEXP '^-?[0-9]+([.][0-9]+)?$', @p_marginal, NULL),
 PercentageSmallFarmers          = IF(TRIM(@p_small)    REGEXP '^-?[0-9]+([.][0-9]+)?$', @p_small, NULL),
 PercentageOtherFarmers          = IF(TRIM(@p_other)    REGEXP '^-?[0-9]+([.][0-9]+)?$', @p_other, NULL),
 LandAreaUrban                   = IF(TRIM(@l_urban)    REGEXP '^-?[0-9]+([.][0-9]+)?$', @l_urban, NULL),
 LandAreaRural                   = IF(TRIM(@l_rural)    REGEXP '^-?[0-9]+([.][0-9]+)?$', @l_rural, NULL),
 LandArea                        = IF(TRIM(@l_area)     REGEXP '^-?[0-9]+([.][0-9]+)?$', @l_area, NULL);

-- Sanity check: should return 1870
SELECT COUNT(*) AS total_rows FROM FarmersInsuranceData;