CREATE VIEW [gdx].[vw_united_nations_birth_rates] AS
SELECT 
[country_dimension].id AS country_dimension_id
 ,gates_data_exchange_metadata.id AS gates_data_exchange_metadata_id
 ,CAST(t1.year_nm AS float) AS year_nr
 ,[measure_dimension].id AS measure_dimension_id
,[measure_format_dimension].id AS measure_format_dimension_id
,t1.measure_point_estimate
FROM (
SELECT iso_country_cd
, [gates_data_exchange_metadata_id]
      ,[year_nm]
	, measure_nm = 'Births'
	, case when measure_nm = 'births_qty' then 'Number' else 'Fraction' end metric_nm 
	, measure_point_estimate
  FROM [staging].[united_nations_birth_rates]
  CROSS APPLY (
  VALUES ('births_qty', [births_qty]), ('crude_birth_rate_pct',[crude_birth_rate_pct])
  )
  x(measure_nm, measure_point_estimate)
 
  ) t1
  INNER JOIN [gdx].[country_dimension] AS [country_dimension] ON [country_dimension].iso_country_cd = t1.iso_country_cd
INNER JOIN gdx.gates_data_exchange_metadata AS [gates_data_exchange_metadata] ON [gates_data_exchange_metadata].gdx_resource_id = t1.gates_data_exchange_metadata_id
INNER JOIN gdx.measure_dimension AS [measure_dimension] ON measure_dimension.measure_nm = t1.measure_nm
INNER JOIN gdx.measure_format_dimension AS measure_format_dimension ON measure_format_dimension.measure_format_nm = t1.metric_nm