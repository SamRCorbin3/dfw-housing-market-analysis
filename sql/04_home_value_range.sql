-- ============================================
-- Query 04 - Home Value Range
-- Business Question:
-- What is the range of current home values?
-- ============================================

WITH latest_data AS (

    SELECT
        region_id,
        city,
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

    MIN(home_value) AS minimum_value,

    MAX(home_value) AS maximum_value

FROM latest_data

WHERE row_num = 1;
