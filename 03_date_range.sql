Query 3 – Date Range

Business Question:

What is the time span covered by the dataset?

-- ============================================
-- Query 03
-- Date Range
-- Business Question:
-- What is the earliest and latest date available?
-- ============================================

SELECT
    MIN(Date) AS earliest_date,
    MAX(Date) AS latest_date
FROM housing_data;