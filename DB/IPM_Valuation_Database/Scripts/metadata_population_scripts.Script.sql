SET NOCOUNT ON

DROP TABLE IF EXISTS #metadata_tables;
CREATE TABLE #metadata_tables (
	id INT IDENTITY(1, 1) PRIMARY KEY,
	src_schema SYSNAME,
	dst_schema SYSNAME,
	src_tbl_name SYSNAME,
	dst_tbl_name SYSNAME,
	dimension_type INT
);

DROP TABLE IF EXISTS #metadata_columns;
CREATE TABLE #metadata_columns (
	id INT IDENTITY(1, 1) PRIMARY KEY,
	src_schema SYSNAME,
	dst_schema SYSNAME,
	src_tbl_name SYSNAME,
	dst_tbl_name SYSNAME,
	src_column SYSNAME,
	dst_column SYSNAME,
	is_pk BIT
);

:r .\metadata_tables.Script.sql

MERGE
INTO
	gdx.metadata_tables AS target
USING
	#metadata_tables AS source ON (
		target.src_schema   = source.src_schema AND
		target.dst_schema   = source.dst_schema AND
		target.src_tbl_name = source.src_tbl_name AND
		target.dst_tbl_name = source.dst_tbl_name 
		)
WHEN MATCHED AND EXISTS (
	SELECT source.dimension_type
	EXCEPT
	SELECT target.dimension_type)
THEN
	UPDATE
	SET
		dimension_type = source.dimension_type
WHEN NOT MATCHED BY TARGET THEN
	INSERT (src_schema, dst_schema, src_tbl_name, dst_tbl_name, dimension_type)
	VALUES (
		source.src_schema,
		source.dst_schema,
		source.src_tbl_name,
		source.dst_tbl_name,
		source.dimension_type
	)
WHEN NOT MATCHED BY SOURCE THEN
	DELETE
;

DECLARE @table_id INT

DECLARE tables_cursor CURSOR
FOR
	SELECT id FROM gdx.metadata_tables

OPEN tables_cursor

FETCH NEXT FROM tables_cursor INTO @table_id

WHILE (@@FETCH_STATUS = 0)
BEGIN

	INSERT INTO #metadata_columns
	EXEC [gdx].[usp_populate_metadata_columns] @table_id

	FETCH NEXT FROM tables_cursor INTO @table_id

END

CLOSE tables_cursor
DEALLOCATE tables_cursor

:r .\metadata_columns.Script.sql

DELETE
	target
FROM
	#metadata_columns AS target
		INNER JOIN
		#metadata_columns AS source ON
			target.src_schema   = source.src_schema AND
			target.dst_schema   = source.dst_schema AND
			target.src_tbl_name = source.src_tbl_name AND
			target.dst_tbl_name = source.dst_tbl_name AND
			target.src_column = source.src_column AND
			target.dst_column = source.dst_column
WHERE
	target.is_pk = 0 AND
	source.is_pk = 1

MERGE
INTO
	gdx.metadata_columns AS target
USING
	#metadata_columns AS source ON (
		target.src_schema   = source.src_schema AND
		target.dst_schema   = source.dst_schema AND
		target.src_tbl_name = source.src_tbl_name AND
		target.dst_tbl_name = source.dst_tbl_name AND
		target.src_column = source.src_column AND
		target.dst_column = source.dst_column
		)
WHEN MATCHED AND EXISTS (
	SELECT source.is_pk
	EXCEPT
	SELECT target.is_pk)
THEN
	UPDATE
	SET
		is_pk = source.is_pk
WHEN NOT MATCHED BY TARGET THEN
	INSERT (src_schema, dst_schema, src_tbl_name, dst_tbl_name, src_column, dst_column, is_pk)
	VALUES (
		source.src_schema,
		source.dst_schema,
		source.src_tbl_name,
		source.dst_tbl_name,
		source.src_column,
		source.dst_column,
		source.is_pk
	)
WHEN NOT MATCHED BY SOURCE THEN
	DELETE
;
