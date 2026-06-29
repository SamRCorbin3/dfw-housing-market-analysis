Query 14 – County Appreciation Analysis
Business Question

Which DFW counties have experienced the highest average home value appreciation over the available time period?

-- ============================================
-- Query 14 - County Home Value Appreciation
-- Business Question:
-- Which DFW counties have experienced the
-- greatest average home value appreciation?
-- ============================================

WITH first_value AS (

    SELECT
        City,
        County,
        Home_Value,

        ROW_NUMBER() OVER (
            PARTITION BY City
            ORDER BY Observation_Date ASC
        ) AS row_num

    FROM housing_data

),

latest_value AS (

    SELECT
        City,
        Home_Value,

        ROW_NUMBER() OVER (
            PARTITION BY City
            ORDER BY Observation_Date DESC
        ) AS row_num

    FROM housing_data

),

city_appreciation AS (

    SELECT

        f.City,
        f.County,

        ((l.Home_Value - f.Home_Value) / f.Home_Value) * 100
            AS Appreciation_Percent

    FROM first_value f

    INNER JOIN latest_value l

        ON f.City = l.City

    WHERE

        f.row_num = 1

        AND l.row_num = 1

)

SELECT

    County,

    COUNT(*) AS Total_Cities,

    ROUND(AVG(Appreciation_Percent), 2)
        AS Average_Appreciation_Percent

FROM city_appreciation

GROUP BY County

ORDER BY Average_Appreciation_Percent DESC;