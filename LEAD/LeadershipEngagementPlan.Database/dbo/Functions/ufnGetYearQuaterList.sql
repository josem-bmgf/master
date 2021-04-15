-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 05/09/2016
-- Description:	Get Year Quater list.
-- =============================================
CREATE FUNCTION [dbo].[ufnGetYearQuaterList] 
(	
	@Fks VARCHAR(255)
)
RETURNS VARCHAR(255)
AS
BEGIN

	DECLARE @InFks VARCHAR(255);
	DECLARE @List VARCHAR(510);
	DECLARE @FkStr VARCHAR(255);

	DECLARE @i INT;
	DECLARE @l INT;
	DECLARE @Fk INT;

	SET @InFks = LTRIM(RTRIM(@Fks)) +',';
	SET @l = LEN(@InFks);
	SET @List = '';

	WHILE LEN(@InFks) > 0
	BEGIN
		SET @i = CHARINDEX(',',@InFks);
		SET @FkStr = SUBSTRING(@InFks, 1, @i - 1);
		SET @InFks = SUBSTRING(@InFks, @i + 1, @l-@i) 
		SET @l = LEN(@InFks);

		SET @Fk = CAST(@FkStr AS INT);
		IF @Fk > 0 
			SELECT @List = @List + LTRIM(RTRIM([Display])) + ', '
				FROM [dbo].[YearQuarter]
				WHERE [Id] = @Fk;
	END

	SET @l = LEN(@List)
	
	IF SUBSTRING(@List, @l, 1) = ','
		SET @List = SUBSTRING(@List, 1, @l-1);

	RETURN @List;

END