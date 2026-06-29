Query 4 – Home Value Range

Business Question:

What are the minimum and maximum home values in the dataset?

-- ============================================
-- Query 04 - Home Value Range
-- Business Question:
-- What is the range of home values?
-- ============================================

SELECT
    ROUND(MIN(HomeValue), 0) AS minimum_home_value,
    ROUND(MAX(HomeValue), 0) AS maximum_home_value
FROM housing_data;
