CREATE VIEW [gdx].[vw_health_adjusted_life_expectancy] AS
SELECT
[country_dimension].id AS country_dimension_id,
t1.sex_nm,
[gates_data_exchange_metadata].id AS gates_data_exchange_metadata_id,
t1.age_group_nm,
t1.age_nr,
CAST(t1.year_nm AS float) AS year_nr,
[measure_dimension].id AS measure_dimension_id,
[measure_format_dimension].id AS measure_format_dimension_id,
t1.variable_nm,
t1.hale_qty AS 'measure_point_estimate'
FROM [staging].health_adjusted_life_expectancy t1
INNER JOIN [gdx].[country_dimension] AS [country_dimension] ON [country_dimension].iso_country_cd = t1.iso_country_cd
INNER JOIN gdx.gates_data_exchange_metadata AS [gates_data_exchange_metadata] ON [gates_data_exchange_metadata].gdx_resource_id = t1.gates_data_exchange_metadata_id
CROSS JOIN gdx.measure_dimension AS [measure_dimension]
CROSS JOIN gdx.measure_format_dimension AS [measure_format_dimension]
WHERE [measure_dimension].measure_nm = 'HALE'
AND ((variable_nm is not null AND [measure_format_dimension].measure_format_nm = 'Number') OR (variable_nm is null AND [measure_format_dimension].measure_format_nm = 'Duration'))
GO