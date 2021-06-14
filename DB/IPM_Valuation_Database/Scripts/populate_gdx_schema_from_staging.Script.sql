SET NOCOUNT ON


DECLARE @table_id INT

DECLARE tables_cursor CURSOR
FOR
	SELECT id FROM gdx.metadata_tables ORDER BY id

OPEN tables_cursor

FETCH NEXT FROM tables_cursor INTO @table_id

WHILE (@@FETCH_STATUS = 0)
BEGIN

	EXEC [gdx].[usp_merge_from_stg_to_gdx] @table_id

	FETCH NEXT FROM tables_cursor INTO @table_id

END

CLOSE tables_cursor
DEALLOCATE tables_cursor

