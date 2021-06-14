CREATE VIEW gdx.vw_cause_dimension
AS
SELECT 
ihme_cause_id,
[ihme_gbd_2016_cause_nm] AS ihme_cause_nm
FROM staging.cause_dimension
