Query 15 – Buyer Opportunity Index (Flagship Query)
Business Question

Which DFW cities offer the best overall buying opportunity when balancing affordability and historical appreciation?

-- ============================================
-- Query 15 - Buyer Opportunity Index
-- Business Question:
-- Which DFW cities provide the best balance
-- of affordability and appreciation?
-- ============================================

WITH first_value AS (

    SELECT
        City,
        County,
        Home_Value,

        ROW_NUMBER() OVER (
            PARTITION BY City
            ORDER BY Observation_Date ASC
        ) AS row_num

    FROM housing_data

),

latest_value AS (

    SELECT
        City,
        County,
        Home_Value,

        ROW_NUMBER() OVER (
            PARTITION BY City
            ORDER BY Observation_Date DESC
        ) AS row_num

    FROM housing_data
),

metrics AS (

    SELECT

        f.City,

        f.County,

        l.Home_Value AS Current_Home_Value,

        ((l.Home_Value - f.Home_Value) / f.Home_Value) * 100
            AS Appreciation_Percent

    FROM first_value f

    INNER JOIN latest_value l

        ON f.City = l.City

    WHERE

        f.row_num = 1

        AND l.row_num = 1

),

ranked AS (

    SELECT

        City,

        County,

        ROUND(Current_Home_Value,0) AS Current_Home_Value,

        ROUND(Appreciation_Percent,2) AS Appreciation_Percent,

        DENSE_RANK() OVER (

            ORDER BY Current_Home_Value ASC

        ) AS Affordability_Rank,

        DENSE_RANK() OVER (

            ORDER BY Appreciation_Percent DESC

        ) AS Appreciation_Rank

    FROM metrics

),

buyer_scores AS (

    SELECT

        City,
        County,
        Current_Home_Value,
        Appreciation_Percent,
        Affordability_Rank,
        Appreciation_Rank,

        (Affordability_Rank + Appreciation_Rank)
            AS Buyer_Opportunity_Score

    FROM ranked

)

SELECT

    DENSE_RANK() OVER (
        ORDER BY Buyer_Opportunity_Score ASC
    ) AS Buyer_Opportunity_Rank,

    City AS City,
    County AS County,
    Current_Home_Value,
    Appreciation_Percent,
    Affordability_Rank,
    Appreciation_Rank,
    Buyer_Opportunity_Score

FROM buyer_scores

ORDER BY Buyer_Opportunity_Rank;
