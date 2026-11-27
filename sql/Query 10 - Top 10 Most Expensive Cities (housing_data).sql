-- ==========================================================
-- Query 10 - Top 10 Most Expensive Cities
-- Business Question:
-- What are the top 10 most expensive cities in the DFW Metroplex?
-- Analysis Period: May 2016–May 2026
-- Excluded Cities: Fairview, Lantana, Perrin
-- ==========================================================

WITH latest_home_values AS (

    SELECT
        region_id,
        city,
        county,
        observation_date,
        home_value,

        ROW_NUMBER() OVER (
            PARTITION BY region_id
            ORDER BY observation_date DESC
        ) AS rn

    FROM `project-d3acdc67-4760-439a-b6d.dfw_housing_analysis.housing_data`

    WHERE city NOT IN ('Fairview', 'Lantana', 'Perrin')
      AND observation_date <= DATE '2026-05-31'
)

SELECT
    city,
    county,
    ROUND(home_value, 0) AS current_home_value

FROM latest_home_values

WHERE rn = 1

ORDER BY current_home_value DESC

LIMIT 10;
