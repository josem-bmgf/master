-- [2017 Sprint 04] US 135222 - LEAD - Change Country field to multi-select 
-- Drop CountryFk, and other unused columns in Engagement table
-- NOTE! Wait for Go Signal before QA Completes testing

USE [LEAD]
GO

-- DROP CONSTRAINTS: Foreign Key and Default
ALTER TABLE [dbo].[Engagement]
DROP CONSTRAINT [FK_Engagement_Country]

ALTER TABLE [dbo].[Engagement]
DROP CONSTRAINT [DF_Engagement_CountryFk]

ALTER TABLE [dbo].[Engagement]
DROP CONSTRAINT [DF_Engagement_PrincipalRequired]

ALTER TABLE [dbo].[Engagement]
DROP CONSTRAINT [DF_Engagement_PrincipalAlternate]

ALTER TABLE [dbo].[Engagement]
DROP CONSTRAINT [DF_Engagement_YearQuarterFks]

-- DROP COLUMNS IN DBO ENGAGEMENT
ALTER TABLE [dbo].[Engagement] DROP COLUMN [CountryFk]
-- Other unused columns
ALTER TABLE [dbo].[Engagement] DROP COLUMN [PrincipalRequiredFks]
ALTER TABLE [dbo].[Engagement] DROP COLUMN [PrincipalAlternateFks]
ALTER TABLE [dbo].[Engagement] DROP COLUMN [YearQuarterFks]


-- DROP COLUMNS IN HST ENGAGEMENT
ALTER TABLE [hst].[Engagement] DROP COLUMN [CountryFk]
-- Other unused columns
ALTER TABLE [hst].[Engagement] DROP COLUMN [PrincipalRequiredFks]
ALTER TABLE [hst].[Engagement] DROP COLUMN [PrincipalAlternateFks]
ALTER TABLE [hst].[Engagement] DROP COLUMN [YearQuarterFks]
