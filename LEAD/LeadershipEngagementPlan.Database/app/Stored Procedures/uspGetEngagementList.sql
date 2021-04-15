-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 05/11/2016
-- Description:	Get list of Engagement
-- =============================================
--		@Type = N'B',
--		@From = '12/31/2000',
--		@To = '01/31/2100',
--	    @SelectBy = 'EntryDate',
--	    @SysGroupId = 1002
--
CREATE PROCEDURE [app].[uspGetEngagementList]
(
	 @Type			CHAR(1)
	,@SelectBy		CHAR(10)
	,@From			DATE
	,@To			DATE
	,@SysGroupId	INT
	,@CompletedOnly CHAR(1)
	,@ReviewedOnly	CHAR(1)
)

AS
BEGIN


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

DECLARE @YYYYQQFrom CHAR(6);
DECLARE @YYYYQQTo CHAR(6);

SET @YYYYQQFrom = STR(DATEPART(YYYY, @From), 4) + '0' + STR((DATEPART(mm, @From) - 1) / 3 + 1, 1);
SET @YYYYQQTo   = STR(DATEPART(YYYY, @To),   4) + '0' + STR((DATEPART(mm, @To)   - 1) / 3 + 1, 1);

		SELECT 
			 [Id]
			,[Title]
			,[Details]
			,[Objectives]
			,[PrincipalRequired]
			,[PrincipalAlternate]
			,[ExecutiveSponsor]
			,[Visibility]
			,[EngagementType]
			,[EngagementExtInt]
			,[Region]
			,[City]
			,[Purpose]
			,[BriefOwner]
			,[Staff]
			,[Duration]
			,[DateFlexible]
			,[YearQuarter]
			,[DateStart]
			,[DateEnd]
			,[TeamInfo]
			,[Division]
			,[DivisionShortName]
			,[Team]
			,[StrategicPriority]
			,[TeamRanking]
			,[PresidentRanking]
			,[PresidentComment]
			,[Status]
			,[EntryDate]
			,[EntryBY]
			,[ModifiedDate]
			,[ModifiedBy]
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
			,[DetailsRtf]
			,[ObjectivesRtf]
			,[PresidentCommentRtf]
		  FROM [app].[vEngagement]
		  WHERE 1=1
				AND
				(   (@Type = 'E' AND [IsExternal] = 1)
						OR 
					(@Type = 'I' AND [IsExternal] !=1)
						OR
					(@Type = 'B')	
				)	
				AND
				(   (@SelectBy = 'EventDate' AND
					 @YYYYQQFrom <= [dbo].ufnGetOldestYearQuarterByEngagementId([Id]) AND 
					 [dbo].ufnGetOldestYearQuarterByEngagementId([Id]) <= @YYYYQQTo			)
						OR
					(@SelectBy = 'EntryDate' AND
					 @From <= [EntryDate] AND 
					 [EntryDate] < @To)
				)
				AND
				(	(@SysGroupId = 0)
						OR
					(@SysGroupId = [DivisionFk]) 
				)
				AND 
				(	[Id] >= 1000000 )
				AND
				(	(@Ok > 0)
						OR
					([IsConfidential] = 0)
				)
				AND
				(   (@CompletedOnly = 'T' AND [EntryCompleted] = 1)
						OR 
					(@CompletedOnly = 'F' AND [EntryCompleted] !=1)
						OR
					(@CompletedOnly = 'B')	
				)	
				AND
				(   (@ReviewedOnly = 'T' AND [PresidentReviewCompleted] = 1)
						OR 
					(@ReviewedOnly = 'F' AND [PresidentReviewCompleted] != 1)
						OR
					(@ReviewedOnly = 'B')	
				)
				AND
				(	[ScheduleCompleted] = 0 )
				AND
				(	[ScheduleReviewCompleted] = 0)
		  ORDER BY [EntryDate] DESC

END;