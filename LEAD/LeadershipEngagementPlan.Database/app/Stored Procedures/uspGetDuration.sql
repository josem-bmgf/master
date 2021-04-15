-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 06/02/2016
-- Description:	Get Engagement Duration
-- =============================================
CREATE PROCEDURE [app].[uspGetDuration]
(
	@IsInternalEngagement BIT
)
AS
BEGIN

	SELECT [Id], [Duration], [DurationInMinutes], [DurationInDays]
		FROM (	SELECT 0 'Id', ' --- Select ---' 'Duration',  0 'DurationInMinutes', 0 'DurationInDays'
				UNION
				SELECT [Id], [Duration], [DurationInMinutes], [DurationInDays]
					FROM [dbo].[Duration]
					WHERE	[Status] =1
						AND [IsInternalEngagement] = @IsInternalEngagement ) a
		ORDER BY [DurationInDays], [DurationInMinutes]
END;