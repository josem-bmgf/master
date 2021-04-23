-- [2017 Sprint 04] LEAD: User Story 134445: LEAD: Update Country and Region List
-- Update existing Engagement to map the correct Region

 --backup original Engagement Table
 USE LEAD
 GO
 IF OBJECT_ID('dbo.EngagementBackup', 'U') IS NOT NULL 
  DROP TABLE [dbo].EngagementBackup; 

SELECT * INTO dbo.EngagementBackup
  FROM dbo.Engagement

SELECT RegionFK, *
  FROM [LEAD].[dbo].EngagementBackup
 --WHERE RegionFK in ('1000','1009') --Africa
 --WHERE RegionFK in ('1007','1012') --Asia
 WHERE RegionFk IN ('1002', '1004',
					'1010', '1011') --Europe

--UPDATE Engagement - RegionFK

UPDATE dbo.Engagement
   SET RegionFk = 1016
 WHERE RegionFk IN ('1000', '1009') --Africa: Africa, North Of Sahara, Africa, South Of Sahara

UPDATE dbo.Engagement
   SET RegionFk = 1017
 WHERE RegionFk IN ('1007', '1012') --Asia: South & Central Asia, Far East Asia

UPDATE dbo.Engagement
   SET RegionFk = 1018
 WHERE RegionFk IN ('1002', '1004',
					'1010', '1011') --Europe: Southern/Western/Easter/Northern Europe

------------end of update---------------------- 

-----------manual update of bad data-----------------
UPDATE [dbo].Engagement
SET RegionFk = 1014
WHERE Id in (1000278,1000279) 

--===Unit Test
SELECT RegionFK, *
  FROM [LEAD].[dbo].Engagement
 --WHERE RegionFK = 1017 --Africa
 --WHERE RegionFK = 1018 --Asia
 WHERE RegionFK = 1019 --Europe

SELECT RegionFK, *
  FROM [LEAD].[dbo].Engagement
 --WHERE RegionFK in ('1000','1009') --Africa
 --WHERE RegionFK in ('1007','1012') --Asia
 WHERE RegionFk IN ('1002', '1004',
					'1010', '1011') --Europe
