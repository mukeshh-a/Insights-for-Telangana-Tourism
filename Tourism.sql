CREATE DATABASE tourism;


CREATE TABLE domestic_visitors
(
    district varchar(100),
    date date,
    MONTH varchar(20),
    YEAR integer,
    visitors bigint
);


CREATE TABLE foreign_visitors
(
    district varchar(100),
    date date,
    MONTH varchar(20),
    YEAR integer,
    visitors bigint
);


CREATE TABLE population
(
    district varchar(100),
    population_2011 bigint,
    est_population_2019 decimal,
    est_population_2023 bigint,
    est_population_2025 decimal
);


/* Top 10 districts having highest number of domestic visitors */

SELECT 
  district, 
  sum(visitors) AS visitors 
FROM 
  domestic_visitors 
GROUP BY 
  district 
ORDER BY 
  visitors DESC 
LIMIT 
  10;



/* Top 3 districts based on CAGR of visitors between 2016-2019 */

SELECT
  dv.district,
  SUM(CASE
    WHEN dv.year = 2016 THEN dv.visitors
    ELSE 0
  END) AS "visitors 2016",
  SUM(CASE
    WHEN dv.year = 2019 THEN dv.visitors
    ELSE 0
  END) AS "visitors 2019",
  ROUND(((pow(MAX(dv.visitors) / MIN(dv.visitors),1 / 3.0) - 1) * 100), 2) AS cagr
FROM domestic_visitors dv
WHERE dv.year BETWEEN 2016 AND 2019
GROUP BY dv.district
HAVING MIN(dv.visitors) > 0
ORDER BY cagr DESC
LIMIT 3;

/* Bottom 3 districts based on CAGR of visitors between 2016-2019 */

SELECT
  dv.district,
  SUM(CASE
    WHEN dv.year = 2016 THEN dv.visitors
    ELSE 0
  END) AS "visitors 2016",
  SUM(CASE
    WHEN dv.year = 2019 THEN dv.visitors
    ELSE 0
  END) AS "visitors 2019",
  ROUND(((pow(MAX(dv.visitors) / MIN(dv.visitors),1 / 3.0) - 1) * 100), 2) AS cagr
FROM domestic_visitors dv
WHERE dv.year BETWEEN 2016 AND 2019
GROUP BY dv.district
HAVING MIN(dv.visitors) > 0
ORDER BY cagr
LIMIT 3;

/* Peak and Low season months for Hyderabad */ -- Peak and Low seasons on the basis of Domestic Visitors
-- Peak Months

SELECT
  MONTH AS "Peak Season Months",
  SUM(visitors) AS visitors
FROM domestic_visitors
WHERE district = 'Hyderabad'
GROUP BY MONTH
ORDER BY visitors DESC
LIMIT 3;

-- Low months

SELECT
  MONTH AS "Low Season Months",
  SUM(visitors) AS visitors
FROM domestic_visitors
WHERE district = 'Hyderabad'
GROUP BY MONTH
ORDER BY visitors
LIMIT 3;

-- Peak and Low seasons on the basis of Foreign Visitors
-- Peak Months

SELECT
  MONTH AS "Peak Season Months",
  SUM(visitors) AS visitors
FROM foreign_visitors
WHERE district = 'Hyderabad'
GROUP BY MONTH
ORDER BY visitors DESC
LIMIT 3;

-- Low months

SELECT
  MONTH AS "Low Season Months",
  SUM(visitors) AS visitors
FROM foreign_visitors
WHERE district = 'Hyderabad'
GROUP BY MONTH
ORDER BY visitors
LIMIT 3;

/* Top & Bottom 3 districts with high domestic to foreign visitor ratio */ -- Top 3 districts with high domestic to foreign visitor ratio

SELECT
  d.district,
  round(
    sum(d.visitors) :: numeric / nullif(
      sum(f.visitors),
      0
    ) :: numeric,
    2
  ) AS domestic_to_foreign_ratio
FROM
  domestic_visitors d
  LEFT JOIN foreign_visitors f ON d.district = f.district
  AND d.month = f.month
  AND d.year = f.year
GROUP BY
  d.district
HAVING
  sum(f.visitors) > 0
ORDER BY
  domestic_to_foreign_ratio DESC
LIMIT 3;

-- Bottom 3 districts with high domestic to foreign visitor ratio

SELECT
  d.district,
  ROUND (
SUM (d.visitors) :: numeric / NULLIF (
SUM (f.visitors),
0
) :: numeric,
2
) AS domestic_to_foreign_ratio
FROM domestic_visitors d
LEFT JOIN foreign_visitors f
  ON d.district = f.district
  AND d.month = f.month
  AND d.year = f.year
