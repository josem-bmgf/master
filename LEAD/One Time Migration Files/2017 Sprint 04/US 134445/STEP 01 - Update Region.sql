-- [2017 Sprint 04] User Story 134445: LEAD: Update Country and Region List
-- Renamed existing Region, Added new Regions
USE LEAD
GO 

IF OBJECT_ID('dbo.RegionBackup', 'U') IS NOT NULL 
  DROP TABLE [dbo].[RegionBackup]; 

SELECT * 
INTO [dbo].[RegionBackup]
FROM [dbo].[Region]

UPDATE [dbo].[Region]
SET [Status] = 0

UPDATE [dbo].[Region]
SET Region = 'North America', [Status] = 1
WHERE Region = 'North & Central America'

UPDATE [dbo].[Region]
SET [Status] = 1
WHERE Region = 'South America'

UPDATE [dbo].[Region]
SET Region = 'Australia', [Status] = 1
WHERE Region = 'Australia And New Zealand'

UPDATE [dbo].[Region]
SET Region = 'Middle East', [Status] = 1
WHERE Region = 'Middle East Asia'


INSERT INTO [dbo].[Region]
VALUES ('Africa', 0, 1)
	,('Asia', 0, 1)
	,('Europe', 0, 1)

SELECT * FROM [dbo].[Region]
WHERE STATUS = 1
