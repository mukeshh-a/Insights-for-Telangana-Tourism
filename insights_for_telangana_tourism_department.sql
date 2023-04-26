/* INSIGHTS FOR TELANGANA GOVERNMENT TOURISM DEPARTMENT */

/* PRIMARY RESEARCH
	
   FINDING 1. TOP 10 DISTRICTS HAVING HIGHEST NUMBER OF DOMESTIC VISITORS. */

SELECT TOP 10
	 district AS [District]
	,SUM(visitors) AS [Total Visitors]
FROM domestic_visitors
GROUP BY [District]
ORDER BY [Total Visitors] DESC
GO



/* FINDING 2. TOP 3 DISTRICTS BASED ON  COMPOUND  ANNUAL GROWTH RATE (CAGR) OF VISITORS FROM 2016 TO 2019. */

-- FOR ALL VISITORS COMBINED

WITH [Growth Rates] AS (
	SELECT 
		 d.district AS [District]
		,POWER(MAX(d.visitors + f.visitors) / NULLIF(MIN(d.visitors + f.visitors), 0), 0.25) - 1 AS [CAGR]
	FROM domestic_visitors d 
	JOIN foreign_visitors f
	ON d.date = f.date AND d.district = f.district AND d.year = f.year AND d.month = f.month
	WHERE d.year >= 2016 AND d.year <= 2019
	GROUP BY d.district
)
SELECT TOP 3 
	[District]
	,AVG([CAGR]) AS [Average CAGR]
FROM [Growth Rates]
GROUP BY [District]
ORDER BY [Average CAGR] DESC
GO



-- FOR DOMESTIC VISITORS

WITH [Growth Rates] AS (
	SELECT
		district AS [District]
		,POWER(MAX(visitors) / NULLIF(MIN(visitors), 0), 0.25) - 1 AS [CAGR]
	FROM domestic_visitors 
	WHERE year >= 2016 AND year <= 2019
	GROUP BY district
	HAVING MIN(visitors) > 0
)
SELECT TOP 3 
	[District]
	,AVG([CAGR]) AS [Average CAGR]
FROM [Growth Rates]
GROUP BY [District]
ORDER BY [Average CAGR] DESC
GO


-- FOR FOREIGN VISITORS

WITH [Growth Rates] AS (
SELECT
	 district AS [District]
	,POWER(MAX(visitors) / NULLIF(MIN(visitors), 0), 0.25) - 1 AS [CAGR]
FROM foreign_visitors 
WHERE year >= 2016 AND year <= 2019
GROUP BY district
HAVING MIN(visitors) > 0
)
SELECT TOP 3 
	[District]
	,AVG([CAGR]) AS [Average CAGR]
FROM [Growth Rates]
GROUP BY [District]
ORDER BY [Average CAGR] DESC
GO



/* FINDING 3. BOTTOM 3 DISTRICTS BASED ON  COMPOUND  ANNUAL GROWTH RATE (CAGR) OF VISITORS FROM 2016 TO 2019. */

-- FOR ALL VISITORS COMBINED
WITH [Growth Rates] AS (
	SELECT 
		 d.district AS [District]
		,POWER(MAX(d.visitors + f.visitors) / NULLIF(MIN(d.visitors + f.visitors), 0), 0.25) - 1 AS [CAGR]  
	FROM domestic_visitors d 
	JOIN foreign_visitors f
	ON d.date = f.date AND d.district = f.district AND d.year = f.year AND d.month = f.month
	WHERE d.year >= 2016 AND d.year <= 2019
	GROUP BY d.district
)
SELECT TOP 3 
	[District]
	,AVG([CAGR]) AS [Average CAGR]
FROM [Growth Rates]
GROUP BY [District]
ORDER BY [Average CAGR]
GO



-- FOR DOMESTIC VISITORS

WITH [Growth Rates] AS (
	SELECT
		district AS [District]
		,POWER(MAX(visitors) / NULLIF(MIN(visitors), 0), 0.25) - 1 AS [CAGR]
	FROM domestic_visitors 
	WHERE year >= 2016 AND year <= 2019
	GROUP BY district
	HAVING MIN(visitors) > 0
)
SELECT TOP 3 
	[District]
	,AVG([CAGR]) AS [Average CAGR]
FROM [Growth Rates]
GROUP BY [District]
ORDER BY [Average CAGR]
GO



