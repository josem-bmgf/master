-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/26/2016
-- Description:	Set blackout dates
-- =============================================
CREATE PROCEDURE [app].[uspSetBlackoutDates]
(
	 @LeaderFk	INT
	,@Year		INT
	,@Dates		VARCHAR(MAX)
	,@SysUserFk	INT
)
AS
BEGIN

DECLARE @Err INT;
DECLARE	@p INT;
DECLARE @DateList	VARCHAR(MAX);
Declare @T			VARCHAR(MAX);
DECLARE @Date		VARCHAR(10);
DECLARE @Comment	VARCHAR(MAX);

DECLARE @fd		DATETIME;
DECLARE @td		DATETIME;

DECLARE @List TABLE ([EngagementFk] INT
					,[LeaderFK]		INT
					,[DateFrom]		DATETIME
					,[DateTo]		DATETIME
					,[Comment]		VARCHAR(MAX));


BEGIN TRY
	SET @fd = CAST('1/1/' + LTRIM(RTRIM(STR(@Year))) AS DATETIME);
	SET @td = CAST('1/1/' + LTRIM(RTRIM(STR(@Year+1))) AS DATETIME);
	SET @DateList = @Dates;
	WHILE CHARINDEX('-', @DateList) > 0
	BEGIN
		SET @p  = CHARINDEX('-', @DateList);
		SET @T = SUBSTRING(@DateList, 1, @p-1);
		SET @Date = SUBSTRING(@T, 1, 10);
		SET @Comment = SUBSTRING(@T, 12, LEN(@T) - 11);

		IF LEN(@Date) > 0
			INSERT @List
			SELECT 1000, @LeaderFk, CAST(@Date AS DATETIME), CAST(@Date AS DATETIME), @Comment;

		SET @DateList = SUBSTRING(@DateList, @p+1, LEN(@DateList)-@p);
	END
	SET @Err = 0;
	BEGIN TRY

		WITH mergeTarget as 
		( 
			SELECT *	
				FROM [dbo].[Schedule]
				WHERE	[EngagementFk] = 1000
					AND	[LeaderFK]	= @LeaderFk
					AND @fd <= [DateFrom]
					AND [DateFrom] < @td
					AND @fd <= [DateTo]
					AND [DateTo] < @td
		) 
		MERGE mergeTarget s
		USING @List l
			ON		s.[EngagementFk]= l.[EngagementFk]
				AND s.[LeaderFK]	= l.[LeaderFK]
				AND s.[DateFrom]	= l.[DateFrom]
				AND s.[DateTo]		= l.[DateTo]
			WHEN MATCHED AND s.[ScheduleComment] != l.[Comment] THEN
				UPDATE SET s.[ScheduleComment] = l.[Comment]
			WHEN NOT MATCHED BY TARGET THEN
				INSERT ([EngagementFk], [LeaderFK], [DateFrom],   [DateTo],   [ScheduleComment], [ScheduledByFk], [ScheduledDate],
						[ApproveDecline], [ReviewComment], [ReviewCompletedByFk], [ReviewCompletedDate])
				VALUES (1000,			@LeaderFk,  l.[DateFrom], l.[DateTo], l.[Comment],		 @SysUserFk,     GETDATE(),
						'A',			  '',			   @SysUserFk,			GETDATE())
			WHEN NOT MATCHED BY SOURCE THEN
				DELETE;
		SET @Err = 0;
	END TRY
	BEGIN CATCH
		SET @Err = 2;
	END CATCH
END TRY
BEGIN CATCH
	SET @Err = 1;
END CATCH	

SELECT @Err;

END;