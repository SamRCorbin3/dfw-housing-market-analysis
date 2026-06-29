Query 7 – Average Home Value by County

Business Question:

What is the average home value for each county?
-- ============================================
-- Query 07 - Average Home Value by County
-- Business Question:
-- What is the average home value by county?
-- ============================================

SELECT
    county,
    ROUND(AVG(home_value),2) AS average_home_value
FROM housing_data
GROUP BY county
ORDER BY average_home_value DESC;
