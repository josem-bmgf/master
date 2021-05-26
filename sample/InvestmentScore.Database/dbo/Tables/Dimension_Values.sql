CREATE TABLE [dbo].[Dimension_Values] (
    [Id] [int] IDENTITY(1000,1) NOT NULL,
	[Name] [varchar](250) NULL,
	[DimensionCategoryId] [int] NOT NULL,
	[DisplaySortSequence] [int] NOT NULL,
	[ReportValue] [varchar](100) NULL,
	CONSTRAINT [PK_Dimension_Values]  PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [FK_Dimension_Values_Dimension_Categories] FOREIGN KEY ([DimensionCategoryId]) REFERENCES [dbo].[Dimension_Categories] ([Id])
);

