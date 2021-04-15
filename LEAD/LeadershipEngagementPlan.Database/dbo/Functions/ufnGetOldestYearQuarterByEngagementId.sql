CREATE FUNCTION [dbo].[ufnGetOldestYearQuarterByEngagementId]
(
	@engagementId INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @OldestYearQuarter VARCHAR(MAX)

	SET @OldestYearQuarter = (SELECT TOP 1 YearQuarterFk
			FROM [dbo].[EngagementYearQuarter]
			WHERE EngagementFK = @engagementId
			ORDER BY YearQuarterFk DESC)
					
	RETURN @OldestYearQuarter;
END