CREATE TABLE [dbo].[Taxonomy_Categories] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (50)  NULL,
    [Description] NVARCHAR (500) NULL,
    [IsActive]    BIT            DEFAULT ((1)) NOT NULL,
    [Label] NVARCHAR(250) NULL, 
    [SortOrder] INT NULL, 
    CONSTRAINT [PK_Taxonomy_Categories] PRIMARY KEY CLUSTERED ([ID] ASC)
);

