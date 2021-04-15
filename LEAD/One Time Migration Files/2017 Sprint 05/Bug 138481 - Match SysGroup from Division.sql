-- [2017 Sprint 05] Bug 138481:LEAD: Division-Team mapping doesn't match
-- Updated Sysgroup table to match the Id to Division table
-- This query should only be done if Sysgroup and Division doesn't match


-- STEP 01 - Disable IX_Sysgroup 
-- 1. From Object Explorer, go to dbo.SysGroup table and expand Indexes
-- 2. Right click IX_Sysgroup and click Disable, and click Ok

-- STEP 02 - Execute below query

-- STEP 03 - Rebuild IX_Sysgroup to enable it
-- 1. From Object Explorer, go to dbo.SysGroup table and expand Indexes
-- 2. Right click IX_Sysgroup and click Rebuild, and click Ok

USE LEAD

UPDATE [dbo].[SysGroup]
SET GroupName = 'Global Communications & Engagement', GroupShortName = 'GCE', GroupDescription = 'Communications', GroupDisplaySortSequence = 1100, FoundationDomainTeam = 'Communications', RequestingTeam = 1
WHERE ID = 1000


UPDATE [dbo].[SysGroup]
SET GroupName = 'Global Development', GroupShortName = 'GD', GroupDescription = 'Global Development', GroupDisplaySortSequence = 1200, FoundationDomainTeam = 'Global Development' , RequestingTeam = 1
WHERE ID = 1001


UPDATE [dbo].[SysGroup]
SET GroupName = 'Global Health', GroupShortName = 'GH', GroupDescription = 'Global Health', GroupDisplaySortSequence = 1300, FoundationDomainTeam = 'Global Health' , RequestingTeam = 1
WHERE ID = 1002

UPDATE [dbo].[SysGroup]
SET GroupName = 'Global Policy and Advocacy', GroupShortName = 'GPA', GroupDescription = 'Global Policy and Advocacy', GroupDisplaySortSequence = 1400, FoundationDomainTeam = 'Global Policy and Advocacy' , RequestingTeam = 1
WHERE ID = 1003

UPDATE [dbo].[SysGroup]
SET GroupName = 'Operations', GroupShortName = 'OPS', GroupDescription = 'Operations', GroupDisplaySortSequence = 1500, FoundationDomainTeam = 'Operations' , RequestingTeam = 1
WHERE ID = 1004

UPDATE [dbo].[SysGroup]
SET GroupName = 'U.S. Program', GroupShortName = 'USP', GroupDescription = 'U.S. Program', GroupDisplaySortSequence = 1600, FoundationDomainTeam = 'U.S. Program' , RequestingTeam = 1
WHERE ID = 1005

UPDATE [dbo].[SysGroup]
SET GroupName = 'CEO Office', GroupShortName = 'CEO', GroupDescription = 'CEO Office', GroupDisplaySortSequence = 1000, FoundationDomainTeam = 'Executive' , RequestingTeam = 1
WHERE ID = 1006

UPDATE [dbo].[SysGroup]
SET GroupName = 'Foundation Strategy Office', GroupShortName = 'FSO', GroupDescription = 'Foundation Strategy Office', GroupDisplaySortSequence = 1450, FoundationDomainTeam = '' , RequestingTeam = 1
WHERE ID = 1007

UPDATE [dbo].[SysGroup]
SET GroupName = 'Executive', GroupShortName = 'EXEC', GroupDescription = 'Executive', GroupDisplaySortSequence = 1700, FoundationDomainTeam = '' , RequestingTeam = 1
WHERE ID = 1008

UPDATE [dbo].[SysGroup]
SET GroupName = 'Application Administrator', GroupShortName = 'AA', GroupDescription = 'Application Administrator', GroupDisplaySortSequence = 200, FoundationDomainTeam = '' , RequestingTeam = 0
WHERE ID = 1009

SET IDENTITY_INSERT [dbo].[SysGroup] ON;  
GO  

INSERT INTO [dbo].[SysGroup]
           ([Id]
		   ,[GroupName]
           ,[GroupShortName]
           ,[GroupDescription]
           ,[GroupDisplaySortSequence]
           ,[FoundationDomainTeam]
           ,[RequestingTeam]
           ,[Status])
     VALUES
           (1016
		   ,'System'
		   ,'Sys'
		   ,'System'
		   ,100
		   ,''
		   ,0
		   ,1
		   )
GO

SET IDENTITY_INSERT [dbo].[SysGroup] OFF;  
GO  
