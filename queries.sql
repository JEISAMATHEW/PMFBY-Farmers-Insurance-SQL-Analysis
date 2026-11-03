-- =====================================================================
--  PMFBY Farmers Insurance Analysis - Queries
-- =====================================================================

USE ndap;

-- SECTION 1.
-- SELECT Queries

-- Q1. Retrieve the names of all states (srcStateName) from the dataset.
SELECT DISTINCT srcStateName FROM FarmersInsuranceData;

-- Q2. Retrieve the total number of farmers covered (TotalFarmersCovered)
-- and the sum insured (SumInsured) for each state (srcStateName), ordered by TotalFarmersCovered in descending order.
SELECT srcStateName, SUM(TotalFarmersCovered) AS TotalFarmersCovered, SUM(SumInsured) AS SumInsured FROM FarmersInsuranceData
GROUP BY srcStateName ORDER BY TotalFarmersCovered DESC;

-- --------------------------------------------------------------------------------------
-- SECTION 2.
-- Filtering Data (WHERE)

-- Q3. Retrieve all records where Year is '2020'.
SELECT * FROM FarmersInsuranceData WHERE srcYear = 2020;

-- Q4. Retrieve all rows where the TotalPopulationRural is greater than 1 million and the srcStateName is 'HIMACHAL PRADESH'.
SELECT * FROM FarmersInsuranceData WHERE TotalPopulationRural > 1000000 AND srcStateName = 'HIMACHAL PRADESH';

-- Q5. Retrieve the srcStateName, srcDistrictName, and the sum of FarmersPremiumAmount for each district in the year 2018,
-- and display the results ordered by FarmersPremiumAmount in ascending order.
SELECT srcStateName, srcDistrictName, SUM(FarmersPremiumAmount) AS FarmersPremiumAmount FROM FarmersInsuranceData WHERE srcYear = 2018
GROUP BY srcStateName, srcDistrictName ORDER BY FarmersPremiumAmount ASC;

-- Q6. Retrieve the total number of farmers covered (TotalFarmersCovered) and the sum of premiums (GrossPremiumAmountToBePaid) for each state (srcStateName)
-- where the insured land area (InsuredLandArea) is greater than 5.0 and the Year is 2018.
SELECT srcStateName, SUM(TotalFarmersCovered) AS TotalFarmersCovered, SUM(GrossPremiumAmountToBePaid) AS GrossPremiumAmount
FROM FarmersInsuranceData WHERE InsuredLandArea > 5.0 AND srcYear = 2018 GROUP BY srcStateName;

-- ------------------------------------------------------------------------------------------------

-- SECTION 3.
-- Aggregation (GROUP BY)

-- Q7. Calculate the average insured land area (InsuredLandArea) for each year (srcYear).
SELECT srcYear, AVG(InsuredLandArea) AS AverageInsuredLandArea FROM FarmersInsuranceData GROUP BY srcYear;

-- Q8. Calculate the total number of farmers covered (TotalFarmersCovered) for each district (srcDistrictName) where Insurance units is greater than 0.
SELECT srcDistrictName, SUM(TotalFarmersCovered) AS TotalFarmersCovered FROM FarmersInsuranceData
WHERE InsuranceUnits > 0 GROUP BY srcDistrictName;

-- Q9. For each state (srcStateName), calculate the total premium amounts (FarmersPremiumAmount, StatePremiumAmount, GOVPremiumAmount)
-- and the total number of farmers covered (TotalFarmersCovered). Only include records where the sum insured (SumInsured) is greater than 500,000 (remember to check for scaling).
SELECT srcStateName, SUM(FarmersPremiumAmount) AS FarmersPremiumAmount, SUM(StatePremiumAmount) AS StatePremiumAmount,
SUM(GOVPremiumAmount) AS GOVPremiumAmount, SUM(TotalFarmersCovered) AS TotalFarmersCovered FROM FarmersInsuranceData
WHERE SumInsured > 500000 GROUP BY srcStateName;

