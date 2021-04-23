--Global Development
UPDATE [dbo].[Team]
SET [DivisionFk] = 1001
WHERE Id Between 1005 AND 1021

--Global Health
UPDATE [dbo].[Team]
SET [DivisionFk] = 1002
WHERE Id = 1063
UPDATE [dbo].[Team]
SET [DivisionFk] = 1002
Where Id Between 1022 AND 1033

--Global Policy and Advocacy
UPDATE [dbo].[Team]
SET [DivisionFk] = 1003
WHERE Id Between 1034 AND 1041 
--ADD Campaigns, Creative, & Media
INSERT INTO [dbo].[Team] (Team,Status,DivisionFk)
VALUES ('Campaigns, Creative, & Media',1,1003);
--ADD US Policy, Advocacy, & Communications
INSERT INTO [dbo].[Team] (Team,Status,DivisionFk)
VALUES ('US Policy, Advocacy, & Communications',1,1003);

--Operations
UPDATE [dbo].[Team]
SET [DivisionFk] = 1004
WHERE Id Between 1042 AND 1046

--U.S. Program
UPDATE [dbo].[Team]
SET [DivisionFk] = 1005
WHERE Id = 1053
UPDATE [dbo].[Team]
SET [DivisionFk] = 1005
WHERE Id Between 1047 AND 1049

--Chief Strategy Officer
UPDATE [dbo].[Team]
SET [DivisionFk] = 1007
WHERE Id Between 1057 AND 1061
--ADD this new records: Melinda’s Advocacy Team | Melinda’s Programmatic Team | Strategic Planning & Engagement
--Melinda’s Advocacy Team
INSERT INTO [dbo].[Team] (Team,Status,DivisionFk)
VALUES ('Melinda’s Advocacy Team',1,1007);
--Melinda’s Programmatic Team
INSERT INTO [dbo].[Team] (Team,Status,DivisionFk)
VALUES ('Melinda’s Programmatic Team',1,1007);
--Strategic Planning & Engagement
INSERT INTO [dbo].[Team] (Team,Status,DivisionFk)
VALUES ('Strategic Planning & Engagement',1,1007);

--ADD new Division CEO Office
INSERT INTO [dbo].[Division] (Name,Description,DisplaySortSequence,Status)
VALUES ('CEO Office','CEO Office',1700,1);
--ADD CEO Communication, External
INSERT INTO [dbo].[Team] (Team,Status,DivisionFk)
VALUES ('CEO Communication, External',1,1008);
--ADD Community and Civic Engagement
INSERT INTO [dbo].[Team] (Team,Status,DivisionFk)
VALUES ('Community and Civic Engagement',1,1008);
--ADD Executive & Employee Communications
INSERT INTO [dbo].[Team] (Team,Status,DivisionFk)
VALUES ('Executive & Employee Communications',1,1008);
--ADD Gates 2025
INSERT INTO [dbo].[Team] (Team,Status,DivisionFk)
VALUES ('Gates 2025',1,1008);

--Update the Leader Table
UPDATE [dbo].[Leader]
SET [Status] = 0
WHERE Id in (-1,0,1017)