-- This code slects company and left 4 part of fiscal year and stores them in preliminary table1 i.e.ptable1.

WITH ptable1 AS(
SELECT 
	company, 
	CAST(LEFT(CAST(fiscal_year AS TEXT),4) AS INT) Lyear -- Converts integer into text so as to use LEFT function and converts the result back to integer
	FROM dividend),


-- This code creates lead of Lyear and calulates difference between lead and Lyear and store it on diff column on preliminary table2 i.e. ptable2.
-- We are interested in the difference column with value 1. Column's value with gap more than 1 means that dividend were not given in consecutive years.

ptable2 AS(
SELECT
	company,
	lead( Lyear,1) OVER( PARTITION BY company ORDER BY Lyear) - Lyear AS diff
	FROM ptable1),


-- This code creates lead of diff and calulates difference between lead of diff and diff and store it on final-column on final table i.e ftable.
-- To get 3 consecutive years, we wanted the diff value in ptable2 to have consecutive 1 twice.
-- To get that we again take lead and difference to get the value 0. Value 0 means that that value of 1 occoured twice consecutively on diff column.

ftable AS(
SELECT 
	company,
	lead( diff,1) OVER( PARTITION BY company ORDER BY diff) - diff AS final_column
	FROM ptable2)


-- Finally, we slect distinct company from final table i.e. ftable whose final_column is 0.

SELECT ARRAY_AGG(DISTINCT(company)) 
FROM ftable
WHERE final_column = 0;