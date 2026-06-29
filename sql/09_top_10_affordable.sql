Query 9 - Top 10 Most Affordable Cities

Business Question: 
What are the top 10 Most Affordable Cities in the DFW Metroplex?

-- ==========================================================
-- Query 9 - Top 10 Most Affordable Cities
-- Business Question:
-- What are the top 10 Most Affordable Cities in the DFW Metroplex?
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
    ROUND(home_value, 0) AS current_home_value

FROM latest_home_values

WHERE rn = 1

ORDER BY current_home_value ASC

LIMIT 10;
