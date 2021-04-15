
-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 05/11/2016
-- Description:	Schedule for a given engagement.
-- =============================================
CREATE PROCEDURE [app].[uspGetScheduleIdByEngagementLeader]
(
	 @EngagementFk	INT
	,@LeaderFk	INT
)

AS
BEGIN

DECLARE @Id INT;
DECLARE @IsDeleted BIT;


SET @Id = 0;
SET @IsDeleted = 0;

SELECT @Id = [Id], @IsDeleted=IsDeleted
	FROM [dbo].[Schedule]
	WHERE 1=1
		AND [EngagementFk] = @EngagementFk
		AND [LeaderFk] = @LeaderFk;

SELECT @Id * IIF(@IsDeleted = 1, -1, 1) 'Id';

END;