-- ============================================
-- Query 06 - Cities by County
-- Business Question:
-- How many cities belong to each county?
-- ============================================

WITH latest_data AS (

    SELECT
        region_id,
        city,
        county,
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

    COUNT(DISTINCT city) AS total_cities

FROM latest_data

WHERE row_num = 1

GROUP BY county

ORDER BY total_cities DESC;
