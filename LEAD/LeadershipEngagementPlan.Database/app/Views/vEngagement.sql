











/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [app].[vEngagement]
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
	  ,[PresidentCommentRtf]
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
  FROM [dbo].[vEngagement]
  WHERE ID >= 1000000