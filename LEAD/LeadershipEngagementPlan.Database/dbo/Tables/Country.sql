CREATE TABLE [dbo].[Country] (
    [Id]       INT          IDENTITY (1000, 1) NOT NULL,
    [RegionFk] INT          CONSTRAINT [DF_Country_RegionFk] DEFAULT ((0)) NOT NULL,
    [Country]  VARCHAR (50) CONSTRAINT [DF_Country_Country] DEFAULT ('') NOT NULL,
    [Status]   BIT          CONSTRAINT [DF_Country_Status] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Country_Region] FOREIGN KEY ([RegionFk]) REFERENCES [dbo].[Region] ([Id])
);

