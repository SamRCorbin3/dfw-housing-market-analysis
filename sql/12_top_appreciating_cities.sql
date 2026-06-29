Query 12 – Top 10 Appreciating Cities
Business Question

Which DFW cities experienced the highest home value appreciation over the last 10 years?

-- ============================================
-- Query 12 - Top 10 Appreciating DFW Cities
-- Business Question:
-- Which cities experienced the highest
-- home value appreciation over the
-- available time period?
-- ============================================

WITH first_value AS (

    SELECT
        City,
        County,
        Home_Value,

        ROW_NUMBER() OVER (
            PARTITION BY RegionName
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

)

SELECT

    f.City AS City,

    f.County AS County,

    ROUND(f.Home_Value, 0) AS Starting_Value,

    ROUND(l.Home_Value, 0) AS Current_Value,

    ROUND(
        ((l.Home_Value - f.Home_Value) / f.Home_Value) * 100,
        2
    ) AS Appreciation_Percent

FROM first_value f

INNER JOIN latest_value l

ON f.City = l.City

WHERE

    f.row_num = 1

    AND l.row_num = 1

ORDER BY Appreciation_Percent DESC

LIMIT 10;
