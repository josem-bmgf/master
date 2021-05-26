CREATE TABLE [dbo].[Report_Categories]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[DisplaySortSequence] [int] NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	CONSTRAINT [PK_Report_Categories] PRIMARY KEY CLUSTERED ([Id] ASC)
)
