-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/26/2016
-- Description:	Get blackout dates
-- =============================================
CREATE PROCEDURE [app].[uspGetScheduledDates]
(
	 @LeaderFk	INT
	,@DateFrom	DATETIME
	,@DateTo	DATETIME
)
AS
BEGIN

DECLARE	@rtn	VARCHAR(8000);

SET @rtn = '';

SELECT @rtn = @rtn + CONVERT(VARCHAR(10), [ScheduleFromDate], 101) + ':' 
				   + CONVERT(VARCHAR(10), CASE WHEN @DateTo < [ScheduleToDate] 
											   THEN DATEADD(SS,-1,@DateTo)
											   ELSE [ScheduleToDate] END, 101) + ':' 
		           + CASE WHEN [IsExternal] = 1 THEN 'E' ELSE 'I' END + ':'
				   + REPLACE([Title], '~', '') + '~'
	FROM [dbo].[vEngagementLeaderSchedule]
	WHERE 1=1
		AND  [ScheduleEngagementFk] >= 1000000
--		AND [ScheduleApprovalStatus] = 'A'
		AND [ScheduleLeaderFk]	= @LeaderFk
		AND @DateFrom <= [ScheduleFromDate] 
		AND	[ScheduleFromDate] <= @DateTo;

SELECT @rtn;

END;