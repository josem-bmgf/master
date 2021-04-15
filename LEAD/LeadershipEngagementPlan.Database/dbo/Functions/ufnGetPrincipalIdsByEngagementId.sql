CREATE FUNCTION [dbo].[ufnGetPrincipalIdsByEngagementId]
(
	@engagementId int,
	@principalType int
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @MaxCount INTEGER
	DECLARE @Count INTEGER
	DECLARE @Txt VARCHAR(MAX)
	SET @Count = 1
	SET @Txt = ''
	SET @MaxCount = (SELECT MAX(Id) FROM [dbo].[Principal] where TypeFK = @principalType AND EngagementFK = @engagementId) 
	WHILE @Count<=@MaxCount
		BEGIN
		IF @Txt!=''
			SET @Txt=@Txt+',' + (
				SELECT L.Id FROM [dbo].[Principal] P 
				INNER JOIN [dbo].[Leader] L
					ON P.LeaderFK = L.Id 
				WHERE P.Id=@Count
					AND P.EngagementFK = @engagementId
				)
		ELSE
			SET @Txt=(
				SELECT L.Id FROM [dbo].[Principal] P 
				INNER JOIN [dbo].[Leader] L
					ON P.LeaderFK = L.Id 
				WHERE P.Id=@Count
					AND P.EngagementFK = @engagementId
				)
		SET @Count=@Count+1
		END
	
	RETURN @Txt
END

