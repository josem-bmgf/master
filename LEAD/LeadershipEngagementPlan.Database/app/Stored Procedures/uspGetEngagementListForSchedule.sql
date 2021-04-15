-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 05/11/2016
-- Description:	Get list of Engagement Leader schedule
-- =============================================
--		@Type = N'B',
--		@From = '12/31/2000',
--		@To = '01/31/2100',
--	    @SelectBy = 'EntryDate',
--	    @SysGroupId = 1002
--
CREATE PROCEDURE [app].[uspGetEngagementListForSchedule]
(
	 @Type						CHAR(1)
	,@From						DATE
	,@To						DATE
	,@Draft						BIT
	,@EntryCompleted			BIT
	,@PresidentReviewCompleted	BIT
	,@ScheduleCompleted			BIT
	,@ScheduleReviewCompleted	BIT
	,@SysGroupId				INT
	,@RegionFk					INT
	,@PurposeFk					INT
)

AS
BEGIN

DECLARE @YYYYQQFrom CHAR(6);
DECLARE @YYYYQQTo CHAR(6);

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
			AND sgup.SysGroupFK IN (1000, 1001)

SET @YYYYQQFrom = STR(DATEPART(YYYY, @From), 4) + '0' + STR((DATEPART(mm, @From) - 1) / 3 + 1, 1);
SET @YYYYQQTo   = STR(DATEPART(YYYY, @To),   4) + '0' + STR((DATEPART(mm, @To)   - 1) / 3 + 1, 1);

SELECT [Id]
      ,[YearQuarter]
      ,[PrincipalRequired]
      ,[PrincipalAlternate]
      ,[Duration]
      ,[Title]
      ,[DateFlexible]
      ,[DateStart]
      ,[DateEnd]
      ,[Details]
      ,[Objectives]
      ,[EngagementExtInt]
      ,[PresidentRanking]
      ,[PresidentComment]
      ,[DetailsRtf]
      ,[ObjectivesRtf]
      ,[ExecutiveSponsor]
      ,[Visibility]
      ,[EngagementType]
      ,[Region]
      ,[City]
      ,[Purpose]
      ,[BriefOwner]
      ,[Staff]
      ,[DurationInMinutes]
      ,[DurationInDays]
      ,[TeamInfo]
      ,[Division]
      ,[DivisionShortName]
      ,[Team]
      ,[StrategicPriority]
      ,[TeamRanking]
      ,[PresidentCommentRtf]
      ,[Status]
      ,[EntryDate]
      ,[EntryBY]
      ,[ModifiedDate]
      ,[ModifiedBy]
      ,[PrincipalRequiredFks]
      ,[PrincipalAlternateFks]
      ,[ExecutiveSponsorFk]
      ,[IsConfidential]
      ,[IsExternal]
      ,[RegionFk]
      ,[PurposeFk]
      ,[BriefOwnerFk]
      ,[StaffFk]
      ,[DurationFk]
      ,[IsDateFlexible]
      ,[DivisionFk]
      ,[TeamFk]
      ,[StrategicPriorityFk]
      ,[TeamRankingFk]
      ,[PresidentRankingFk]
      ,[EntryCompleted]
      ,[PresidentReviewCompleted]
      ,[ScheduleCompleted]
      ,[ScheduleReviewCompleted]
      ,[EntryByFk]
      ,[ModifiedByFk]
	FROM [dbo].[vEngagement]
		  WHERE 1=1
				AND
				(   
					(@Type = 'E' AND [IsExternal] = 1)
						OR 
					(@Type = 'I' AND [IsExternal] = 0)
						OR
					(@Type = 'B')	)	
				AND
				(    
					@YYYYQQFrom <= [dbo].[ufnGetOldestYearQuarterByEngagementId]([Id]) AND 
					 [dbo].[ufnGetOldestYearQuarterByEngagementId]([Id]) <= @YYYYQQTo	
				)
				AND 
				(
					(@Draft = 1
						AND [EntryCompleted] = 0
						AND [PresidentReviewCompleted] = 0
						AND [ScheduleCompleted] = 0
						AND [ScheduleReviewCompleted] = 0
					)
						OR
					(@EntryCompleted = 1
						AND [EntryCompleted] = 1
						AND [PresidentReviewCompleted] = 0
						AND [ScheduleCompleted] = 0
						AND [ScheduleReviewCompleted] = 0
					)
						OR
					(@PresidentReviewCompleted = 1
						AND [PresidentReviewCompleted] =1
						AND [EntryCompleted] = 1
						AND [ScheduleCompleted] = 0
						AND [ScheduleReviewCompleted] = 0
					)
						OR
					(@ScheduleCompleted = 1
						AND [ScheduleCompleted] =1
						AND [EntryCompleted] = 1
						AND [PresidentReviewCompleted] = 1
						AND [ScheduleReviewCompleted] = 0
					)
						OR
					(@ScheduleReviewCompleted = 1
						AND [ScheduleReviewCompleted] = 1
						AND [EntryCompleted] = 1
						AND [PresidentReviewCompleted] = 1
						AND [ScheduleCompleted] = 1 
					)
				)
				AND
				(	
					(@SysGroupId = 0)
						OR
					(@SysGroupId = [DivisionFk]) 
				)
				AND
				(   
					(@RegionFk = 0)
						OR
					(@RegionFk =  [RegionFk] AND [IsExternal] = 1)
						OR
					([IsExternal] = 0)
				)
				AND 
				(	(@PurposeFk = 0)
						OR
					(@PurposeFk = [PurposeFk] AND [IsExternal] = 0)
						OR
					([IsExternal] = 1)
				)
				AND
				(	[Id] >= 1000000 )
				AND
				(	(@Ok > 0)
						OR
					([IsConfidential] = 0)
				)
		  ORDER BY [YearQuarter], [DateStart]

END;