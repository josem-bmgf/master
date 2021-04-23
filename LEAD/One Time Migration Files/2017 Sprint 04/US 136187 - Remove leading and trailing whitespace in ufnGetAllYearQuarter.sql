-- [2017 Sprint 04] User Story 136187:LEAD - Remove extra commas (,) in the grid values - Feb 23
-- Updated [ufnGetAllYearQuarterByEngagementId] to remove leading and trailing whitespace

USE [LEAD]
GO

ALTER FUNCTION [dbo].[ufnGetAllYearQuarterByEngagementId]
(
	@engagementId INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
		DECLARE @YearQuarterOfAnEngagement VARCHAR(MAX)

		SELECT @YearQuarterOfAnEngagement = COALESCE(LTRIM(RTRIM(@YearQuarterOfAnEngagement)) + ', ', '') + yq.Display 
		FROM [dbo].[EngagementYearQuarter] eq 
		LEFT JOIN [dbo].[YearQuarter] yq on eq.YearQuarterFk = yq.id
		Where EngagementFK = @engagementId

	RETURN @YearQuarterOfAnEngagement

END