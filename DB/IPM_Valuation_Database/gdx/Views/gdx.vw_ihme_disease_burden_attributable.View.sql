/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [gdx].[vw_ihme_disease_burden_attributable] AS
SELECT [country_dimension].id AS country_dimension_id,
t1.ihme_cause_id,
[attributable_fraction].disease_nm as attributable_cause_nm,
concat('cause:',t1.ihme_cause_id,':',attributable_fraction.disease_nm) as variable_nm,
t1.disease_burden_source_nm,
gates_data_exchange_metadata.id AS gates_data_exchange_metadata_id,
t1.sex_nm,
t1.age_group_nm,
t1.age_nr,
CAST(t1.year_nm AS float) AS year_nr,
t1.disease_burden_scenario_nm AS 'scenario',
measure_dimension.id AS measure_dimension_id,
measure_format_dimension.id AS measure_format_dimension_id,
CASE 
WHEN disease_burden_measure_nm = 'Deaths' then CAST(t1.disease_burden_measure_point_estimate_value_qty*death_attributable_pct AS decimal(18,6)) 
WHEN disease_burden_measure_nm = 'Incidence' then CAST(t1.disease_burden_measure_point_estimate_value_qty*incidence_attributable_pct AS decimal(18,6)) 
END AS measure_point_estimate,

CASE 
WHEN disease_burden_measure_nm = 'Deaths' then CAST(t1.disease_burden_measure_upper_value_qty*death_attributable_pct AS decimal(18,6)) 
WHEN disease_burden_measure_nm = 'Incidence' then CAST(t1.disease_burden_measure_upper_value_qty*incidence_attributable_pct AS decimal(18,6)) 
END AS measure_upper_value,

CASE 
WHEN disease_burden_measure_nm = 'Deaths' then CAST(t1.disease_burden_meaure_lower_value_qty*death_attributable_pct AS decimal(18,6)) 
WHEN disease_burden_measure_nm = 'Incidence' then CAST(t1.disease_burden_meaure_lower_value_qty*incidence_attributable_pct AS decimal(18,6)) 
END AS measure_lower_value

FROM (select * from [staging].[ihme_disease_burden] where disease_burden_measure_nm in ('Deaths','Incidence') and disease_burden_metric_nm = 'Number' and ihme_cause_id in (select distinct ihme_cause_id from staging.ihme_attributable_fraction)) t1
INNER JOIN [gdx].[country_dimension] AS [country_dimension] ON [country_dimension].ihme_location_cd = t1.ihme_location_id
INNER JOIN gdx.gates_data_exchange_metadata AS [gates_data_exchange_metadata] ON [gates_data_exchange_metadata].gdx_resource_id = t1.gates_data_exchange_metadata_id
INNER JOIN gdx.measure_dimension AS [measure_dimension] ON measure_dimension.measure_nm = t1.disease_burden_measure_nm
INNER JOIN gdx.measure_format_dimension AS measure_format_dimension ON measure_format_dimension.measure_format_nm = t1.disease_burden_metric_nm
INNER JOIN staging.ihme_attributable_fraction AS [attributable_fraction] on t1.ihme_cause_id = [attributable_fraction].ihme_cause_id and t1.age_nr = [attributable_fraction].age_nr

Where attributable_fraction.disease_nm = 'Rotavirus'