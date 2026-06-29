Query 8 - Latest Home Value by City
Business Question

What is the latest available home value for each DFW city?
-- ==========================================================
-- Query 8 - Latest Home Value by City
-- Business Question:
-- What is the latest available home value for each DFW city?
-- ==========================================================

WITH latest_home_values AS (

    SELECT
        city,
        county,
        observation_date,
        home_value,

        ROW_NUMBER() OVER (
            PARTITION BY city
            ORDER BY observation_date DESC
        ) AS rn

    FROM housing_data

)

SELECT
    city,
    county,
    observation_date,
    ROUND(home_value, 0) AS current_home_value

FROM latest_home_values

WHERE rn = 1

ORDER BY current_home_value ASC;
