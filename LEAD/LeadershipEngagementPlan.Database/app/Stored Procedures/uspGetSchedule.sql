
-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 05/11/2016
-- Description:	Schedule for a given engagement.
-- =============================================
CREATE PROCEDURE [app].[uspGetSchedule]
(
	 @EngagementFk	INT
)

AS
BEGIN

SELECT [Id]
      ,[EngagementFk]
      ,[Principal]
      ,[DateFrom]
      ,[DateTo]
      ,[TripDirector]
      ,[SpeechWriter]
      ,[CommunicationsLead]
      ,[BriefDueToGCEByDate]
      ,[BriefDueToBGC3ByDate]
      ,[ScheduleComment]
      ,[ScheduleCommentRtf]
      ,[ScheduledBy]
      ,[ScheduledDate]
      ,[ApproveDecline]
      ,[ReviewComment]
      ,[ReviewCommentRtf]
      ,[ReviewCompletedBy]
      ,[ReviewCompletedDate]
      ,[LeaderFk]
      ,[TripDirectorFk]
      ,[SpeechWriterFk]
      ,[CommunicationsLeadFk]
      ,[ScheduledByFk]
      ,[ReviewCompletedByFk]
  FROM [app].[vSchedule]
  WHERE [EngagementFk] = @EngagementFk
  ORDER BY [LeaderFk] 

END;