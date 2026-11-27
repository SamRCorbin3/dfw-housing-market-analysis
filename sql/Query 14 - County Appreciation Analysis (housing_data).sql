-- ============================================
-- Query 14 - County Home Value Appreciation
-- Analysis Period: May 2016–May 2026
-- Excluded Cities: Fairview, Lantana, Perrin
-- Business Question:
-- Which DFW counties have experienced the
-- greatest average home value appreciation?
-- Method:
-- Unweighted average of city-level appreciation
-- percentages within each county.
-- ============================================

WITH endpoint_values AS (

    SELECT
        region_id,
        City,
        County,

        MAX(
            CASE
                WHEN Observation_Date = DATE '2016-05-31'
                THEN Home_Value
            END
        ) AS Starting_Home_Value,

        MAX(
            CASE
                WHEN Observation_Date = DATE '2026-05-31'
                THEN Home_Value
            END
        ) AS Current_Home_Value,

        COUNTIF(
            Observation_Date = DATE '2016-05-31'
        ) AS Starting_Observation_Count,

        COUNTIF(
            Observation_Date = DATE '2026-05-31'
        ) AS Current_Observation_Count,

        COUNT(DISTINCT IF(
            Observation_Date = DATE '2016-05-31',
            CONCAT(City, '|', County),
            NULL
        )) AS Starting_Identity_Count,

        COUNT(DISTINCT IF(
            Observation_Date = DATE '2026-05-31',
            CONCAT(City, '|', County),
            NULL
        )) AS Current_Identity_Count

    FROM
        `project-d3acdc67-4760-439a-b6d.dfw_housing_analysis.housing_data`

    WHERE
        City NOT IN ('Fairview', 'Lantana', 'Perrin')
        AND Observation_Date IN (
            DATE '2016-05-31',
            DATE '2026-05-31'
        )

    GROUP BY
        region_id,
        City,
        County
),

city_appreciation AS (

    SELECT
        region_id,
        City,
        County,

        SAFE_DIVIDE(
            Current_Home_Value - Starting_Home_Value,
            Starting_Home_Value
        ) * 100 AS Appreciation_Percent

    FROM endpoint_values

    WHERE
        Starting_Observation_Count > 0
        AND Current_Observation_Count > 0
        AND Starting_Home_Value > 0
        AND Current_Home_Value IS NOT NULL
        AND Starting_Identity_Count = 1
        AND Current_Identity_Count = 1
)

SELECT
    County,
    COUNT(*) AS Total_Cities,

    ROUND(
        AVG(Appreciation_Percent),
        2
    ) AS Average_Appreciation_Percent

FROM city_appreciation

GROUP BY County

ORDER BY Average_Appreciation_Percent DESC;
