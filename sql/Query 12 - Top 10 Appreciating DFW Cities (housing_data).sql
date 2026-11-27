-- ============================================
-- Query 12 - Top 10 Appreciating DFW Cities
-- Analysis Period: May 2016–May 2026
-- Excluded Cities: Fairview, Lantana, Perrin
-- Business Question:
-- Which cities experienced the highest
-- home value appreciation over the
-- available time period?
-- ============================================

WITH starting_values AS (

    SELECT
        region_id,
        city,
        county,
        home_value AS starting_value

    FROM `project-d3acdc67-4760-439a-b6d.dfw_housing_analysis.housing_data`

    WHERE observation_date = DATE '2016-05-31'
      AND city NOT IN ('Fairview', 'Lantana', 'Perrin')
      AND home_value > 0

),

ending_values AS (

    SELECT
        region_id,
        city,
        county,
        home_value AS current_value

    FROM `project-d3acdc67-4760-439a-b6d.dfw_housing_analysis.housing_data`

    WHERE observation_date = DATE '2026-05-31'
      AND city NOT IN ('Fairview', 'Lantana', 'Perrin')

)

SELECT
    s.city AS City,
    s.county AS County,
    ROUND(s.starting_value, 0) AS Starting_Value,
    ROUND(e.current_value, 0) AS Current_Value,

    ROUND(
        SAFE_DIVIDE(
            e.current_value - s.starting_value,
            s.starting_value
        ) * 100,
        2
    ) AS Appreciation_Percent

FROM starting_values s

INNER JOIN ending_values e
    ON s.region_id = e.region_id

WHERE s.city = e.city
  AND s.county = e.county

ORDER BY Appreciation_Percent DESC

LIMIT 10;
