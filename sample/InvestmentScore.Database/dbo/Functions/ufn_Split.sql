CREATE FUNCTION [dbo].[ufn_Split]
   (@RepParam NVARCHAR(max), @Delim CHAR(1)= ',')
RETURNS @Values TABLE (Item NVARCHAR(100))AS
  BEGIN
  DECLARE @chrind INT
  DECLARE @Piece NVARCHAR(100)
  SELECT @chrind = 1 
  WHILE @chrind > 0
    BEGIN
      SELECT @chrind = CHARINDEX(@Delim,@RepParam)
      IF @chrind  > 0
        SELECT @Piece = LEFT(@RepParam,@chrind - 1)
      ELSE
        SELECT @Piece = @RepParam
      INSERT  @Values(Item) VALUES(@Piece)
      SELECT @RepParam = RIGHT(@RepParam,LEN(@RepParam) - @chrind)
      IF LEN(@RepParam) = 0 BREAK
    END
  RETURN
  END
GO


