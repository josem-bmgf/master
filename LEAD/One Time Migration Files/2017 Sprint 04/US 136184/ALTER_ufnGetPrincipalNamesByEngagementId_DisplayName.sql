/****** Object:  UserDefinedFunction [dbo].[ufnGetPrincipalNamesByEngagementId]    Script Date: 3/6/2017 11:29:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[ufnGetPrincipalNamesByEngagementId]
(
	@engagementId int,
	@principalType int
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Names VARCHAR(MAX)
	
		SELECT @Names = COALESCE(@Names + ', ', '') + l.FirstName + ' ' + l.LastName
		FROM [dbo].Principal p 
		LEFT JOIN [dbo].Leader l on l.Id = p.LeaderFK
		Where p.EngagementFK = @engagementId AND p.TypeFK = @principalType

	RETURN @Names
END

GO