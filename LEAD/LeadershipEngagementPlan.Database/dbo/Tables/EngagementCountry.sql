CREATE TABLE [dbo].[EngagementCountry]
(
	[Id] INT IDENTITY (1000,1) NOT NULL PRIMARY KEY, 
    [EngagementFk] INT NOT NULL, 
    [CountryFk] INT NOT NULL,
	CONSTRAINT [FK_EngagementCountry_Engagement] FOREIGN KEY ([EngagementFK]) REFERENCES [dbo].[Engagement] ([Id]),
	CONSTRAINT [FK_EngagementCountry_Country] FOREIGN KEY ([CountryFk]) REFERENCES [dbo].[Country] ([Id])
)
