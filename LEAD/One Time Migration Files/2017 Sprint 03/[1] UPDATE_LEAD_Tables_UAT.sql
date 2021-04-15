--remove decline in teamRanking
UPDATE dbo.Engagement
SET TeamRankingFk = 0
WHERE TeamRankingFk = '1003'

--update status of active unnecessary users
UPDATE [dbo].[SysUser]
SET [Status] = 0
WHERE ID in (1749,1750,1751,3001,2830,2831,2832,1002,3658)

--update status of Division and Team Table
UPDATE [dbo].[Division]
SET [Status] = 0
WHERE ID in (1000,1006)

UPDATE [dbo].[Team]
SET [Status] = 0
WHERE Id in (1000,1002,1012,1003,1004,1055,1050,1056,1051,1052,1019,1054)