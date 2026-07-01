-- ============================================
-- Query 16 - County Performance
-- Business Question:
-- Which DFW cities provide the best balance
-- of affordability and appreciation?
-- ============================================
WITH county_metrics AS (
    SELECT
        County,

        AVG(`Current_Home_Value`) AS avg_home_value,

        AVG(`Appreciation_Percent`) AS avg_appreciation,

        AVG(`Buyer_Opportunity_Score`) AS avg_buyer_score

    FROM `project-d3acdc67-4760-439a-b6d.dfw_housing_analysis.vw_buyer_opportunity_index`

    GROUP BY County
),

county_rankings AS (

SELECT

County,

ROUND(avg_home_value,2) AS Average_Home_Value,

RANK() OVER (
ORDER BY avg_home_value DESC
) AS Home_Value_Rank,

ROUND(avg_appreciation,2) AS Average_Appreciation,

RANK() OVER (
ORDER BY avg_appreciation DESC
) AS Appreciation_Rank,

ROUND(avg_buyer_score,2) AS Average_Buyer_Opportunity_Score,

RANK() OVER (
ORDER BY avg_buyer_score DESC
) AS Buyer_Opportunity_Rank

FROM county_metrics

)

SELECT

County,

Average_Home_Value,

Home_Value_Rank,

Average_Appreciation,

Appreciation_Rank,

Average_Buyer_Opportunity_Score,

Buyer_Opportunity_Rank,

ROUND(
(Home_Value_Rank +
Appreciation_Rank +
Buyer_Opportunity_Rank)
/3,2) AS County_Performance_Score,

RANK() OVER (

ORDER BY
(Home_Value_Rank +
 Appreciation_Rank +
 Buyer_Opportunity_Rank)/3 ASC

) AS Overall_Rank

FROM county_rankings

ORDER BY Overall_Rank;