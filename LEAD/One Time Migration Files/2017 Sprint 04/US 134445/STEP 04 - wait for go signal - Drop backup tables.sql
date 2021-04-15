-- [2017 Sprint 04] LEAD: User Story 134445: LEAD: Update Country and Region List
-- Drop back up table
-- NOTE! Do this when QA completes the testing
 
 USE LEAD
 GO
 
 IF OBJECT_ID('dbo.RegionBackup', 'U') IS NOT NULL 
  DROP TABLE [dbo].RegionBackup; 

 IF OBJECT_ID('dbo.CountryBackup', 'U') IS NOT NULL 
  DROP TABLE [dbo].CountryBackup; 

 IF OBJECT_ID('dbo.EngagementBackup', 'U') IS NOT NULL 
  DROP TABLE [dbo].EngagementBackup; 