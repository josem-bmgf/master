-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 06/13/2016
-- Description:	Approve engagement.
-- =============================================
CREATE PROCEDURE [app].[uspUpsertApproveSchedule]
(
	   @Id						INT
      ,@ApproveDecline			CHAR(1)
      ,@ReviewComment			VARCHAR(MAX)
      ,@ReviewCommentRtf		VARCHAR(MAX)
      ,@ReviewCompletedByFk		INT
)
AS
BEGIN

DECLARE @Err INT;

DECLARE @Ok INT;

DECLARE @ttl INT;
DECLARE @reviewed INT;
DECLARE @IdFk INT;


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
				SET  [ApproveDecline]		= @ApproveDecline
					,[ReviewComment]		= @ReviewComment
					,[ReviewCommentRtf]		= @ReviewCommentRtf
					,[ReviewCompletedByFk]	= @ReviewCompletedByFk
					,[ReviewCompletedDate]	= GETDATE()
				WHERE Id = @Id;

			SELECT @IdFk = [EngagementFk] FROM [dbo].[Schedule] WHERE [Id] = @Id

			SELECT @ttl = COUNT(*) 
				FROM [dbo].[Schedule]
				WHERE 1=1
					AND [EngagementFk] = @IdFk

			SELECT @reviewed = COUNT(*) 
				FROM [dbo].[Schedule]
				WHERE 1=1
					AND [EngagementFk] = @IdFk
					AND [ApproveDecline] IN ('A','D')

			IF @ttl = @reviewed
				EXEC [app].[uspUpsertSetScheduleReviewCompleted] @IdFk, 1, @ReviewCompletedByFk	


        COMMIT TRANSACTION t1;
		SET @Err = 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION t1;
		SET @Err = 3000;
    END CATCH;	

END;

SELECT @Err;

END;