/****** Object:  UserDefinedProcedure [dbo].[uspMigrateStatus]    Script Date: 11/14/2016 10:26:54 AM ******/
/*******************************************************************************
Author:				Ma. Carina Sanchez 
Created Date:		11/14/2016
Description:		Perform Insert to Status. 
					Calculate the Status based on specific criteria
Parameters:			@FirstId			- the MIN id of the current column (e.g. SELECT MIN(Id) FROM dbo.Engagement)
										- Simply declare a constant here if the column has an IDENTITY property
					@ProceedWithUpdate	- Bit(0,1) to idenitify if Update will push thru

Execute:			EXEC [dbo].[uspMigrateStatus] 1000000, 0; This will only return a list of Engagement ID and Status to be updated
					EXEC [dbo].[uspMigrateStatus] 1000000, 1; Will push thru with the with the update of Engagement's Status column


Changed By			Date			Description 

*******************************************************************************/

CREATE PROCEDURE [dbo].[uspMigrateStatus]
(    
      @FirstId INT,
	  @ProceedWithUpdate BIT	
)
AS
BEGIN

	DECLARE @RowLength INT,
		@LoopCounterMin INT,
		@LoopCounterMax INT,
		@YearQtrSet NVARCHAR(MAX),
		--Values are from dbo.Status
		@Status_Draft INT = 1000,
		@Status_SubmittedForReview INT = 1001,
		@Status_ReviewInProgress INT = 1002,
		@Status_Declined INT = 1003,
		@Status_Approved INT = 1004,
		@Status_SchedulingInProgress INT = 1005,
		@Status_Scheduled INT = 1006,
		@Status_Completed INT = 1007,
		--Values are from dbo.Ranking
		@Ranking_Declined INT = 1003
		
	--Temp table that will hold Status to be inserted
	CREATE TABLE #tempMigrateStatus(
		Id INT,
		ToBe_StatusFk INT
	)
	
	--Initialize loop counter by getting the min and max Id of Engagement
	SELECT @LoopCounterMin = @FirstId, 
		@LoopCounterMax = MAX(Id) 
	FROM [dbo].[Engagement]

	-- Loop to Engagement rows
	WHILE ( @LoopCounterMin IS NOT NULL
        AND  @LoopCounterMin <= @LoopCounterMax)
		BEGIN

			--Get and Set Status fields
			DECLARE @EntryCompleted BIT,
				@PresidentReviewCompleted BIT,
				@ScheduleCompleted BIT,
				@PresidentComment VARCHAR(MAX),
				@PresidentRanking INT,
				@ScheduleId INT,
				@ScheduledDate DATETIME,
				@ToBeStatus	INT = 0

			SELECT @EntryCompleted = [EntryCompleted] 
				,@PresidentReviewCompleted = [PresidentReviewCompleted]
				,@ScheduleCompleted = [ScheduleCompleted]
				,@PresidentComment = [PresidentComment]
				,@PresidentRanking = [PresidentRankingFk]
			FROM [dbo].[Engagement]
			WHERE [Id] = @LoopCounterMin

			SELECT @ScheduleId = [Id]
				,@ScheduledDate = [ScheduledDate]
			FROM [dbo].[Schedule]
			WHERE [EngagementFk] = @LoopCounterMin
			
			--if entrycompleted = 0; status = draft
			IF (@EntryCompleted = 0) 
				SET @ToBeStatus = @Status_Draft
			--if entrycompleted = 1; President Review Completed = 0; president comment is blank; president ranking is blank;  status = Submitted for Review
			ELSE IF (@PresidentReviewCompleted = 0 AND (@PresidentComment IS NULL OR @PresidentComment = '') AND  (@PresidentRanking IS NULL OR @PresidentRanking = ''))
				SET @ToBeStatus = @Status_SubmittedForReview
			 --if entrycompleted = 1; President Review Completed = 0; president comment contains data OR; president ranking has been selected;  status = Review in Progress
			 ELSE IF (@PresidentReviewCompleted = 0 AND (@PresidentComment IS NOT NULL OR @PresidentRanking IS NOT NULL))
				SET @ToBeStatus = @Status_ReviewInProgress
			--if entrycompleted = 1; President Review Completed = 1 and president ranking =  declined; status = Declined
			ELSE IF (@PresidentReviewCompleted = 1 AND @PresidentRanking = @Ranking_Declined)
				SET @ToBeStatus = @Status_Declined
			--if entrycompleted = 1; President Review Completed = 1 and president ranking <>  declined; ScheduleCompleted = 0 status; Approved
			ELSE IF (@PresidentReviewCompleted = 1 AND @PresidentRanking <> @Ranking_Declined AND @ScheduleCompleted = 0)
				SET @ToBeStatus = @Status_Approved
			--if entrycompleted = 1; President Review Completed = 1; schedule completed = 0; engagementFK exist in Schedule table; = Scheduling in progress
			ELSE IF (@PresidentReviewCompleted = 1 AND @ScheduleCompleted = 0 AND @ScheduleId IS NOT NULL)
				SET @ToBeStatus = @Status_SchedulingInProgress
			--if entrycompleted = 1; President Review Completed = 1; schedule completed = 1; status = scheduled
			ELSE IF (@PresidentReviewCompleted = 1 AND @ScheduleCompleted = 1)
				SET @ToBeStatus = @Status_Scheduled
			--if entrycompleted = 1; President Review Completed = 1; schedule completed = 1 and schedule date is in the past = completed
			ELSE IF (@PresidentReviewCompleted = 1 AND @ScheduleCompleted = 1 AND @ScheduledDate < GETDATE())
				SET @ToBeStatus = @Status_Completed

			INSERT INTO #tempMigrateStatus (Id, ToBe_StatusFk)
			VALUES(@LoopCounterMin, @ToBeStatus)

			SET @LoopCounterMin  = @LoopCounterMin  + 1  

	   END      

	IF (@ProceedWithUpdate = 1)
		BEGIN
			--Update Engagement Status
			UPDATE [dbo].[Engagement] 
			SET [StatusFk] = T.ToBe_StatusFk
			FROM #tempMigrateStatus T
			WHERE T.Id = [dbo].[Engagement].[Id]
			
			SELECT E.[EntryCompleted], E.[PresidentReviewCompleted], E.[ScheduleCompleted] 
				, E.[PresidentComment],  E.[PresidentRankingFk], S.[Name]
			FROM [dbo].[Engagement] E
			LEFT JOIN [dbo].[Status] S
				ON E.[StatusFk] = S.[Id]

		END
	ELSE
		BEGIN
			-- Return rows to be migrated
			SELECT *
			FROM #tempMigrateStatus
		END
	
	DROP TABLE #tempMigrateStatus

END;