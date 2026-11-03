# PMFBY Farmers Insurance Analysis (SQL)

District-level SQL analysis of India's Pradhan Mantri Fasal Bima Yojana (PMFBY) crop
insurance scheme, using open government data from NDAP (National Data & Analytics
Platform, NITI Aayog).

## Objective
Explore farmer coverage, premium collection, and demographic/population patterns
across states and districts, and practice the full range of core-to-intermediate
SQL skills on a real government dataset.

## Dataset
- **Source:** [NDAP - National Data & Analytics Platform](https://ndap.niti.gov.in/)
- **Table:** `FarmersInsuranceData` — district-year level records covering insurance
  units, farmers covered, premium amounts (farmer/state/government share), sum
  insured, demographic coverage percentages, and population/household statistics.

## Tools
MySQL / MySQL Workbench

## What's in here
| File | Contents |
|---|---|
| `schema.sql` | Table definition and `LOAD DATA` statement to load the CSV |
| `queries.sql` | 26 queries, organized by topic (see below) |

## SQL concepts demonstrated
- Basic `SELECT` / `DISTINCT`
- Filtering with `WHERE`, multiple conditions, ranges
- `GROUP BY` aggregation (`SUM`, `AVG`)
- `ORDER BY` + `LIMIT` for top-N analysis
- String functions (`LEFT`, `LIKE`) for pattern matching
- `INNER JOIN` and `LEFT JOIN` (self-joins on the same table)
- Correlated and non-correlated subqueries
- Table constraints and `FOREIGN KEY` relationships
- `UPDATE` and `DELETE` with conditions

## Sample insights
- States can be ranked by total farmers covered and total sum insured to see where
  PMFBY has the deepest reach.
- Coverage ratio (farmers covered / total population) highlights districts where
  insurance penetration is highest relative to population, not just in absolute terms.
- Districts with premium collections above ₹20 crore stand out as the highest-value
  insurance markets in the dataset.

## How to run
1. Download the PMFBY dataset CSV from NDAP and save it as `data.csv` in this
   project's root folder (same folder as `schema.sql`).
2. Run `schema.sql` in MySQL Workbench (enable `local_infile` if prompted). On
   Windows, if the relative path doesn't resolve, point `LOAD DATA LOCAL INFILE`
   at the file directly, e.g. `'D:/Projects/PMFBY-Farmers-Insurance-SQL-Analysis/data.csv'`.
3. Run `queries.sql` to execute the analysis queries.