-- FOR FOREIGN VISITORS 

WITH [Growth Rates] AS (
SELECT
	 district AS [District]
	,POWER(MAX(visitors) / NULLIF(MIN(visitors), 0), 0.25) - 1 AS [CAGR]
FROM foreign_visitors 
WHERE year >= 2016 AND year <= 2019
GROUP BY district
HAVING MIN(visitors) > 0
)
SELECT TOP 3 
	[District]
	,AVG([CAGR]) AS [Average CAGR]
FROM [Growth Rates]
GROUP BY [District]
ORDER BY [Average CAGR]
GO



/* FINDING 4. PEAK AND  LOW SEASON MONTHS FOR HYDERABAD DISTRICT. 
	
-- FOR ALL VISITORS 
-- PEAK SEASON MONTHS */

WITH total_visitors AS (
  SELECT 
     d.district
    ,d.visitors + f.visitors AS total_visitors
    ,d.month
  FROM domestic_visitors d
  JOIN foreign_visitors f
  ON d.date = f.date AND d.district = f.district AND d.month = f.month AND d.year = f.year
  GROUP BY d.district 
		   ,d.visitors 
		   ,f.visitors 
		   ,d.month
)

SELECT TOP 3 
	 month
	,SUM(total_visitors) AS vis_count
FROM total_visitors
WHERE district = 'Hyderabad'
GROUP BY month 
ORDER BY vis_count DESC
GO
 


-- LOW SEASON MONTHS

WITH total_visitors AS (
  SELECT 
     d.district
    ,d.visitors + f.visitors AS total_visitors
    ,d.month
  FROM domestic_visitors d
  JOIN foreign_visitors f
  ON d.date = f.date AND d.district = f.district AND d.month = f.month AND d.year = f.year
  GROUP BY d.district 
		   ,d.visitors 
		   ,f.visitors 
		   ,d.month
)

SELECT TOP 3 
	 month
	,SUM(total_visitors) AS vis_count
FROM total_visitors
WHERE district = 'Hyderabad'
GROUP BY month 
ORDER BY vis_count
GO



-- FOR DOMESTIC VISITORS
--PEAK SEASON MONTHS
  
SELECT TOP 3
	 [month]
    ,SUM(visitors) AS total_visitors
FROM domestic_visitors 
WHERE district = 'Hyderabad'
GROUP BY 
  	 [month] 
ORDER BY total_visitors DESC
GO



-- LOW SEASON MONTHS

SELECT TOP 3
	 [month]
    ,SUM(visitors) AS total_visitors
FROM domestic_visitors 
WHERE district = 'Hyderabad'
GROUP BY 
  	 [month] 
ORDER BY total_visitors
GO



-- FOR FOREIGN VISITORS
-- PEAK SEASON MONTHS

SELECT TOP 3
	 [month]
    ,SUM(visitors) AS total_visitors
FROM foreign_visitors 
WHERE district = 'Hyderabad'
GROUP BY 
  	 [month] 
ORDER BY total_visitors DESC
GO


-- LOW SEASON MONTHS

SELECT TOP 3
	 [month]
    ,SUM(visitors) AS total_visitors
FROM foreign_visitors 
WHERE district = 'Hyderabad'
GROUP BY 
  	 [month] 
ORDER BY total_visitors
GO



/* FINDING 5. TOP AND BOTTOM 3 DISTRICTS WITH HIGH DOMESTIC TO FOREIGN VISITOR RATIO. */

-- TOP 5 DISTRICTS

WITH domestic AS (
    SELECT 
		 district
		,SUM(visitors) AS total_domestic_visitors
    FROM domestic_visitors
    WHERE visitors > 0
    GROUP BY district
),
[foreign] AS (
    SELECT 
		 district
		,SUM(visitors) AS total_foreign_visitors
    FROM foreign_visitors
    WHERE visitors > 0
    GROUP BY district
)
SELECT TOP 3 
	 domestic.district AS [District]
	,domestic.total_domestic_visitors AS [Total Domestic Visitors]
	,[foreign].total_foreign_visitors AS [Total Foreign Visitors],
    	CASE WHEN [foreign].total_foreign_visitors = 0 THEN 0 
	   		ELSE domestic.total_domestic_visitors / [foreign].total_foreign_visitors 
		END AS domestic_to_foreign_ratio
