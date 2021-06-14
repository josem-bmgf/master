TRUNCATE TABLE staging.gates_data_exchange_metadata
GO

INSERT
INTO
	staging.gates_data_exchange_metadata (
		gdx_dataset_id,
		ipm_reference_data_type_nm,
		ipm_reference_data_table_nm,
		ipm_reference_data_friendly_nm,
		gdx_dataset_title_nm,
		gdx_dataset_version_nm,
		gdx_resource_id,
		gdx_resource_nm,
		gdx_dataset_current_version_indicator
	)
--un_population record
SELECT
	'359e3131-b63c-48fa-9078-2d3722f9ba29', --AS gdx_dataset_id,
	'population', -- AS ipm_reference_data_type_nm,
	'united_nations_population', -- AS ipm_reference_data_table_nm,
	'UN Population', -- AS ipm_reference_data_friendly_nm
	'UN Population 2018-06-08', -- AS gdx_dataset_title_nm,
	'20180608', -- AS gdx_dataset_version_nm,
	'8feb635f-c0f5-4070-b10a-d82f838a117b', -- AS gdx_resource_id,
	'UN Population 20180608', -- AS gdx_resource_nm,
	1 -- AS gdx_dataset_current_version_indicator
UNION ALL
--un_population record
SELECT
	'0cc3a581-bf4d-46fd-a67d-7fd9102ed26a', --AS gdx_dataset_id,
	'population', --AS ipm_reference_data_type_nm,
	'united_nations_population', --AS ipm_reference_data_table_nm,
	'UN Population', -- AS ipm_reference_data_friendly_nm
	'UN Population 2019-08-01', --AS gdx_dataset_title_nm,
	'20190801', --AS gdx_dataset_version_nm,
	'3990ef76-760b-4613-9252-639b1133a128', --AS gdx_resource_id,
	'UN Population Transformed 20190801', --AS gdx_resource_nm,
	0 --AS gdx_dataset_current_version_indicator
UNION ALL
--ihme_burden record
SELECT
	'666d30f0-108b-4089-b05b-01dfd97cc663', --AS gdx_dataset_id,
	'burden', --AS ipm_reference_data_type_nm,
	'ihme_disease_burden', --AS ipm_reference_data_table_nm,
	'IHME GBD 2016', -- AS ipm_reference_data_friendly_nm
	'IHME GBD 2016 and Future Health Scenarios 2018-09-25', --AS gdx_dataset_title_nm,
	'20180925', --AS gdx_dataset_version_nm,
	'666d30f0-108b-4089-b05b-01dfd97cc663', --AS gdx_resource_id,
	'IHME GBD 2016 and Future Health Scenarios 2018-09-25', --AS gdx_resource_nm,
	1 --AS gdx_dataset_current_version_indicator
UNION ALL
--ihme_population record
SELECT
	'dae84602-97a6-4fe2-a467-f10e82ea243d', --AS gdx_dataset_id,
	'population', --AS ipm_reference_data_type_nm,
	'ihme_population', --AS ipm_reference_data_table_nm,
	'IHME Population', -- AS ipm_reference_data_friendly_nm
	'IHME Population from GBD 2016 Future Scenarios', --AS gdx_dataset_title_nm,
	'20180821', --AS gdx_dataset_version_nm,
	'955f8d54-dde0-41b7-aa8d-d4adb2ff8c48', --AS gdx_resource_id,
	'IHME Population 20180821', --AS gdx_resource_nm,
	1 --AS gdx_dataset_current_version_indicator