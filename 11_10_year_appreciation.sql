Query 11 – 10-Year Home Value Appreciation
Business Question

Which DFW cities have experienced the greatest percentage increase in home values over the last 10 years?

-- ============================================
-- Query 11 - 10-Year Home Value Appreciation
-- Business Question:
-- How much has each DFW city's home value
-- appreciated over the available time period?
-- ============================================

WITH first_value AS (

    SELECT
        City,
        County,
        Observation_Date,
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
        Observation_Date,
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

ORDER BY Appreciation_Percent DESC;