CREATE TABLE [gdx].[metadata_tables]
(
	id INT IDENTITY(1, 1) PRIMARY KEY,
	src_schema SYSNAME,
	dst_schema SYSNAME,
	src_tbl_name SYSNAME,
	dst_tbl_name SYSNAME,
	dimension_type INT
);