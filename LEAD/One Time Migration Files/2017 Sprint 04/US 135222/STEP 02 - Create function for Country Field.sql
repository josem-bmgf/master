-- [2017 Sprint 04] US 135222 - LEAD - Change Country field to multi-select 
-- Create a function to have the country field a multi-values.

USE [LEAD]
GO

CREATE FUNCTION [dbo].[ufnGetCountriesByEngagementId]
(
	@engagementId int
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Countries VARCHAR(MAX)
	
		SELECT @Countries = COALESCE(@Countries + ', ', '') + c.Country
		FROM [dbo].[EngagementCountry] ec
		LEFT JOIN [dbo].Country c on c.Id = ec.CountryFk
		Where ec.EngagementFK = @engagementId

	RETURN @Countries
END

GO