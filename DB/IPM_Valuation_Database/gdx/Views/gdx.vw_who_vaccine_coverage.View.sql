CREATE VIEW [gdx].[vw_who_vaccine_coverage] AS
SELECT
[country_dimension].id AS country_dimension_id,
[gates_data_exchange_metadata].id AS gates_data_exchange_metadata_id,
t1.vaccine_nm as proxy_nm,
concat('proxy:',t1.vaccine_nm) as variable_nm,
CAST(t1.year_nm AS float) AS year_nr,
[measure_dimension].id AS measure_dimension_id,
[measure_format_dimension].id AS measure_format_dimension_id,

t1.vaccine_coverage_qty/100 AS 'measure_point_estimate'
FROM [staging].[who_vaccine_coverage] t1
INNER JOIN [gdx].[country_dimension] AS [country_dimension] ON [country_dimension].iso_country_cd = t1.iso_country_cd
INNER JOIN gdx.gates_data_exchange_metadata AS [gates_data_exchange_metadata] ON [gates_data_exchange_metadata].gdx_resource_id = t1.gates_data_exchange_metadata_id
CROSS JOIN gdx.measure_dimension AS [measure_dimension]
CROSS JOIN gdx.measure_format_dimension AS [measure_format_dimension]
WHERE [measure_dimension].measure_nm = 'Coverage'
AND [measure_format_dimension].measure_format_nm = 'Proportion'
GO