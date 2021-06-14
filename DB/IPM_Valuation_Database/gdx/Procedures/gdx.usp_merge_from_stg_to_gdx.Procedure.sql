CREATE PROCEDURE [gdx].[usp_merge_from_stg_to_gdx]
	@table_id int-- varchar(max)
AS
BEGIN

	--DECLARE @table_id INT

--Adding code to find table id using table name parameter that was passed into proc.
/*
	IF (select top 1 id from gdx.metadata_tables where dst_tbl_name = @table_name) != 0
	BEGIN
		SET @table_id = (select top 1 id from gdx.metadata_tables where dst_tbl_name = @table_name)
	END

	ELSE  
		PRINT 'SQL table name provided does not exist in the gdx.metadata_tables table.  Please check the name again.'
		RETURN*/
	DECLARE @sql VARCHAR(MAX) = ''
	
	;WITH metadata_tables AS (
		SELECT * FROM gdx.metadata_tables WHERE id = @table_id
	),
	metadata_columns AS (
		SELECT
			c.*
		FROM
			gdx.metadata_columns AS c
				INNER JOIN
				metadata_tables AS t ON 
					t.dst_schema = c.dst_schema AND
					t.dst_tbl_name = c.dst_tbl_name AND
					t.src_schema = c.src_schema AND
					t.src_tbl_name = c.src_tbl_name
	)
	SELECT @sql = @sql + sql_text FROM (
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		10 AS level1,
		1 AS level2,
		'MERGE INTO' + CHAR(10) AS sql_text
	FROM
		metadata_tables AS t
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		20 AS level1,
		1 AS level2,
		'	[' + dst_schema + '].[' + dst_tbl_name + '] AS target' + CHAR(10)-- + CHAR(13)
	FROM
		metadata_tables AS t
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		30 AS level1,
		1 AS level2,
		'USING' + CHAR(10) AS sql_text
	FROM
		metadata_tables AS t
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		40 AS level1,
		1 AS level2,
		'	[' + src_schema + '].[' + src_tbl_name + '] AS source ON ('
	FROM
		metadata_tables AS t
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		50 AS level1,
		rn AS level2,
		(CASE WHEN rn > 1 THEN ' AND' ELSE '' END) + CHAR(10) + 
		'		[source].[' + src_column + ']  = [target].[' + dst_column + ']'
	FROM
		(SELECT *, ROW_NUMBER() OVER (PARTITION BY dst_schema + dst_tbl_name ORDER BY id) AS rn FROM metadata_columns WHERE is_pk = 1) AS c
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		60 AS level1,
		1 AS level2,
		CHAR(10) + '	)' + CHAR(10)
	FROM
		metadata_tables AS t
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		70 AS level1,
		1 AS level2,
		'WHEN MATCHED AND EXISTS (' + CHAR(10)
	FROM
		(SELECT DISTINCT dst_schema, dst_tbl_name FROM metadata_columns WHERE is_pk = 0) AS c
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		80 AS level1,
		1 AS level2,
		'	SELECT'
	FROM
		(SELECT DISTINCT dst_schema, dst_tbl_name FROM metadata_columns WHERE is_pk = 0) AS c
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		90 AS level1,
		c.rn AS level2,
		(CASE WHEN rn > 1 THEN ',' ELSE '' END) + 
		'[source].[' + src_column + ']'
	FROM
		(SELECT *, ROW_NUMBER() OVER (PARTITION BY dst_schema + dst_tbl_name ORDER BY id) AS rn FROM metadata_columns WHERE is_pk = 0) AS c
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		100 AS level1,
		1 AS level2,
		CHAR(10) + '	EXCEPT' + CHAR(10)
	FROM
		(SELECT DISTINCT dst_schema, dst_tbl_name FROM metadata_columns WHERE is_pk = 0) AS c
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		110 AS level1,
		1 AS level2,
		'	SELECT'
	FROM
		(SELECT DISTINCT dst_schema, dst_tbl_name FROM metadata_columns WHERE is_pk = 0) AS c
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		120 AS level1,
		c.rn AS level2,
		(CASE WHEN rn > 1 THEN ',' ELSE '' END) +
		'[target].[' + dst_column + ']'
	FROM
		(SELECT *, ROW_NUMBER() OVER (PARTITION BY dst_schema + dst_tbl_name ORDER BY id) AS rn FROM metadata_columns WHERE is_pk = 0) AS c
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		130 AS level1,
		1 AS level2,
		CHAR(10) + '	)' + CHAR(10)
	FROM
		(SELECT DISTINCT dst_schema, dst_tbl_name FROM metadata_columns WHERE is_pk = 0) AS c
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		130 AS level1,
		1 AS level2,
		'THEN UPDATE' + CHAR(10) + '	SET'
	FROM
		(SELECT DISTINCT dst_schema, dst_tbl_name FROM metadata_columns WHERE is_pk = 0) AS c
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		140 AS level1,
		c.rn AS level2,
		(CASE WHEN rn > 1 THEN ',' ELSE '' END) + CHAR(10) +
		'		[' + dst_column + '] = [source].[' + src_column + ']' 
	FROM
		(SELECT *, ROW_NUMBER() OVER (PARTITION BY dst_schema + dst_tbl_name ORDER BY id) AS rn FROM metadata_columns WHERE is_pk = 0) AS c
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		150 AS level1,
		1 AS level2,
		CHAR(10) + 'WHEN NOT MATCHED BY TARGET THEN' + CHAR(10) + '	INSERT ('
	FROM
		metadata_tables AS t
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		160 AS level1,
		c.rn AS level2,
		(CASE WHEN rn > 1 THEN ',' ELSE '' END) + CHAR(10) +
		'		[' + dst_column + ']' 
	FROM
		(SELECT *, ROW_NUMBER() OVER (PARTITION BY dst_schema + dst_tbl_name ORDER BY id) AS rn FROM metadata_columns) AS c
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		170 AS level1,
		1 AS level2,
		CHAR(10) + '	)' + CHAR(10) + '	VALUES ('
	FROM
		metadata_tables AS t
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		180 AS level1,
		c.rn AS level2,
		(CASE WHEN rn > 1 THEN ',' ELSE '' END) + CHAR(10) +
		'		[' + dst_column + ']' 
	FROM
		(SELECT *, ROW_NUMBER() OVER (PARTITION BY dst_schema + dst_tbl_name ORDER BY id) AS rn FROM metadata_columns) AS c
	UNION ALL
	SELECT
		dst_schema + dst_tbl_name AS table_name,
		190 AS level1,
		1 AS level2,
		CHAR(10) + '	)' + CHAR(10) + ';' + CHAR(10) + CHAR(10)
	FROM
		metadata_tables AS t



	) AS sq
	ORDER BY
		table_name,
		level1,
		level2

	DECLARE @start_time DATETIME = GETDATE(), @row_modified INT = 0
	EXEC(@sql)

	SELECT @row_modified = @@ROWCOUNT

	SELECT
		'Transferring data from [' + t.src_schema + '].[' + t.src_tbl_name + '] to [' + t.dst_schema + '].[' + t.dst_tbl_name + '] completed. ' + 
		'Time elapsed: ' + CAST(DATEDIFF(second, @start_time, GETDATE()) AS VARCHAR(20)) + ' seconds. Rows modified: ' + CAST(@row_modified AS VARCHAR(20))
	FROM
		gdx.metadata_tables AS t
	WHERE
		id = @table_id

END
GO