GROUP BY d.district
HAVING SUM(f.visitors) > 0
ORDER BY domestic_to_foreign_ratio
LIMIT 3;

/* Top and Bottom 5  districts based on population to tourist footfall  ratio in 2019 */ -- For Domestic Visitors
 -- Top 5  districts based on population to tourist footfall  ratio in 2019

SELECT
  d.district,
  ROUND((SUM(visitors) / SUM(est_population_2019)) * 100,
  2) AS p2fr
FROM domestic_visitors d
INNER JOIN population p
  ON d.district = p.district
WHERE YEAR = 2019
GROUP BY d.district
ORDER BY p2fr DESC
LIMIT 5;

-- Bottom 5  districts based on population to tourist footfall  ratio in 2019

SELECT
  d.district,
  ROUND((SUM(visitors) / SUM(est_population_2019)) * 100,
  2) AS p2fr
FROM domestic_visitors d
INNER JOIN population p
  ON d.district = p.district
WHERE YEAR = 2019
GROUP BY d.district
ORDER BY p2fr 
LIMIT 5;

-- For Foreign Visitors
--Bottom 5 districts

SELECT
  fv.district,
  ROUND((SUM(visitors) / SUM(est_population_2019)) * 100,
  2) AS p2fr
FROM foreign_visitors fv
INNER JOIN population p
  ON fv.district = p.district
WHERE YEAR = 2019
GROUP BY fv.district
ORDER BY p2fr
LIMIT 5;

-- Top 5 districts

SELECT
  fv.district,
  ROUND((SUM(visitors) / SUM(est_population_2019)) * 100,
  2) AS p2fr
FROM foreign_visitors fv
INNER JOIN population p
  ON fv.district = p.district
WHERE YEAR = 2019
GROUP BY fv.district
ORDER BY p2fr DESC
LIMIT 5;

/* projected number of Domestic and foreign visitors in 2025 for Hyderabad district based on growth rate of previous years*/ -- Domestic and Foreign visitors in 2019 for Hyderabad district

SELECT
  SUM(dv.visitors) AS domestic_visitors_2019,
  SUM(fv.visitors) AS foreign_visitors_2019
FROM domestic_visitors dv
JOIN foreign_visitors fv
  ON dv.district = fv.district
  AND dv.date = fv.date
  AND dv.month = fv.month
  AND dv.year = fv.year
WHERE dv.district = 'Hyderabad'
AND dv.year = 2019
AND fv.year = 2019;

-- Projected number of Domestic and foreign visitors in 2025 for Hyderabad district based on growth rate of previous years

WITH domestic_growth_rate
AS (SELECT
  ROUND(((pow(MAX(dv.visitors) / MIN(dv.visitors),1 / 3.0) - 1) * 100), 2) AS cagr
FROM domestic_visitors dv
WHERE dv.district = 'Hyderabad'),
foreign_growth_rate
AS (SELECT
  ROUND(((pow(MAX(fv.visitors) / MIN(fv.visitors),1 / 3.0) - 1) * 100), 2) AS cagr
FROM foreign_visitors fv
WHERE fv.district = 'Hyderabad')
SELECT
  ROUND((dv_2019 * pow((1 + domestic_growth_rate.cagr / 100), (2025 - 2019))), 0) AS projected_domestic_visitors_2025,
  ROUND((fv_2019 * pow((1 + foreign_growth_rate.cagr / 100), (2025 - 2019))), 0) AS projected_foreign_visitors_2025
FROM (SELECT
       SUM(dv.visitors) AS dv_2019,
       SUM(fv.visitors) AS fv_2019
     FROM domestic_visitors dv
     JOIN foreign_visitors fv
       ON dv.district = fv.district
       AND dv.date = fv.date
       AND dv.month = fv.month
       AND dv.year = fv.year
     WHERE dv.district = 'Hyderabad'
     AND dv.year = 2019
     AND fv.year = 2019) t,
     domestic_growth_rate,
     foreign_growth_rate;


/* Projected revenue for the hyderabad in 2025, based on average spend per visitor */ 

WITH domestic_visitors
AS (SELECT
  SUM(visitors) AS visitors_2019
FROM domestic_visitors
WHERE district = 'Hyderabad'
AND YEAR = 2019),
foreign_visitors
AS (SELECT
  SUM(visitors) AS visitors_2019
FROM foreign_visitors
WHERE district = 'Hyderabad'
AND YEAR = 2019)
SELECT
  ROUND((domestic_visitors.visitors_2019 * 1200 * pow(1.05, (2025 - 2019))), 0) AS projected_domestic_revenue_2025,
  ROUND((foreign_visitors.visitors_2019 * 5600 * pow(1.05, (2025 - 2019))), 0) AS projected_foreign_revenue_2025
FROM domestic_visitors,
     foreign_visitors;

	 
