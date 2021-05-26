CREATE TABLE [dbo].[Taxonomy_Items] (
    [ID]                   INT            IDENTITY (1, 1) NOT NULL,
    [Name]                 NVARCHAR (50)  NULL,
    [Description]          NVARCHAR (500) NULL,
    [Taxonomy_Category_ID] INT            NOT NULL,
    [IsActive]             BIT            DEFAULT ((1)) NOT NULL,
    [Label] NVARCHAR(250) NULL, 
	[SortOrder] INT NULL, 
    [IsNumeric] BIT NOT NULL DEFAULT 1, 
    CONSTRAINT [PK_Taxonomy_Items] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Taxonomy_Values_Taxonomy_Categories] FOREIGN KEY ([Taxonomy_Category_ID]) REFERENCES [dbo].[Taxonomy_Categories] ([ID])
);

