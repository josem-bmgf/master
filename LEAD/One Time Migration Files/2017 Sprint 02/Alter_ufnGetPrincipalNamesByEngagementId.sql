ALTER FUNCTION [dbo].[ufnGetPrincipalNamesByEngagementId]
(
	@engagementId int,
	@principalType int
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Names VARCHAR(MAX)
	
		SELECT @Names = COALESCE(@Names + ', ', '') + l.ShortName
		FROM [dbo].Principal p 
		LEFT JOIN [dbo].Leader l on l.Id = p.LeaderFK
		Where p.EngagementFK = @engagementId AND p.TypeFK = @principalType

	RETURN @Names
END
