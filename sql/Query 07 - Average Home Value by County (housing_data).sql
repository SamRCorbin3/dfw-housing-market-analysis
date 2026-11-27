-- ============================================
-- Query 07 - Average Home Value by County
-- Business Question:
-- What is the average current home value by county?
-- ============================================

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

    ROUND(AVG(home_value), 2) AS average_home_value

FROM latest_data

WHERE row_num = 1

GROUP BY county

ORDER BY average_home_value DESC;
