-- [2017 Sprint 06] Bug 138247:[DEFECT] LEAD: Multiple instances of one engagement is displayed in Reports
-- Delete duplicate schedule of Engagement, retain first row.

USE [LEAD]
GO

WITH DeleteDuplicate AS (SELECT ROW_NUMBER() OVER(PARTITION BY [EngagementFk] ORDER BY [EngagementFk]) AS row
						 FROM [LEAD].[dbo].[Schedule])
DELETE FROM DeleteDuplicate
WHERE row > 1;

GO