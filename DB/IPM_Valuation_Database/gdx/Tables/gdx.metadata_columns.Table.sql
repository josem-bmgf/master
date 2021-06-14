CREATE TABLE [gdx].[metadata_columns]
(
	id INT IDENTITY(1, 1) PRIMARY KEY,
	src_schema SYSNAME,
	dst_schema SYSNAME,
	src_tbl_name SYSNAME,
	dst_tbl_name SYSNAME,
	src_column SYSNAME,
	dst_column SYSNAME,
	is_pk BIT
);
