Query 5 – Average Home Value

Business Question:

What is the average home value across all observations?
-- ============================================
-- Query 05 - Average Home Value
-- Business Question:
-- What is the average home value in the dataset?
-- ============================================

SELECT
    ROUND(AVG(Home_Value), 0) AS average_home_value
FROM housing_data;