Query 6 – Cities by County

Business Question:

How many cities from each county are represented in the dataset?
-- ============================================
-- Query 06 - Cities by County
-- Business Question:
-- How many cities belong to each county?
-- ============================================

SELECT
    county,
    COUNT(DISTINCT city) AS total_cities
FROM housing_data
GROUP BY county
ORDER BY total_cities DESC;