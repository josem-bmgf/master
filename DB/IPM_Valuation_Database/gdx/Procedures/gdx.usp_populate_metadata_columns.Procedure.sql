CREATE PROCEDURE [gdx].[usp_populate_metadata_columns]
	--@table_name varchar(max)
	@table_id int
AS
BEGIN

	--DECLARE @table_id INT

--Adding code to find table id using table name parameter that was passed into proc.
/*	IF (select id from gdx.metadata_tables where dst_tbl_name = @table_name) != 0
	BEGIN
		SET @table_id = (select id from gdx.metadata_tables where dst_tbl_name = @table_name)
	END

	ELSE  
		PRINT 'SQL table name provided does not exist in the gdx.metadata_tables table.  Please check the name again.'
		RETURN*/
	
	;WITH c AS (
		SELECT
			s.[name] AS [schema_name],
			t.[name] AS [table_name],
			c.[name] AS [column_name],
			c.column_id,
			(CASE WHEN pk_i_c.column_id IS NULL THEN 0 ELSE 1 END) AS is_pk
		FROM
			sys.columns AS c
				INNER JOIN
				(SELECT [schema_id], [object_id], [name] FROM sys.tables
				 UNION ALL
				 SELECT [schema_id], [object_id], [name] FROM sys.views) AS t ON c.object_id = t.object_id
					INNER JOIN
					sys.schemas AS s ON t.schema_id = s.schema_id

				LEFT JOIN
				(sys.key_constraints AS pk 
					INNER JOIN
					sys.indexes AS pk_i ON pk.unique_index_id = pk_i.index_id AND pk_i.[object_id] = pk.parent_object_id
						INNER JOIN
						sys.index_columns AS pk_i_c ON pk_i.object_id = pk_i_c.object_id AND pk_i.index_id = pk_i_c.index_id) ON 
							t.[object_id] = pk.parent_object_id AND
							pk.type = 'PK' AND
							pk.parent_object_id = t.[object_id] AND
							pk_i_c.column_id = c.column_id
		WHERE
			c.is_identity = 0
	)
	SELECT
		mt.src_schema,
		mt.dst_schema,
		mt.src_tbl_name,
		mt.dst_tbl_name,
		c_s.column_name,
		c_t.column_name,
		c_t.is_pk
	FROM
		gdx.metadata_tables AS mt
			INNER JOIN
			c AS c_s ON mt.src_schema = c_s.schema_name AND mt.src_tbl_name = c_s.table_name
				INNER JOIN
				c AS c_t ON c_s.column_name = c_t.column_name AND mt.dst_schema = c_t.schema_name AND mt.dst_tbl_name = c_t.table_name
	WHERE
		mt.id = @table_id
	ORDER BY
		c_t.column_id

END
GO

