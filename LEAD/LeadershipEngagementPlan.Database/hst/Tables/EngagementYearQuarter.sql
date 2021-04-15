CREATE TABLE [hst].[EngagementYearQuarter]
(
	[Id] INT NOT NULL,
	[IdFk] INT NOT NULL,
	[EngagementFK] INT NOT NULL, 
    [YearQuarterFK] INT NOT NULL, 
	CONSTRAINT [PK_EngagementYearQuarter_History] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EngagementYearQuarter_EngagementYearQuarter] FOREIGN KEY ([IdFk]) REFERENCES [dbo].[EngagementYearQuarter] ([Id])
)
