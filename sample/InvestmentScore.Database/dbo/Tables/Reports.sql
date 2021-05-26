CREATE TABLE [dbo].[Reports] (
    [Id] [int] IDENTITY(1000,1) NOT NULL,
	[Name] [nvarchar](250) NULL,
	[ReportCategoryId] [int] NOT NULL,
	[DisplaySortSequence] [int] NOT NULL,
	[Description] [nvarchar](500) NULL,
	[ReportUrl] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	CONSTRAINT [PK_Reports]  PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [FK_Reports_Report_Categories] FOREIGN KEY ([ReportCategoryId]) REFERENCES [dbo].[Report_Categories] ([Id])
);

