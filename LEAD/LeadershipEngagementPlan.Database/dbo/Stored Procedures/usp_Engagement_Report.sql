

-- =============================================
-- Author:		Alvin John Apilan
-- Create date: 07/15/2016
-- Description:	Engagement Report
-- =============================================
CREATE PROCEDURE [dbo].[usp_Engagement_Report]

	@divisionId varchar(50),
	@teamId varchar(50),
	@priority varchar(50),
	@teamranking varchar(50),
	@principalrequired varchar(50),
	@altPrincipal varchar(50),
	@status varchar(50),
	@quarter varchar(50),
	@engagementType varchar(50),
	@country varchar(50),
	@city varchar(50),
	@duration varchar(50),
	@engagementPurpose varchar(50),
	@dateFlex varchar(50),
	@year varchar(50)

AS
BEGIN
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
      ,[DateStart] = CONVERT(VARCHAR(10), [DateStart], 101)
      ,[DateEnd] = CONVERT(VARCHAR(10), [DateStart], 101)
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
      ,[YearQuarterFks]
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
  FROM [dbo].[vEngagement] AS egmnt
  WHERE egmnt.DivisionFk in (select Item from dbo.SplitString(@divisionId,','))
  AND
  (
	egmnt.TeamFk in (select Item from dbo.SplitString(@teamId,','))
	OR
	0 in (select Item from dbo.SplitString(@teamId,','))
  )
  AND
  (
	egmnt.StrategicPriorityFk in (select Item from dbo.SplitString(@priority,','))
	OR
	0 in (select Item from dbo.SplitString(@priority,','))
  )
  AND
  (
	egmnt.TeamRankingFk in (select Item from dbo.SplitString(@teamranking,','))
	OR
	0 in (select Item from dbo.SplitString(@teamranking,','))
  )
  AND
  (
      Id in ((select Id from [ufnGetEngagementIdsByPrincipal](@principalrequired)))
      OR Id in ((select Id from [ufnGetEngagementIdsByAlternatePrincipal](@altPrincipal))) 
  )
  --AND egmnt.PrincipalRequiredFks in (select Item from dbo.SplitString(@principalrequired,','))
  --AND egmnt.PrincipalAlternateFks in (select Item from dbo.SplitString(@altPrincipal,','))
  AND
  (
	egmnt.Status in (select Item from dbo.SplitString(@status,','))
	OR
	'0' in (select Item from dbo.SplitString(@status,','))
  )
  --AND egmnt.YearQuarterFks in (select Item from dbo.SplitString(@year,','))
  --AND egmnt.YearQuarterFks in (select Item from dbo.SplitString(@quarter,','))
 -- (
	--(egmnt.YearQuarterFks in (select Item from dbo.SplitString(@year,',')) OR egmnt.YearQuarterFks = 'SELECT ALL')
 -- OR
	--(egmnt.YearQuarterFks in (select Item from dbo.SplitString(@quarter,',')))
 -- )
 AND
 (
	egmnt.IsExternal in (select Item from dbo.SplitString(@engagementType,','))
	OR
	'1,0' in (select Item from dbo.SplitString(@engagementType,','))
 )
 --AND
 --(
	--egmnt.CountryFk in (select Item from dbo.SplitString(@country,','))
	--OR
	--0 in (select Item from dbo.SplitString(@country,','))
 --)
 --AND
 --(
	--egmnt.DurationFk in (select Item from dbo.SplitString(@duration,','))
	--OR
	--0 in (select Item from dbo.SplitString(@duration,','))
 --)
 --AND
 --(
	--egmnt.PurposeFk in (select Item from dbo.SplitString(@engagementPurpose,','))
	--OR
	--0 in (select Item from dbo.SplitString(@engagementPurpose,','))
 --)
 --AND
 --(
	--egmnt.IsDateFlexible in (select Item from dbo.SplitString(@dateFlex,','))
	--OR
	--0 in (select Item from dbo.SplitString(@dateFlex,','))
 --) 
 --AND
 --(
 --egmnt.City = @city
 --)

END;