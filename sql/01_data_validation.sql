-- ============================================
-- Query 01 - Record Count
-- Business Question:
-- How many records are in the cleaned dataset?
-- ============================================

SELECT 
COUNT(DISTINCT city) AS total_cities
FROM `project-d3acdc67-4760-439a-b6d.dfw_housing_analysis.housing_data`
