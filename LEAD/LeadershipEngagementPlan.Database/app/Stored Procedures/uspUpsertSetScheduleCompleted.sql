-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 06/13/2016
-- Description:	Approve engagement.
-- =============================================
CREATE PROCEDURE [app].[uspUpsertSetScheduleCompleted]
(
	   @Id					INT
	  ,@ScheduleCompletedFk	INT
      ,@EntryModifiedByFk	INT
)
AS
BEGIN

DECLARE @Err INT;

DECLARE @Ok INT;

SELECT @Ok = MAX(CAST(sgup.[SysAdmin] AS INT) + CAST(sgup.[AppAdmin] AS INT) + CAST(sgup.[GroupAdmin] AS INT) + CAST(sgup.[GroupApprover] AS INT))	
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
						OR
					(sgup.SysGroupFK = (SELECT DivisionFk FROM [dbo].[Engagement] WHERE [Id] = @Id))
				);

IF @Ok < 1 
	SET @Err = 1000;
ELSE
BEGIN


    BEGIN TRY
        BEGIN TRANSACTION t1;
			INSERT [hst].[Engagement]
					([IdFk],[Title],[Details],[DetailsRtf],[Objectives],[ObjectivesRtf],[ExecutiveSponsorFk]
					,[IsConfidential],[IsExternal],[RegionFk],[City],[PurposeFk],[BriefOwnerFk],[StaffFk],[DurationFk]
					,[IsDateFlexible],[DateStart],[DateEnd]
					,[DivisionFk],[TeamFk],[StrategicPriorityFk],[TeamRankingFk]
					,[PresidentRankingFk],[PresidentComment],[PresidentCommentRtf]
					,[EntryCompleted],[PresidentReviewCompleted],[ScheduleCompleted],[ScheduleReviewCompleted]
					,[EntryDate],[EntryByFk],[ModifiedDate],[ModifiedByFk],[IsDeleted])
			SELECT   [Id],  [Title],[Details],[DetailsRtf],[Objectives],[ObjectivesRtf],[ExecutiveSponsorFk]
					,[IsConfidential],[IsExternal],[RegionFk],[City],[PurposeFk],[BriefOwnerFk],[StaffFk],[DurationFk]
					,[IsDateFlexible],[DateStart],[DateEnd]
					,[DivisionFk],[TeamFk],[StrategicPriorityFk],[TeamRankingFk]
					,[PresidentRankingFk],[PresidentComment],[PresidentCommentRtf]
					,[EntryCompleted],[PresidentReviewCompleted],[ScheduleCompleted],[ScheduleReviewCompleted]
					,[EntryDate],[EntryByFk],[ModifiedDate],[ModifiedByFk],[IsDeleted]
				FROM [dbo].[Engagement]
				WHERE [Id] = @Id;

			UPDATE [dbo].[Engagement]
				SET  [ScheduleCompleted]		= @ScheduleCompletedFk
					,[ModifiedDate]				= GETDATE()
					,[ModifiedByFk]				= @EntryModifiedByFk
				WHERE [Id] = @Id;
			
			INSERT [hst].[Principal]
					([IdFk],[EngagementFK],[LeaderFK],[TypeFK])
			SELECT   [Id],[EngagementFK],[LeaderFK],[TypeFK]
				FROM [dbo].[Principal]
				WHERE [EngagementFK] = @Id;

			INSERT [hst].[EngagementYearQuarter]
					([IdFk],[EngagementFK],[YearQuarterFK])
			SELECT   [Id],[EngagementFK],[YearQuarterFK]
				FROM [dbo].[EngagementYearQuarter]
				WHERE [EngagementFK] = @Id;

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