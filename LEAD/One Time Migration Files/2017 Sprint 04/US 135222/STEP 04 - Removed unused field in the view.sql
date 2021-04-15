-- [2017 Sprint 04] US 135222 - LEAD - Change Country field to multi-select 
-- Removed the [PrincipalRequiredFks],[PrincipalAlternateFKs].

USE [LEAD]
GO

/****** Object:  View [app].[vEngagementLeaderSchedule]    Script Date: 2/19/2017 7:13:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
ALTER VIEW [app].[vEngagementLeaderSchedule]
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
	  ,[ScheduleId]
	  ,[ScheduleEngagementFk]
	  ,[ScheduleLeaderFk]
	  ,[ScheduleTripDirectorFk]
	  ,[ScheduleSpeechWriterFk]
	  ,[ScheduleCommunicationsLeadFk]
	  ,[ScheduledByFk]
	  ,[ScheduleReviewCompletedByFk]
  FROM [dbo].[vEngagementLeaderSchedule]
  WHERE ID > 0















GO


