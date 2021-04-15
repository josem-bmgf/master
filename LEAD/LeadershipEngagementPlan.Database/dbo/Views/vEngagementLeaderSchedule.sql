--History
--Name								version							Sprint					Description
--Kirk Encarnacion					1.0							[2017 Sprint 10]			US139849 - Remapped the division from SysGroup to Division Table.
--																							Changed the DivisionShorname column to DivisionDescription
--Darwin C. Baluyot					1.1							[2017 Sprint 13]			US140471 - Created a function to pull the FullName of multi-users in each fields

CREATE VIEW [dbo].[vEngagementLeaderSchedule]
AS
 SELECT e.[Id]
      , e.[Title]
      ,e.[Details]
      ,e.[DetailsRtf]
      ,e.[Objectives]
      ,e.[ObjectivesRtf]
	  ,e.[ExecutiveSponsorFk]
	  ,e.[IsConfidential]
	  ,e.[IsExternal]
	  ,e.[RegionFk]
	  ,e.[City]
	  ,e.[Location]
	  ,e.[PurposeFk]
	  ,[dbo].[ufnGetSysUserIdByEngagementId] (e.[Id], 1001) [BriefOwnerFk]
	  ,[dbo].[ufnGetSysUserIdByEngagementId] (e.[Id], 1000) [StaffFk]
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
	  ,[dbo].[ufnGetPrincipalNamesByEngagementId](e.Id, 1000) [PrincipalRequired]
	  ,[dbo].[ufnGetPrincipalNamesByEngagementId](e.Id, 1001) [PrincipalAlternate]
	  ,l.[ShortName] [ExecutiveSponsor]
	  ,CASE WHEN e.[IsConfidential] = 1 THEN 'Confidential' ELSE 'Open' END [Visibility]
      ,CASE WHEN e.[IsExternal] = 1 THEN 'External' ELSE 'Internal' END [EngagementType]
	  ,r.[Region]
	  ,[dbo].[ufnGetCountriesByEngagementId](e.Id) [Country]
	  ,pu.[Purpose]
      ,[dbo].[ufnGetSysUserNameByEngagementId](e.Id, 1001) [BriefOwner]
      ,[dbo].[ufnGetSysUserNameByEngagementId](e.Id, 1000) [Staff]
	  ,d.[Duration]
	  ,d.[DurationInMinutes]
	  ,d.[DurationInDays]
	  ,CASE WHEN e.[IsExternal] = 1 THEN r.[Region]+'/'+[dbo].[ufnGetCountriesByEngagementId](e.Id)+'/'+e.[City]
									ELSE pu.[Purpose]+'/'+[dbo].[ufnGetSysUserNameByEngagementId](e.Id, 1001)+'/'+ [dbo].[ufnGetSysUserNameByEngagementId](e.Id, 1000) END [EngagementExtInt]
      ,CASE WHEN e.[IsDateFlexible] = 1 THEN 'Flexible' ELSE 'Nonflexible' END [DateFlexible]
	  ,[dbo].[ufnGetAllYearQuarterByEngagementId](e.Id) [YearQuarter]
	  ,'Div: ' + dv.[Name] + ' Team: ' + t.[Team] + ' Pri: ' + p.[Priority] + ' Rank: ' + tr.[Ranking] [TeamInfo]
	  ,dv.[Name] [Division]
	  ,dv.[Description] [DivisionDescription]
	  ,t.[Team]
	  ,p.[Priority] [StrategicPriority]
	  ,tr.[Ranking] [TeamRanking]
	  ,pr.[Ranking] [PresidentRanking]
	  ,st.Name [Status]
	  ,st.DisplaySortSequence [StatusDisplaySortSequence]
      ,et.[FullName] [EntryBY]
      ,md.[FullName] [ModifiedBy]
	  ,sch.[Id]	'ScheduleId'
	  ,sch.[EngagementFk] 'ScheduleEngagementFk'
	  ,sch.[LeaderFk] 'ScheduleLeaderFk'
	  ,sch.[DateFrom] 'ScheduleFromDate'
	  ,sch.[DateTo] 'ScheduleToDate'
	  ,[dbo].[ufnGetSysUserIdByScheduleId] (sch.[Id], 1002) 'ScheduleTripDirector'
	  ,[dbo].[ufnGetSysUserIdByScheduleId] (sch.[Id], 1004) 'ScheduleSpeechWriterFk'
	  ,[dbo].[ufnGetSysUserIdByScheduleId] (sch.[Id], 1003) 'ScheduleCommunicationsLeadFk'
	  ,sch.[BriefDueToGCEByDate]  'ScheduleBriefDueToGCEByDate'
	  ,sch.[BriefDueToBGC3ByDate] 'ScheduleBriefDueToBGC3ByDate'
	  ,sch.[ScheduleComment] 'ScheduleComment'
	  ,sch.[ScheduleCommentRtf] 'ScheduleCommentRtf'
	  ,sch.[ScheduledByFk] 'ScheduledByFk'
	  ,sch.[ScheduledDate] 'ScheduledDate'
	  ,CASE WHEN sch.[ApproveDecline] ='A' THEN 'Approved'
			WHEN sch.[ApproveDecline] ='D' THEN 'Declined'
			ELSE '' END 'ScheduleApprovalStatus'
	  ,sch.[ReviewComment] 'ScheduleReviewComment'
	  ,sch.[ReviewCommentRtf] 'ScheduleReviewCommentRtf'
	  ,sch.[ReviewCompletedByFk] 'ScheduleReviewCompletedByFk'
	  ,sch.[ReviewCompletedDate] 'ScheduleReviewCompletedDate'
	  ,sb.[FullName] 'ScheduledBy'
	  ,srb.[FullName] 'ScheduleReviewCompletedBy'
	  ,ldr.[FirstName] 'LeaderFirstName'
	  ,ldr.[LastName] 'LeaderLastName'
	  ,ldr.[ShortName] 'LeaderShortName'
	  ,ldr.[ADUser]	'LeaderADUser'
	  ,[dbo].[ufnGetSysUserNameByScheduleId](sch.Id, 1002) 'TripDirector'
	  ,[dbo].[ufnGetSysUserNameByScheduleId](sch.Id, 1004) 'SpeechWriter'
	  ,[dbo].[ufnGetSysUserNameByScheduleId](sch.Id, 1003) 'CommunicationsLead'
  FROM [dbo].[Engagement] e
  JOIN [dbo].[Status] st on e.StatusFk = st.[Id] 
  JOIN [dbo].[Leader] l ON e.ExecutiveSponsorFk = l.[Id]
  JOIN [dbo].[Region] r ON e.[RegionFk] = r.[Id]
  JOIN [dbo].[Purpose] pu ON e.[PurposeFk] = pu.[Id]
  JOIN [dbo].[Duration] d ON e.[DurationFk] = d.[Id]
  JOIN [dbo].[Division] dv ON e.[DivisionFk] = dv.[Id]
  JOIN [dbo].[Team] t ON e.[TeamFk] = t.[Id]
  JOIN [dbo].[Priority] p ON e.[StrategicPriorityFk] = p.[Id]
  JOIN [dbo].[Ranking] tr ON e.TeamRankingFk = tr.[Id]
  JOIN [dbo].[Ranking] pr ON e.PresidentRankingFk = pr.[Id]
  JOIN [dbo].[SysUser] et ON e.[EntryByFk] = et.[Id]
  JOIN [dbo].[SysUser] md ON e.[ModifiedByFk] = md.[Id]
  --JOIN [dbo].[SysGroup] sg ON e.[DivisionFk] = sg.Id
  LEFT OUTER JOIN [dbo].[Schedule] sch ON e.[Id] = sch.[EngagementFk]
  LEFT OUTER JOIN [dbo].[Leader] ldr ON sch.[LeaderFk] = ldr.[Id]
  LEFT OUTER JOIN [dbo].[SysUser] sb ON sch.[ScheduledByFk] = sb.[Id]
  LEFT OUTER JOIN [dbo].[SysUser] srb ON sch.[ReviewCompletedByFk] = srb.[Id]
  WHERE 1=1
	AND e.IsDeleted != 1
	AND (	
			(sch.[EngagementFk] IS NULL)
			OR
			(sch.[EngagementFk] IS NOT NULL AND sch.[IsDeleted] = 0)
		)