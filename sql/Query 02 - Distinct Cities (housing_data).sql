-- ============================================
-- Query 02 - Distinct Cities
-- Business Question:
-- How many unique cities are represented?
-- ============================================

SELECT  
COUNT(DISTINCT City) AS total_cities
FROM `project-d3acdc67-4760-439a-b6d.dfw_housing_analysis.housing_data`
