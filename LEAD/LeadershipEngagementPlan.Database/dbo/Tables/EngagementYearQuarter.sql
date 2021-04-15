CREATE TABLE [dbo].[EngagementYearQuarter]
(
	[Id] INT IDENTITY (1000,1) NOT NULL PRIMARY KEY, 
    [EngagementFk] INT NOT NULL, 
    [YearQuarterFk] INT NOT NULL,
	CONSTRAINT [FK_EngagementYearQuarter_Engagement] FOREIGN KEY ([EngagementFK]) REFERENCES [dbo].[Engagement] ([Id]),
	CONSTRAINT [FK_EngagementYearQuarter_YearQuarter] FOREIGN KEY ([YearQuarterFk]) REFERENCES [dbo].[YearQuarter] ([Id])

)
