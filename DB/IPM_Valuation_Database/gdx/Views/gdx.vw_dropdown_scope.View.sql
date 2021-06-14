CREATE VIEW [gdx].[vw_dropdown_scope] AS

SELECT DISTINCT
gates_data_exchange_metadata_id,
measure_dimension_id,
measure_format_dimension_id,
country_dimension_id,
Null AS cause_id, --999 proxy for NA as cause does not exist with this data
Null as attributable_cause_nm, -- 'NA proxy as attributable cause does not exist with this data
Null as proxy_nm,
Null as variable_nm
FROM gdx.united_nations_population
WHERE measure_point_estimate IS NOT NULL

UNION

SELECT DISTINCT
gates_data_exchange_metadata_id,
measure_dimension_id,
measure_format_dimension_id,
country_dimension_id,
Null AS cause_id, --999 proxy for NA as cause does not exist with this data
Null as attributable_cause_nm, -- 'NA proxy as attributable cause does not exist with this data
Null as proxy_nm,
Null as variable_nm
FROM gdx.united_nations_pregnant_population
WHERE measure_point_estimate IS NOT NULL

UNION

SELECT DISTINCT
gates_data_exchange_metadata_id,
measure_dimension_id,
measure_format_dimension_id,
country_dimension_id,
Null AS cause_id, --Using Null as cause does not exist with this data
Null as attributable_cause_nm, -- 'NA proxy as attributable cause does not exist with this data
Null as proxy_nm,
Null as variable_nm
FROM gdx.ihme_population
WHERE measure_point_estimate IS NOT NULL

UNION

SELECT DISTINCT
gates_data_exchange_metadata_id,
measure_dimension_id,
measure_format_dimension_id,
country_dimension_id,
ihme_cause_id,
attributable_cause_nm,
Null as proxy_nm,
variable_nm
FROM [gdx].[ihme_disease_burden]
WHERE measure_point_estimate IS NOT NULL

UNION

SELECT DISTINCT
gates_data_exchange_metadata_id,
measure_dimension_id,
measure_format_dimension_id,
country_dimension_id,
Null AS cause_id, --Using Null as cause does not exist with this data
Null as attributable_cause_nm, -- Using Null as attributable cause does not exist with this data
Null as proxy_nm,
Null as variable_nm
FROM gdx.united_nations_birth_rates
WHERE measure_point_estimate IS NOT NULL

UNION

SELECT DISTINCT
gates_data_exchange_metadata_id,
measure_dimension_id,
measure_format_dimension_id,
country_dimension_id,
Null AS cause_id, --Using Null as cause does not exist with this data
Null as attributable_cause_nm, -- Using Null as attributable cause does not exist with this data
Null as proxy_nm,
variable_nm as variable_nm
FROM gdx.health_adjusted_life_expectancy
WHERE measure_point_estimate IS NOT NULL

UNION

SELECT DISTINCT
gates_data_exchange_metadata_id,
measure_dimension_id,
measure_format_dimension_id,
country_dimension_id,
Null AS cause_id, --Using Null as cause does not exist with this data
Null as attributable_cause_nm, -- Using Null as attributable cause does not exist with this data
proxy_nm,
variable_nm
FROM gdx.who_vaccine_coverage
WHERE measure_point_estimate IS NOT NULL

UNION

SELECT DISTINCT
gates_data_exchange_metadata_id,
measure_dimension_id,
measure_format_dimension_id,
country_dimension_id,
Null AS cause_id, --Using Null as cause does not exist with this data
Null as attributable_cause_nm, -- Using Null as attributable cause does not exist with this data
proxy_nm,
variable_nm
FROM gdx.ihme_vaccine_coverage
WHERE measure_point_estimate IS NOT NULL
GO