FROM domestic
INNER JOIN [foreign] 
ON domestic.district = [foreign].district
ORDER BY domestic_to_foreign_ratio DESC
GO



-- BOTTOM 5 DISTRICTS

WITH domestic AS (
    SELECT 
		 district
		,SUM(visitors) AS total_domestic_visitors
    FROM domestic_visitors
    WHERE visitors > 0
    GROUP BY district
),
[foreign] AS (
    SELECT 
		 district
		,SUM(visitors) AS total_foreign_visitors
    FROM foreign_visitors
    WHERE visitors > 0
    GROUP BY district
)
SELECT TOP 3 
	 domestic.district AS [District]
	,domestic.total_domestic_visitors AS [Total Domestic Visitors]
	,[foreign].total_foreign_visitors AS [Total Foreign Visitors],
    	CASE WHEN [foreign].total_foreign_visitors = 0 THEN 0 
	   		ELSE domestic.total_domestic_visitors / [foreign].total_foreign_visitors 
		END AS domestic_to_foreign_ratio
FROM domestic
INNER JOIN [foreign] 
ON domestic.district = [foreign].district
ORDER BY domestic_to_foreign_ratio
GO



/* FINDING 6. TOP AND BOTTOM 5 DISTRICTS BASED ON POPULATION TO TOURIST FOOTFALL RATIO IN 2019. */

-- TOP 5 DISTRICTS

WITH combined_visitors AS (
  SELECT
  		district
		,date
		,month
		,year
		,visitors
  FROM domestic_visitors
  UNION ALL
  SELECT
  		district
		,date
		,month
		,year
		,visitors
  FROM foreign_visitors
), 
total_visitors AS (
  SELECT 
  		district
	   ,SUM(visitors) AS total_visitors
  FROM combined_visitors
  GROUP BY district
),
district_population AS (
  SELECT 
  		district
	   ,est_population_2019
  FROM population
),
district_tourist_ratio AS (
  SELECT 
		t.district
	   ,t.total_visitors / p.est_population_2019 AS footfall_ratio
  FROM total_visitors t
  INNER JOIN district_population p
  ON t.district = p.district
)
SELECT TOP 5 
	 district
	,footfall_ratio
FROM district_tourist_ratio
ORDER BY footfall_ratio DESC
GO



-- BOTTOM 5 DISTRICTS

WITH combined_visitors AS (
  SELECT
  		district
		,date
		,month
		,year
		,visitors
  FROM domestic_visitors
  UNION ALL
  SELECT
  		district
		,date
		,month
		,year
		,visitors
  FROM foreign_visitors
), 
total_visitors AS (
  SELECT 
  		district
	   ,SUM(visitors) AS total_visitors
  FROM combined_visitors
  GROUP BY district
),
district_population AS (
  SELECT 
  		district
	   ,est_population_2019
  FROM population
),
district_tourist_ratio AS (
  SELECT 
		t.district
	   ,t.total_visitors / p.est_population_2019 AS footfall_ratio
  FROM total_visitors t
  INNER JOIN district_population p
  ON t.district = p.district
)
SELECT TOP 5 
	 district
	,footfall_ratio
FROM district_tourist_ratio
ORDER BY footfall_ratio
GO



/* FINDING 7. PROJECTED NUMBER OF DOMESTIC AND FOREIGN VISITORS IN 2025 FOR HYDERABAD DISTRICT BASED ON GROWTH RATE OF PREVIOUS YEARS. */

-- FOR DOMESTIC VISITORS

WITH hyderabad_domestic_cagr AS ( 
    SELECT 
		 district
        ,POWER(MAX(visitors) / NULLIF(MIN(visitors), 0), 0.25) - 1 AS [CAGR]
    FROM domestic_visitors
    WHERE district = 'Hyderabad' AND year BETWEEN 2016 AND 2019 AND visitors > 0
    GROUP BY district
),
hyderabad_domestic_visitor_count_2019 AS (
    SELECT SUM(visitors) AS hyderabad_domestic_visitors_2019
    FROM domestic_visitors
    WHERE district = 'Hyderabad' AND year = 2019
)
SELECT 
	ROUND(hyderabad_domestic_visitor_count_2019.hyderabad_domestic_visitors_2019 * POWER((1 + hyderabad_domestic_cagr.cagr), 6),0) AS hyderabad_domestic_visitors_2025
FROM 
	 hyderabad_domestic_cagr
	,hyderabad_domestic_visitor_count_2019
