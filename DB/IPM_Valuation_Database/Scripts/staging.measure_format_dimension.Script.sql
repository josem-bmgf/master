TRUNCATE TABLE staging.measure_format_dimension;
GO

INSERT INTO staging.measure_format_dimension
SELECT 'Probability' AS measure_format_nm UNION ALL
SELECT 'Duration' UNION ALL
SELECT 'Number' UNION ALL
SELECT 'Fraction' UNION ALL
SELECT 'Proportion'
GO