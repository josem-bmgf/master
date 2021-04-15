-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/26/2016
-- Description:	Get blackout dates
-- =============================================
CREATE PROCEDURE [app].[uspGetBlackoutDates]
(
	 @LeaderFk	INT
	,@DateFrom	DATETIME
	,@DateTo	DATETIME
)
AS
BEGIN

DECLARE	@rtn	VARCHAR(8000);

SET @rtn = '';

SELECT @rtn = @rtn + CONVERT(VARCHAR(10), [DateFrom], 101) + ':' + [ScheduleComment] + '~'
	FROM [dbo].[Schedule]
	WHERE   [EngagementFk] = 1000 -- Engagement for Blackout date
		AND [LeaderFk]	= @LeaderFk
		AND [DateFrom] = [DateTo]
		AND @DateFrom <= [DateFrom] 
		AND	[DateFrom] < @DateTo;

SELECT @rtn;

END;