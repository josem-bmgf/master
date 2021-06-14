CREATE VIEW [gdx].[vw_country_dimension] AS
SELECT 
iso_country_cd,
iso_country_nm,
country_nm AS ipm_country_nm,
ihme_location_cd
FROM
[staging].[country_dimension]
GO