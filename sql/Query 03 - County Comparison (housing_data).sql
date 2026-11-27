-- ==========================================================
-- Query 03: County Comparison
-- Business Question:
-- How do average home values compare across DFW counties?
-- ==========================================================

WITH latest_data AS (

    SELECT
        region_id,
        city,
        county,
        home_value,
        observation_date,

        ROW_NUMBER() OVER (
            PARTITION BY region_id
            ORDER BY observation_date DESC
        ) AS row_num

    FROM `project-d3acdc67-4760-439a-b6d.dfw_housing_analysis.housing_data`

    WHERE observation_date <= DATE '2026-05-31'
      AND city NOT IN ('Fairview', 'Lantana', 'Perrin')
)

SELECT

    county,

    COUNT(DISTINCT city) AS total_cities,

    ROUND(AVG(home_value), 0) AS average_home_value,

    ROUND(MIN(home_value), 0) AS lowest_home_value,

    ROUND(MAX(home_value), 0) AS highest_home_value

FROM latest_data

WHERE row_num = 1

GROUP BY county

ORDER BY average_home_value DESC;
