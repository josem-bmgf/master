-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 07/11/2016
-- Description:	Get aschedule for a Day
-- =============================================
CREATE PROCEDURE [app].[uspGetScheduleForLeadersForADay]
(
	 @LeaderFks		VARCHAR(256)
	,@ScheduleDate	DATETIME
)
AS
BEGIN

	DECLARE @lf VARCHAR(256);
	DECLARE @p INT;
	DECLARE @t table (LeaderFk INT);
	DECLARE @dt DATE;

	SET @dt = CAST(@ScheduleDate AS DATE);

	SET @lf = @LeaderFks;
	SET @p = CHARINDEX(',', @lf, 0);

	WHILE (@p > 0)
	BEGIN
		INSERT @t (LeaderFk)
			SELECT SUBSTRING(@lf, 1, @p - 1);
		SET @lf = SUBSTRING(@lf, @p+1, LEN(@lf) -@p);
		SET @p = CHARINDEX(',', @lf, 0);
	END;

	SELECT 
		 [LeaderShortName]
		,[Status]
		,[ScheduleFromDate]
		,[ScheduleToDate]
		,[Title]
		,[EngagementExtInt]
		FROM [dbo].[vEngagementLeaderSchedule]
		WHERE 1=1 
			AND [ScheduleLeaderFk] IN (SELECT LeaderFk FROM @t)
			AND (
					CAST(ScheduleFromDate AS DATE) = @dt
					OR
					CAST(ScheduleToDate AS DATE) = @dt
					OR
					(ScheduleFromDate <= @Dt AND @DT <= ScheduleToDate)
				)
		ORDER BY [ScheduleFromDate], [LeaderShortName];

END;