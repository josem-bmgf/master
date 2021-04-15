ALTER FUNCTION [dbo].[ufnGetAllYearQuarterByEngagementId]
(
	@engagementId INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
		DECLARE @YearQuarterOfAnEngagement VARCHAR(MAX)

		SELECT @YearQuarterOfAnEngagement = COALESCE(@YearQuarterOfAnEngagement + ', ', '') + yq.Display 
		FROM [dbo].[EngagementYearQuarter] eq 
		LEFT JOIN [dbo].[YearQuarter] yq on eq.YearQuarterFk = yq.id
		Where EngagementFK = @engagementId

	RETURN @YearQuarterOfAnEngagement

END