-- -------------------------------------------------------------------------------------------------
-- SECTION 4.
-- Sorting Data (ORDER BY)

-- Q10. Retrieve the top 5 districts (srcDistrictName) with the highest TotalPopulation in the year 2020.
SELECT srcDistrictName, TotalPopulation FROM FarmersInsuranceData WHERE srcYear = 2020 ORDER BY TotalPopulation DESC LIMIT 5;

-- Q11. Retrieve the srcStateName, srcDistrictName, and SumInsured for the 10 districts with the lowest non-zero FarmersPremiumAmount,
-- ordered by insured sum and then the FarmersPremiumAmount.
SELECT srcStateName, srcDistrictName, SumInsured, FarmersPremiumAmount FROM FarmersInsuranceData WHERE FarmersPremiumAmount > 0
ORDER BY SumInsured ASC, FarmersPremiumAmount ASC LIMIT 10;

-- Q12. Retrieve the top 3 states (srcStateName) along with the year (srcYear) where the ratio of insured farmers (TotalFarmersCovered) to the total population (TotalPopulation) is highest.
-- Sort the results by the ratio in descending order.
SELECT srcStateName, srcYear, (TotalFarmersCovered / TotalPopulation) AS CoverageRatio FROM FarmersInsuranceData
WHERE TotalPopulation > 0 ORDER BY CoverageRatio DESC LIMIT 3;

-- -------------------------------------------------------------------------------------------------

-- SECTION 5.
-- String Functions

-- Q13. Create StateShortName by retrieving the first 3 characters of the srcStateName for each unique state.
SELECT DISTINCT srcStateName, LEFT(srcStateName,3) AS StateShortName FROM FarmersInsuranceData;

-- Q14. Retrieve the srcDistrictName where the district name starts with 'B'.
SELECT DISTINCT srcDistrictName FROM FarmersInsuranceData WHERE srcDistrictName LIKE 'B%';

-- Q15. Retrieve the srcStateName and srcDistrictName where the district name contains the word 'pur' at the end.
SELECT DISTINCT srcStateName, srcDistrictName FROM FarmersInsuranceData WHERE srcDistrictName LIKE '%pur';

-- -------------------------------------------------------------------------------------------------

-- SECTION 6.
-- Joins

-- Q16. Perform an INNER JOIN between the srcStateName and srcDistrictName columns to retrieve the aggregated FarmersPremiumAmount for districts where the district’s Insurance units for an individual year are greater than 10.
SELECT f1.srcStateName, f1.srcDistrictName, SUM(f1.FarmersPremiumAmount) AS TotalFarmersPremiumAmount FROM FarmersInsuranceData AS f1
INNER JOIN FarmersInsuranceData AS f2 ON f1.srcStateName = f2.srcStateName AND f1.srcDistrictName = f2.srcDistrictName
AND f1.srcYear = f2.srcYear WHERE f2.InsuranceUnits > 10 GROUP BY f1.srcStateName, f1.srcDistrictName;

-- Q17. Write a query that retrieves srcStateName, srcDistrictName, Year, TotalPopulation for each district and the the highest recorded FarmersPremiumAmount for that district over all available years
-- Return only those districts where the highest FarmersPremiumAmount exceeds 20 crores.
SELECT srcStateName, srcDistrictName, srcYear, TotalPopulation, MAX(FarmersPremiumAmount) AS HighestFarmersPremiumAmount
FROM FarmersInsuranceData GROUP BY srcStateName, srcDistrictName, srcYear, TotalPopulation HAVING MAX(FarmersPremiumAmount) > 200000000;

