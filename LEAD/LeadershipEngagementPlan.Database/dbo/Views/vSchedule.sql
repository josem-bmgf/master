




/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dbo].[vSchedule]
AS
SELECT s.[Id]
      ,s.[EngagementFk]
      ,s.[LeaderFk]
      ,s.[DateFrom]
      ,s.[DateTo]
      ,s.[TripDirectorFk]
      ,s.[SpeechWriterFk]
      ,s.[CommunicationsLeadFk]
      ,s.[BriefDueToGCEByDate]
      ,s.[BriefDueToBGC3ByDate]
      ,s.[ScheduleComment]
      ,s.[ScheduleCommentRtf]
      ,s.[ScheduledByFk]
      ,s.[ScheduledDate]
      ,CASE WHEN s.[ApproveDecline] ='A' THEN 'Approved'
			WHEN s.[ApproveDecline] ='D' THEN 'Declined'
			ELSE '' END 'ApproveDecline'
      ,s.[ReviewComment]
      ,s.[ReviewCommentRtf]
      ,s.[ReviewCompletedByFk]
      ,s.[ReviewCompletedDate]
	  ,l.[ShortName] 'Principal'
	  ,td.[FullName] 'TripDirector'
	  ,sw.[FullName] 'SpeechWriter'
	  ,cl.[FullName] 'CommunicationsLead'
	  ,sb.[FullName] 'ScheduledBy'
	  ,rb.[FullName] 'ReviewCompletedBy'
	FROM [dbo].[Schedule] s
	JOIN [dbo].[Leader] l		ON s.[LeaderFk] = l.[Id]
	JOIN [dbo].[SysUser] td		ON s.[TripDirectorFk] = td.[Id]
	JOIN [dbo].[SysUser] sw		ON s.[SpeechWriterFk] = sw.[Id]
	JOIN [dbo].[SysUser] cl		ON s.[CommunicationsLeadFk] = cl.[Id]
	JOIN [dbo].[SysUser] sb		ON s.[ScheduledByFk] = sb.[Id]
	JOIN [dbo].[SysUser] rb		ON s.[ReviewCompletedByFk] = rb.[Id]
	WHERE 1=1
		AND s.[IsDeleted] = 0
		AND s.[EngagementFk] >= 1000000