Query 10 - Top 10 Most Expensive Cities

Business Question:
What are the 10 most expensive cities in the DFW Metroplex?

-- ============================================
-- Query 10 - Top 10 Most Expensive Cities
-- Business Question:
-- What are the 10 most expensive cities in the DFW Metroplex?
-- ============================================

WITH latest_data AS (

    SELECT
        city,
        county,
        home_value,
        observation_date,

        ROW_NUMBER() OVER (
            PARTITION BY city
            ORDER BY observation_date DESC
        ) AS row_num

    FROM housing_data

)

SELECT
    city,
    county,
    ROUND(home_value,0) AS current_home_value

FROM latest_data

WHERE row_num = 1

ORDER BY current_home_value ASC

LIMIT 10;