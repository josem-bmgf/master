USE [LEAD]
GO


--Update [dbo].[Division] set Name = 'Operations' where id = 1004
SELECT * FROM [dbo].[Engagement] where DivisionFk = 1008
UPDATE [dbo].[Engagement] set DivisionFk = 1000 where DivisionFk = 1008
DELETE FROM [dbo].[Division] where Id = 1008