-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 05/09/2016
-- Description:	Update engagement.
-- =============================================
CREATE PROCEDURE [app].[uspUpsertEngagement]
(
	   @Id							INT
      ,@Title						VARCHAR(128)
      ,@Details						VARCHAR(MAX)
      ,@DetailsRtf					VARCHAR(MAX)
      ,@Objectives					VARCHAR(MAX)
      ,@ObjectivesRtf				VARCHAR(MAX)
      ,@PrincipalRequiredFks		VARCHAR(255)
      ,@PrincipalAlternateFks		VARCHAR(255)
	  ,@ExecutiveSponsorFk			INT
      ,@IsConfidential				BIT
      ,@IsExternal					BIT
	  ,@RegionFk					INT
      ,@CountryFk					INT
      ,@City						VARCHAR(128)
      ,@PurposeFk					INT
      ,@BriefOwnerFk				INT
      ,@StaffFk						INT
	  ,@DurationFk					INT
      ,@IsDateFlexible				BIT
      ,@YearQuarterFks				VARCHAR(255)
      ,@DateStart					DATE
      ,@DateEnd						DATE
	  ,@DivisionFk					INT
      ,@TeamFk						INT
	  ,@StrategicPriorityFk			INT
      ,@TeamRankingFk				INT
      ,@PresidentRankingFk			INT
      ,@PresidentComment			VARCHAR(MAX)
      ,@PresidentCommentRtf			VARCHAR(MAX)
	  ,@EntryCompletedFk			INT
	  ,@PresidentReviewCompletedFk	INT
	  ,@ScheduleCompletedFk			INT
	  ,@ScheduleReviewCompletedFk	INT
      ,@EntryModifiedByFk			INT
)
AS
BEGIN

DECLARE @Err INT;

DECLARE @Ok INT;

SELECT @Ok = MAX(CAST(sgup.[SysAdmin] AS INT) + CAST(sgup.[AppAdmin] AS INT) + CAST(sgup.[GroupAdmin] AS INT) + CAST(sgup.[GroupEntry] AS INT))	
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
					(sgup.SysGroupFK = @DivisionFk)
				);

IF @Ok < 1 
	SET @Err = 1000;
ELSE
BEGIN
IF @Id = -1	-- Adding a new cecord 
BEGIN

    BEGIN TRY
		INSERT [dbo].[Engagement]
				([Title],[Details],[DetailsRtf],[Objectives],[ObjectivesRtf],[ExecutiveSponsorFk]
				,[IsConfidential],[IsExternal],[RegionFk],[City],[PurposeFk],[BriefOwnerFk],[StaffFk],[DurationFk]
				,[IsDateFlexible],[DateStart],[DateEnd]
				,[DivisionFk],[TeamFk],[StrategicPriorityFk],[TeamRankingFk]
				,[PresidentRankingFk], [PresidentComment], [PresidentCommentRtf]
				,[EntryCompleted],[PresidentReviewCompleted],[ScheduleCompleted],[ScheduleReviewCompleted]
				,[EntryDate],[EntryByFk],       [ModifiedDate], [ModifiedByFk],    [IsDeleted])
		VALUES	(@Title, @Details, @DetailsRtf, @Objectives, @ObjectivesRtf, @ExecutiveSponsorFk
				,@IsConfidential, @IsExternal, @RegionFk, @CountryFk ,@City, @PurposeFk, @BriefOwnerFk, @StaffFk, @DurationFk
				,@IsDateFlexible, @DateStart, @DateEnd
				,@DivisionFk, @TeamFk, @StrategicPriorityFk, @TeamRankingFk
				,@PresidentRankingFk, @PresidentComment, @PresidentCommentRtf
				,@EntryCompletedFk,@PresidentReviewCompletedFk,@ScheduleCompletedFk,@ScheduleReviewCompletedFk
				,GETDATE(),  @EntryModifiedByFk, GETDATE(),     @EntryModifiedByFk, 0);
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
				WHERE Id = @Id;

			UPDATE [dbo].[Engagement]
				SET  [Title]					= @Title
					,[Details]					= @Details
					,[DetailsRtf]				= @DetailsRtf
					,[Objectives]				= @Objectives
					,[ObjectivesRtf]			= @ObjectivesRtf
					,[ExecutiveSponsorFk]		= @ExecutiveSponsorFk
					,[IsConfidential]			= @IsConfidential
					,[IsExternal]				= @IsExternal
					,[RegionFk]					= @RegionFk
					,[City]						= @City
					,[PurposeFk]				= @PurposeFk
					,[BriefOwnerFk]				= @BriefOwnerFk
					,[StaffFk]					= @StaffFk
					,[DurationFk]				= @DurationFk
					,[IsDateFlexible]			= @IsDateFlexible
					,[DateStart]				= @DateStart
					,[DateEnd]					= @DateEnd
					,[DivisionFk]				= @DivisionFk
					,[TeamFk]					= @TeamFk
					,[StrategicPriorityFk]		= @StrategicPriorityFk
					,[TeamRankingFk]			= @TeamRankingFk
					,[PresidentRankingFk]		= @PresidentRankingFk
					,[PresidentComment]			= @PresidentComment
					,[PresidentCommentRtf]		= @PresidentCommentRtf
					,[EntryCompleted]			= @EntryCompletedFk
					,[PresidentReviewCompleted] = @PresidentReviewCompletedFk
					,[ScheduleCompleted]		= @ScheduleCompletedFk
					,[ScheduleReviewCompleted]= @ScheduleReviewCompletedFk
					,[ModifiedDate]				= GETDATE()
					,[ModifiedByFk]				= @EntryModifiedByFk
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