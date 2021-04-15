CREATE TABLE [hst].[EngagementCountry]
(
	[Id] INT IDENTITY (1000,1) NOT NULL,
	[IdFk] INT NOT NULL,
    [EngagementFk] INT NOT NULL, 
    [CountryFk] INT NOT NULL,
	CONSTRAINT [PK_EngagementCountry_History] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EngagementCountry_EngagementCountry] FOREIGN KEY ([IdFk]) REFERENCES [dbo].[EngagementCountry] ([Id])
)