-- Q18. Perform a LEFT JOIN to combine the total population statistics with the farmers’ data (TotalFarmersCovered, SumInsured) for each district and state.
-- Return the total premium amount (FarmersPremiumAmount) and the average population count for each district aggregated over the years, where the total FarmersPremiumAmount is greater than 100 crores.
-- Sort the results by total farmers' premium amount, highest first.
SELECT f.srcStateName, f.srcDistrictName, SUM(f.FarmersPremiumAmount) AS TotalFarmersPremiumAmount,
    AVG(f.TotalPopulation) AS AveragePopulation, SUM(f.TotalFarmersCovered) AS TotalFarmersCovered, SUM(f.SumInsured) AS TotalSumInsured
FROM FarmersInsuranceData AS f LEFT JOIN FarmersInsuranceData AS p ON f.srcStateName = p.srcStateName
AND f.srcDistrictName = p.srcDistrictName GROUP BY f.srcStateName, f.srcDistrictName
HAVING SUM(f.FarmersPremiumAmount) > 100000000 ORDER BY TotalFarmersPremiumAmount DESC;

-- -------------------------------------------------------------------------------------------------

-- SECTION 7.
-- Subqueries

-- Q19. Write a query to find the districts (srcDistrictName) where the TotalFarmersCovered is greater than the average TotalFarmersCovered across all records.
SELECT DISTINCT srcDistrictName FROM FarmersInsuranceData
WHERE TotalFarmersCovered > ( SELECT AVG(TotalFarmersCovered) FROM FarmersInsuranceData );

-- Q20. Write a query to find the srcStateName where the SumInsured is higher than the SumInsured of the district with the highest FarmersPremiumAmount.
SELECT DISTINCT srcStateName FROM FarmersInsuranceData
WHERE SumInsured > ( SELECT SumInsured FROM FarmersInsuranceData ORDER BY FarmersPremiumAmount DESC LIMIT 1);

-- Q21. Write a query to find the srcDistrictName where the FarmersPremiumAmount is higher than the average FarmersPremiumAmount of the state that has the highest TotalPopulation.
SELECT srcDistrictName FROM FarmersInsuranceData
WHERE FarmersPremiumAmount > ( SELECT AVG(FarmersPremiumAmount) FROM FarmersInsuranceData
WHERE srcStateName = ( SELECT srcStateName FROM FarmersInsuranceData ORDER BY TotalPopulation DESC LIMIT 1) );

-- -------------------------------------------------------------------------------------------------

-- SECTION 8.
-- Data Integrity (Constraints, Foreign Keys)

-- Q22. Create a table 'districts' with DistrictCode as the primary key and columns for DistrictName and StateCode.
-- Create another table 'states' with StateCode as primary key and column for StateName.
CREATE TABLE states ( StateCode INT PRIMARY KEY, StateName VARCHAR(255) );

CREATE TABLE districts ( DistrictCode INT PRIMARY KEY, DistrictName VARCHAR(255), StateCode INT);

-- Q23. Add a foreign key constraint to the districts table that references the StateCode column from a states table.
ALTER TABLE districts ADD CONSTRAINT fk_state FOREIGN KEY (StateCode) REFERENCES states(StateCode);

-- -------------------------------------------------------------------------------------------------

SET SQL_SAFE_UPDATES = 0;

-- SECTION 9.
-- UPDATE and DELETE

-- Q24. Update the FarmersPremiumAmount to 500.0 for the record where rowID is 1.
UPDATE FarmersInsuranceData SET FarmersPremiumAmount = 500.0 WHERE rowID = 1;

-- Q25. Update the Year to '2021' for all records where srcStateName is 'HIMACHAL PRADESH'.
UPDATE FarmersInsuranceData SET srcYear = 2021 WHERE srcStateName = 'HIMACHAL PRADESH';

-- Q26. Delete all records where the TotalFarmersCovered is less than 10000 and Year is 2020.
DELETE FROM FarmersInsuranceData WHERE TotalFarmersCovered < 10000 AND srcYear = 2020;


SET SQL_SAFE_UPDATES = 1;
