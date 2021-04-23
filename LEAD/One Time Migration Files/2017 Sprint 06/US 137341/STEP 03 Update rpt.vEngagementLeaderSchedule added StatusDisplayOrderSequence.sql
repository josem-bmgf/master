-- [2017 Sprint 06] US 137341 - LEAD - Update Sorting by Status (4)
-- [DEV] Alter rpt.vEngagementLeaderSchedule added StatusDisplayOrderSequence column

USE [LEAD]
GO

/****** Object:  View [rpt].[vEngagementLeaderSchedule]    Script Date: 4/2/2017 11:48:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Script for SelectTopNRows command from SSMS  ******/
ALTER VIEW [rpt].[vEngagementLeaderSchedule]
AS
SELECT [Id]
      ,[Title]
      ,[Details]
	  ,[DetailsRtf]
      ,[Objectives]
	  ,[ObjectivesRtf]
      ,[PrincipalRequired]
      ,[PrincipalAlternate]
	  ,[ExecutiveSponsor]
	  ,[Visibility]
      ,[EngagementType]
      ,[EngagementExtInt]
      ,[Region]
      ,[Country]
      ,[City]
	  ,[Location]
      ,[Purpose]
      ,[BriefOwner]
      ,[Staff]
	  ,[Duration]
	  ,[DurationInMinutes]
	  ,[DurationInDays]
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
	  ,[PresidentCommentRtf]
	  ,[Status]
	  ,[StatusDisplaySortSequence]
      ,[EntryDate]
      ,[EntryBY]
      ,[ModifiedDate]
      ,[ModifiedBy]
	  ,[ScheduleFromDate]
      ,[ScheduleToDate]
	  ,[TripDirector]
	  ,[SpeechWriter]
	  ,[CommunicationsLead]
	  ,[ScheduleBriefDueToGCEByDate]
	  ,[ScheduleBriefDueToBGC3ByDate]
      ,[ScheduleComment]
      ,[ScheduleCommentRtf]
      ,[ScheduledBy]
      ,[ScheduledDate]
      ,[ScheduleApprovalStatus]
      ,[ScheduleReviewComment]
      ,[ScheduleReviewCommentRtf]
      ,[ScheduleReviewCompletedBy]
      ,[ScheduleReviewCompletedDate]
      ,[LeaderFirstName]
      ,[LeaderLastName]
      ,[LeaderShortName]
      ,[LeaderADUser]
	  ,[IsConfidential]
      ,[IsExternal]
	  ,[EntryCompleted]
	  ,[PresidentReviewCompleted]
	  ,[ScheduleCompleted]
	  ,[ScheduleReviewCompleted]
	  ,[ScheduleId]
  FROM [dbo].[vEngagementLeaderSchedule]
  WHERE ID > 0

GO


