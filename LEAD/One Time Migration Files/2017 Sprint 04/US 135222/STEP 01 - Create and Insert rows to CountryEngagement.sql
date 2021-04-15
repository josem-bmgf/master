-- [2017 Sprint 04] US 135222 - LEAD - Change Country field to multi-select 
-- Create Engagement Country table since Engagement can now have multiple Count

USE [LEAD]
GO

/****** Object:  Table [dbo].[EngagementCountry]    Script Date: 2/16/2017 2:22:59 PM ******/
CREATE TABLE [dbo].[EngagementCountry]
(
	[Id] INT IDENTITY (1000,1) NOT NULL PRIMARY KEY, 
    [EngagementFk] INT NOT NULL, 
    [CountryFk] INT NOT NULL,
	CONSTRAINT [FK_EngagementCountry_Engagement] FOREIGN KEY ([EngagementFK]) REFERENCES [dbo].[Engagement] ([Id]),
	CONSTRAINT [FK_EngagementCountry_Country] FOREIGN KEY ([CountryFk]) REFERENCES [dbo].[Country] ([Id])
)


-- insert rows to EngagementCountry from Engagement table
INSERT INTO [dbo].[EngagementCountry]
SELECT Id, CountryFk
FROM [dbo].[Engagement]

SELECT Id, CountryFk FROM [dbo].[Engagement]
SELECT * FROM [dbo].[EngagementCountry]

/****** Object:  Table [hst].[EngagementCountry]    Script Date: 2/21/2017 2:22:59 PM ******/
CREATE TABLE [hst].[EngagementCountry]
(
	[Id] INT IDENTITY (1000,1) NOT NULL,
	[IdFk] INT NOT NULL,
    [EngagementFk] INT NOT NULL, 
    [CountryFk] INT NOT NULL,
	CONSTRAINT [PK_EngagementCountry_History] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EngagementCountry_EngagementCountry] FOREIGN KEY ([IdFk]) REFERENCES [dbo].[EngagementCountry] ([Id])
)