WHERE hyderabad_domestic_cagr.district = 'Hyderabad'
GO



-- FOR FOREIGN VISITORS

WITH hyderabad_foreign_cagr AS ( 
    SELECT 
		 district 
        ,POWER(MAX(visitors) / NULLIF(MIN(visitors), 0), 0.25) - 1 AS [CAGR]
    FROM foreign_visitors
    WHERE district = 'Hyderabad' AND year BETWEEN 2016 AND 2019 AND visitors > 0
    GROUP BY district
),
hyderabad_foreign_visitor_count_2019 AS (
    SELECT SUM(visitors) AS hyderabad_foreign_visitors_2019
    FROM foreign_visitors
    WHERE district = 'Hyderabad' AND year = 2019
)
SELECT 
	ROUND(hyderabad_foreign_visitor_count_2019.hyderabad_foreign_visitors_2019 * POWER((1 + hyderabad_foreign_cagr.cagr), 6),0) AS hyderabad_foreign_visitors_2025
FROM 
	 hyderabad_foreign_cagr
	,hyderabad_foreign_visitor_count_2019
WHERE hyderabad_foreign_cagr.district = 'Hyderabad'
GO



/* FINDING 8. PROJECTED REVENUE FOR HYDERABAD IN 2025 BASED ON AVERAGE SPEND PER VISITOR. */

WITH hyderabad_domestic_cagr AS (
SELECT 
	 district
	,POWER((MAX(visitors) * 1.0 / MIN(visitors)), 1.0 / COUNT(DISTINCT year)) - 1 AS cagr
FROM domestic_visitors
WHERE district = 'Hyderabad' AND year BETWEEN 2016 AND 2019 AND visitors > 0
GROUP BY district
),
hyderabad_domestic_visitor_count_2019 AS (
SELECT 
	SUM(visitors) AS hyderabad_domestic_visitors_2019
FROM domestic_visitors
WHERE district = 'Hyderabad' AND year = 2019
),
hyderabad_foreign_cagr AS (
SELECT 
	 district
	,POWER((MAX(visitors) * 1.0 / MIN(visitors)), 1.0 / COUNT(DISTINCT year)) - 1 AS cagr
FROM foreign_visitors
WHERE district = 'Hyderabad' AND year BETWEEN 2016 AND 2019 AND visitors > 0
GROUP BY district
),
hyderabad_foreign_visitor_count_2019 AS (
SELECT 
	SUM(visitors) AS hyderabad_foreign_visitors_2019
FROM foreign_visitors
WHERE district = 'Hyderabad' AND year = 2019
),
hyderabad_domestic_visitors_2025 AS (
SELECT 
	hyderabad_domestic_visitor_count_2019.hyderabad_domestic_visitors_2019 * POWER((1 + hyderabad_domestic_cagr.cagr), 6) AS hyderabad_domestic_visitors_2025
FROM hyderabad_domestic_cagr, hyderabad_domestic_visitor_count_2019
WHERE hyderabad_domestic_cagr.district = 'Hyderabad'
),
hyderabad_foreign_visitors_2025 AS (
SELECT 
	hyderabad_foreign_visitor_count_2019.hyderabad_foreign_visitors_2019 * POWER((1 + hyderabad_foreign_cagr.cagr), 6) AS hyderabad_foreign_visitors_2025
FROM hyderabad_foreign_cagr, hyderabad_foreign_visitor_count_2019
WHERE hyderabad_foreign_cagr.district = 'Hyderabad'
),
hyderabad_revenue_2025 AS (
SELECT 
	 hyderabad_domestic_visitors_2025.hyderabad_domestic_visitors_2025 * 1200 AS hyderabad_domestic_visitors_revenue_2025
	,hyderabad_foreign_visitors_2025.hyderabad_foreign_visitors_2025 * 5600 AS hyderabad_foreign_visitors_revenue_2025
FROM hyderabad_domestic_visitors_2025, hyderabad_foreign_visitors_2025
)
SELECT 
	 hyderabad_revenue_2025.hyderabad_domestic_visitors_revenue_2025 AS [Projected Revenue By Domestic Visitors in 2025]
	,hyderabad_revenue_2025.hyderabad_foreign_visitors_revenue_2025 AS [Projected Revenue By Foreign Visitors in 2025]
FROM hyderabad_revenue_2025
GO
