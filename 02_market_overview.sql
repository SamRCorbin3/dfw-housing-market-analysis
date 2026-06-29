Query 2 – Distinct Cities

Business Question:

How many unique DFW cities are included in the dataset?

-- ============================================
-- Query 02 - Distinct Cities
-- Business Question:
-- How many unique cities are represented?
-- ============================================

SELECT
    COUNT(DISTINCT RegionName) AS total_cities
FROM housing_data;

180