
CREATE VIEW [gdx].[vw_ihme_disease_burden] AS
SELECT
[country_dimension].id AS country_dimension_id,
t1.ihme_cause_id,
NULL as attributable_cause_nm,
concat('cause:',t1.ihme_cause_id) as variable_nm,
t1.disease_burden_source_nm,
gates_data_exchange_metadata.id AS gates_data_exchange_metadata_id,
t1.sex_nm,
t1.age_group_nm,
t1.age_nr,
CAST(t1.year_nm AS float) AS year_nr,
t1.disease_burden_scenario_nm AS 'scenario',
measure_dimension.id AS measure_dimension_id,
measure_format_dimension.id AS measure_format_dimension_id,
CAST(t1.disease_burden_measure_point_estimate_value_qty AS decimal(18,6)) AS measure_point_estimate,
CAST(t1.disease_burden_measure_upper_value_qty AS decimal(18,6)) AS measure_upper_value,
CAST(t1.disease_burden_meaure_lower_value_qty AS decimal(18,6)) AS measure_lower_value
FROM [staging].[ihme_disease_burden] t1
INNER JOIN [gdx].[country_dimension] AS [country_dimension] ON [country_dimension].ihme_location_cd = t1.ihme_location_id
INNER JOIN gdx.gates_data_exchange_metadata AS [gates_data_exchange_metadata] ON [gates_data_exchange_metadata].gdx_resource_id = t1.gates_data_exchange_metadata_id
INNER JOIN
	(SELECT DISTINCT
	disease_burden_measure_nm,
	(CASE
		WHEN disease_burden_measure_nm = 'DALYs (Disability-Adjusted Life Years)' THEN 'DALYs'
		WHEN disease_burden_measure_nm = 'YLDs (Years Lived with Disability)' THEN 'YLDs'
		WHEN disease_burden_measure_nm = 'YLLs (Years of Life Lost)' THEN 'YLLs'
		ELSE disease_burden_measure_nm
	END) AS disease_burden_measure_nm_cleaned
	FROM [staging].[ihme_disease_burden]) t4 ON t4.disease_burden_measure_nm = t1.disease_burden_measure_nm
INNER JOIN gdx.measure_dimension AS [measure_dimension] ON measure_dimension.measure_nm = t4.disease_burden_measure_nm_cleaned
INNER JOIN
	(SELECT DISTINCT
	disease_burden_metric_nm,
	(CASE
		WHEN disease_burden_metric_nm = 'Rate' THEN 'Fraction'
		ELSE disease_burden_metric_nm
	END) AS disease_burden_metric_nm_cleaned
	FROM [staging].[ihme_disease_burden]) t5 ON t5.disease_burden_metric_nm = t1.disease_burden_metric_nm
INNER JOIN gdx.measure_format_dimension AS measure_format_dimension ON measure_format_dimension.measure_format_nm = t5.disease_burden_metric_nm_cleaned
GO