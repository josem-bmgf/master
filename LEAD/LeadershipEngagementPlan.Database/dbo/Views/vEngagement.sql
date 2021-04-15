/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[vEngagement]
AS
 SELECT e.[Id]
      ,e.[Title]
      ,e.[Details]
      ,e.[DetailsRtf]
      ,e.[Objectives]
      ,e.[ObjectivesRtf]
      ,[dbo].[ufnGetPrincipalIdsByEngagementId](e.Id,1) [PrincipalRequiredFks]
      ,[dbo].[ufnGetPrincipalIdsByEngagementId](e.Id,2) [PrincipalAlternateFks]
	  ,e.[ExecutiveSponsorFk]
	  ,e.[IsConfidential]
	  ,e.[IsExternal]
	  ,e.[RegionFk]
	  ,e.[City]
	  ,e.[PurposeFk]
	  ,e.[BriefOwnerFk]
	  ,e.[StaffFk]
	  ,e.[DurationFk]
	  ,e.[IsDateFlexible]
	  ,[dbo].[ufnGetAllYearQuarterByEngagementId](e.Id) [YearQuarterFks]
      ,e.[DateStart]
      ,e.[DateEnd]
	  ,e.[DivisionFk]
 	  ,e.[TeamFk]
	  ,e.[StrategicPriorityFk]
	  ,e.[TeamRankingFk]
	  ,e.[PresidentRankingFk]
      ,e.[PresidentComment]
      ,e.[PresidentCommentRtf]
	  ,e.[EntryCompleted]
	  ,e.[PresidentReviewCompleted]
	  ,e.[ScheduleCompleted]
	  ,e.[ScheduleReviewCompleted]
      ,e.[EntryDate]
	  ,e.[EntryByFk]
      ,e.[ModifiedDate]
	  ,e.[ModifiedByFk]
	  ,[dbo].[ufnGetPrincipalNamesByEngagementId](e.Id,1) [PrincipalRequired]
	  ,[dbo].[ufnGetPrincipalNamesByEngagementId](e.Id,2) [PrincipalAlternate]
	  ,l.[ShortName] [ExecutiveSponsor]
	  ,CASE WHEN e.[IsConfidential] = 1 THEN 'Confidential' ELSE 'Open' END [Visibility]
      ,CASE WHEN e.[IsExternal] = 1 THEN 'External' ELSE 'Internal' END [EngagementType]
	  ,r.[Region]
	  ,pu.[Purpose]
      ,bo.[FullName] [BriefOwner]
      ,s.[FullName] [Staff]
	  ,d.[Duration]
	  ,d.[DurationInMinutes]
	  ,d.[DurationInDays]
	  ,CASE WHEN e.[IsExternal] = 1 
			THEN 'Ext -' + ' Rgn: ' + r.[Region] + ' Co: '+' Cty: '+e.[City] + ' Dur: ' + d.[Duration]
			ELSE 'Int -' + ' Pur: ' + pu.[Purpose] + ' BO: '+bo.[FullName]+' Stf: '+ s.[FullName] + ' Dur: ' + d.[Duration]
			END [EngagementExtInt]
      ,CASE WHEN e.[IsDateFlexible] = 1 
			THEN 'Flexible -' + 'Yr/Qt: ' + [dbo].[ufnGetYearQuaterList]([dbo].[ufnGetAllYearQuarterByEngagementId](e.[Id]))
			ELSE 'Nonflexible -' + 'Yr/Qt: ' + [dbo].[ufnGetYearQuaterList]([dbo].[ufnGetAllYearQuarterByEngagementId](e.[Id])) + ' Start: ' + CONVERT(VARCHAR(10), e.[DateStart], 101) + ' End: ' + CONVERT(VARCHAR(10), e.[DateEnd], 101)
			END [DateFlexible]
	  ,[dbo].[ufnGetYearQuaterList]([dbo].[ufnGetAllYearQuarterByEngagementId](e.[Id])) [YearQuarter]
	  ,'Div: ' + dv.[GroupShortName] + ' Team: ' + t.[Team] + ' Pri: ' + p.[Priority] + ' Rank: ' + tr.[Ranking] [TeamInfo]
	  ,dv.[GroupName] [Division]
	  ,dv.[GroupShortName] [DivisionShortName]
	  ,t.[Team]
	  ,p.[Priority] [StrategicPriority]
	  ,tr.[Ranking] [TeamRanking]
	  ,pr.[Ranking] [PresidentRanking]
	  ,CASE WHEN e.[EntryCompleted] = 0				
			THEN 'Draft' 
			ELSE 
				CASE WHEN e.[PresidentReviewCompleted] = 0  
					 THEN 'President Review Pending' 
					 ELSE
						 CASE WHEN e.[ScheduleCompleted] = 0			
							  THEN 'Schedule Pending' 
							  ELSE 
								  CASE WHEN e.[ScheduleReviewCompleted] = 0	
									   THEN 'Schedule Review Pending' 
									   ELSE 'Schedule Review Completed' 
									   END
							  END
					 END  
		    END [Status]
      ,et.[FullName] [EntryBY]
      ,md.[FullName] [ModifiedBy]
  FROM [dbo].[Engagement] e
  JOIN [dbo].[Leader] l			ON e.ExecutiveSponsorFk = l.[Id]
  JOIN [dbo].[Region] r			ON e.[RegionFk] = r.[Id]
  JOIN [dbo].[Purpose] pu		ON e.[PurposeFk] = pu.[Id]
  JOIN [dbo].[SysUser] bo		ON e.[BriefOwnerFk] = bo.[Id]
  JOIN [dbo].[SysUser] s		ON e.[StaffFk] = s.[Id]
  JOIN [dbo].[Duration] d		ON e.[DurationFk] = d.[Id]
  JOIN [dbo].[SysGroup] dv		ON e.[DivisionFk] = dv.[Id]
  JOIN [dbo].[Team] t			ON e.[TeamFk] = t.[Id]
  JOIN [dbo].[Priority] p		ON e.[StrategicPriorityFk] = p.[Id]
  JOIN [dbo].[Ranking] tr		ON e.TeamRankingFk = tr.[Id]
  JOIN [dbo].[Ranking] pr		ON e.PresidentRankingFk = pr.[Id]
  JOIN [dbo].[SysUser] et		ON e.[EntryByFk] = et.[Id]
  JOIN [dbo].[SysUser] md		ON e.[ModifiedByFk] = md.[Id]
  JOIN [dbo].[SysGroup] sg		ON e.[DivisionFk] = sg.Id
  WHERE 1=1
	AND e.IsDeleted != 1;