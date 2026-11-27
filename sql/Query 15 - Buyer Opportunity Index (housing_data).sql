-- ============================================
-- Query 15 - Buyer Opportunity Index
-- Analysis Period: May 2016–May 2026
-- Excluded Cities: Fairview, Lantana, Perrin
-- Business Question:
-- Which DFW cities provide the best balance
-- of affordability and appreciation?
-- Method:
-- Buyer Opportunity Score = Affordability Rank
-- + Appreciation Rank. Lower score is better.
-- ============================================

CREATE OR REPLACE VIEW
`project-d3acdc67-4760-439a-b6d.dfw_housing_analysis.vw_buyer_opportunity_index`
AS

WITH endpoint_values AS (

    SELECT
        region_id,
        City,
        County,

        MAX(
            CASE
                WHEN Observation_Date = DATE '2016-05-31'
                THEN Home_Value
            END
        ) AS Starting_Home_Value,

        MAX(
            CASE
                WHEN Observation_Date = DATE '2026-05-31'
                THEN Home_Value
            END
        ) AS Current_Home_Value,

        COUNTIF(
            Observation_Date = DATE '2016-05-31'
        ) AS Starting_Observation_Count,

        COUNTIF(
            Observation_Date = DATE '2026-05-31'
        ) AS Current_Observation_Count

    FROM
        `project-d3acdc67-4760-439a-b6d.dfw_housing_analysis.housing_data`

    WHERE
        City NOT IN ('Fairview', 'Lantana', 'Perrin')
        AND Observation_Date IN (
            DATE '2016-05-31',
            DATE '2026-05-31'
        )

    GROUP BY
        region_id,
        City,
        County
),

metrics AS (

    SELECT
        region_id,
        City,
        County,
        Current_Home_Value,

        SAFE_DIVIDE(
            Current_Home_Value - Starting_Home_Value,
            Starting_Home_Value
        ) * 100 AS Appreciation_Percent

    FROM endpoint_values

    WHERE
        Starting_Observation_Count > 0
        AND Current_Observation_Count > 0
        AND Starting_Home_Value > 0
        AND Current_Home_Value IS NOT NULL

),

ranked AS (

    SELECT
        region_id,
        City,
        County,
        ROUND(Current_Home_Value, 0) AS Current_Home_Value,
        ROUND(Appreciation_Percent, 2) AS Appreciation_Percent,

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
        region_id,
        City,
        County,
        Current_Home_Value,
        Appreciation_Percent,
        Affordability_Rank,
        Appreciation_Rank,

        Affordability_Rank + Appreciation_Rank
            AS Buyer_Opportunity_Score

    FROM ranked

)

SELECT
    DENSE_RANK() OVER (
        ORDER BY Buyer_Opportunity_Score ASC
    ) AS Buyer_Opportunity_Rank,

    City,
    County,
    Current_Home_Value,
    Appreciation_Percent,
    Affordability_Rank,
    Appreciation_Rank,
    Buyer_Opportunity_Score

FROM buyer_scores;
