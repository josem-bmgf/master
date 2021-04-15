-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/26/2016
-- Description:	Update YearQuarter Table
-- =============================================
CREATE PROCEDURE [app].[uspUpsertYearQuarter]
AS
BEGIN

DECLARE @YYYY INT
DECLARE @EndYYYY INT

SELECT @YYYY = MAX([YEAR]),  @EndYYYY = MAX([YEAR]) + 1 + 10
FROM(
		SELECT MAX([YEAR]) [YEAR] FROM [dbo].[YearQuarter]
		UNION
		SELECT DATEPART(YEAR, GETDATE()) - 1
	) a;

WHILE @YYYY < @EndYYYY
BEGIN
	SET @YYYY = @YYYY + 1;
	INSERT [dbo].[YearQuarter] (Id, Year, Quarter, Display) VALUES (@YYYY * 100 + 1, @YYYY, CAST(1 AS TINYINT), LTRIM(RTRIM(STR(@YYYY))) + ' - Q1');
	INSERT [dbo].[YearQuarter] (Id, Year, Quarter, Display) VALUES (@YYYY * 100 + 2, @YYYY, CAST(2 AS TINYINT), LTRIM(RTRIM(STR(@YYYY))) + ' - Q2');
	INSERT [dbo].[YearQuarter] (Id, Year, Quarter, Display) VALUES (@YYYY * 100 + 3, @YYYY, CAST(3 AS TINYINT), LTRIM(RTRIM(STR(@YYYY))) + ' - Q3');
	INSERT [dbo].[YearQuarter] (Id, Year, Quarter, Display) VALUES (@YYYY * 100 + 4, @YYYY, CAST(4 AS TINYINT), LTRIM(RTRIM(STR(@YYYY))) + ' - Q4');

END

END;