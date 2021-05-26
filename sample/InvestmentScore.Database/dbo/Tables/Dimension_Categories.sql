CREATE TABLE [dbo].[Dimension_Categories] (
    [Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	CONSTRAINT [PK_Dimension_Categories] PRIMARY KEY CLUSTERED ([Id] ASC)
);

