-- [2017 Sprint 04] US 136188 - LEAD - Add new field in the Engagement form 
-- Added Location field in Engagement table and displayed it to Scheduling section in Engagement form.

USE [LEAD]
GO

ALTER TABLE [dbo].[Engagement]
	ADD [Location] [varchar](128) NULL CONSTRAINT [DF_Engagement_Location]  DEFAULT ('');

GO


