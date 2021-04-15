-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 06/13/2016
-- Description:	Approve engagement.
-- =============================================
CREATE PROCEDURE [app].[uspUpsertSchedule]
(
	   @EngagementFk			INT
      ,@LeaderFk				INT
      ,@DateFrom				DATETIME
      ,@DateTo					DATETIME
      ,@TripDirectorFk			INT
      ,@SpeechWriterFk			INT
      ,@CommunicationsLeadFk	INT
      ,@BriefDueToGCEByDate		DATE
      ,@BriefDueToBGC3ByDate	DATE
      ,@ScheduleComment			VARCHAR(MAX)
      ,@ScheduleCommentRtf		VARCHAR(MAX)
      ,@ScheduledByFk			INT
)
AS
BEGIN

DECLARE @Err INT;
DECLARE @Ok INT;
DECLARE	@Id	INT;

SELECT @Ok = MAX(CAST(sgup.[SysAdmin] AS INT) + CAST(sgup.[AppAdmin] AS INT))	
		FROM [dbo].[SysGroupUserPrivilege] sgup
		JOIN [dbo].[SysUser] su ON sgup.SysUserFK = su.Id
		JOIN [dbo].[SysGroup] sg ON sgup.SysGroupFK = sg.Id
		WHERE 1=1
			AND su.[ADUser] = SYSTEM_USER
			AND su.[Status] = 1
			AND sg.[Status] = 1
			AND sgup.[Status] = 1
			AND ( 
					(sgup.SysGroupFK IN (1000, 1001))
				);

IF @Ok < 1 
	SET @Err = 1000;
ELSE
BEGIN
	
SET @Id = 0;
SELECT @Id = [Id] 
	FROM [dbo].[Schedule]
	WHERE 1=1
		AND [EngagementFk] = @EngagementFk
		AND [LeaderFk] = @LeaderFk;
	
IF @Id = 0	-- Adding a new cecord 
BEGIN
    BEGIN TRY
		INSERT [dbo].[Schedule]
				([EngagementFk],[LeaderFk],[DateFrom],[DateTo]
				,[TripDirectorFk],[SpeechWriterFk],[CommunicationsLeadFk]
				,[BriefDueToGCEByDate],[BriefDueToBGC3ByDate]
				,[ScheduleComment],[ScheduleCommentRtf],[ScheduledByFk],[ScheduledDate]
				,[ApproveDecline],[ReviewComment],[ReviewCommentRtf],[ReviewCompletedByFk],[ReviewCompletedDate]
				,[IsDeleted])
		VALUES	(@EngagementFk, @LeaderFk, @DateFrom, @DateTo
				,@TripDirectorFk, @SpeechWriterFk, @CommunicationsLeadFk
				,@BriefDueToGCEByDate, @BriefDueToBGC3ByDate
				,@ScheduleComment, @ScheduleCommentRtf, @ScheduledByFk, GETDATE()
				,'',               '',             '',                0,                    '1/1/1900'
				,0)
		SET @Err = 0;
    END TRY
    BEGIN CATCH
		SET @Err = 2000;
    END CATCH;	
END
ELSE		-- Modifiying an existing record
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION t1;
			INSERT [hst].[Schedule]
				([IdFk],[EngagementFk],[LeaderFk],[DateFrom],[DateTo]
				,[TripDirectorFk],[SpeechWriterFk],[CommunicationsLeadFk]
				,[BriefDueToGCEByDate],[BriefDueToBGC3ByDate]
				,[ScheduleComment], [ScheduleCommentRtf], [ScheduledByFk], [ScheduledDate]
				,[ApproveDecline],[ReviewComment],[ReviewCommentRtf],[ReviewCompletedByFk],[ReviewCompletedDate]
				,[IsDeleted])
			SELECT 
				 [Id],[EngagementFk],[LeaderFk],[DateFrom],[DateTo]
				,[TripDirectorFk],[SpeechWriterFk],[CommunicationsLeadFk]
				,[BriefDueToGCEByDate],[BriefDueToBGC3ByDate]
				,[ScheduleComment], [ScheduleCommentRtf], [ScheduledByFk], [ScheduledDate]
				,[ApproveDecline],[ReviewComment],[ReviewCommentRtf],[ReviewCompletedByFk],[ReviewCompletedDate]
				,[IsDeleted]
				FROM [dbo].[Schedule]
				WHERE Id = @Id;

			UPDATE [dbo].[Schedule]
				SET  [DateFrom]				= @DateFrom
					,[DateTo]				= @DateTo
					,[TripDirectorFk]		= @TripDirectorFk
					,[SpeechWriterFk]		= @SpeechWriterFk
					,[CommunicationsLeadFk]	= @CommunicationsLeadFk
					,[BriefDueToGCEByDate]	= @BriefDueToGCEByDate
					,[BriefDueToBGC3ByDate]	= @BriefDueToBGC3ByDate
					,[ScheduleComment]		= @ScheduleComment
					,[ScheduleCommentRtf]	= @ScheduleCommentRtf
					,[ScheduledByFk]		= @ScheduledByFk
					,[ScheduledDate]		= GETDATE()
				WHERE Id = @Id;
        COMMIT TRANSACTION t1;
		SET @Err = 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION t1;
		SET @Err = 3000;
    END CATCH;	
END;
END;

SELECT @Err;

END;