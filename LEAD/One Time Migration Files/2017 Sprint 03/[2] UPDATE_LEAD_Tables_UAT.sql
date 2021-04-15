--Add new DivsionFK in Team Table
ALTER TABLE [dbo].[Team]
ADD [DivisionFk] INT CONSTRAINT [DF_TeamSubTeamDivision_DivisionFk] DEFAULT ((0)) FOREIGN KEY REFERENCES [dbo].[Division](Id)