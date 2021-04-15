--Engagement Year Quarter

CREATE TABLE [dbo].[EngagementYearQuarter]
(
	[Id] INT IDENTITY (1000,1) NOT NULL PRIMARY KEY, 
    [EngagementFk] INT NOT NULL, 
    [YearQuarterFk] INT NOT NULL,
	CONSTRAINT [FK_EngagementYearQuarter_Engagement] FOREIGN KEY ([EngagementFK]) REFERENCES [dbo].[Engagement] ([Id]),
	CONSTRAINT [FK_EngagementYearQuarter_YearQuarter] FOREIGN KEY ([YearQuarterFk]) REFERENCES [dbo].[YearQuarter] ([Id])

)

--Engagement Required/Alternate Principal
CREATE TABLE [dbo].[PrincipalType]
(
	[Id] INT IDENTITY(1000,1) NOT NULL PRIMARY KEY, 
    [Name] NVARCHAR(50) NOT NULL
)


CREATE TABLE [dbo].[Principal]
(
	[Id] INT IDENTITY(1000,1) NOT NULL PRIMARY KEY, 
    [EngagementFK] INT CONSTRAINT [DF_Principal_EngagementFK] DEFAULT ((0)) NOT NULL, 
    [LeaderFK] INT CONSTRAINT [DF_Principal_LeaderFK] DEFAULT ((0)) NOT NULL, 
    [TypeFK] INT CONSTRAINT [DF_Principal_TypeFK] DEFAULT ((0)) NOT NULL,
	CONSTRAINT [FK_Principal_Engagement] FOREIGN KEY ([EngagementFK]) REFERENCES [dbo].[Engagement] ([Id]),
	CONSTRAINT [FK_Principal_Leader] FOREIGN KEY ([LeaderFK]) REFERENCES [dbo].[Leader] ([Id]),
	CONSTRAINT [FK_Principal_PrincipalType] FOREIGN KEY ([TypeFK]) REFERENCES [dbo].[PrincipalType] ([Id])
)

INSERT INTO [dbo].[PrincipalType] ([Name])
VALUES ('Required')
	,('Alternate')

SELECT *
FROM [dbo].[PrincipalType]

--Status
CREATE TABLE [dbo].[Status]
(
	[Id] INT IDENTITY(1000,1) NOT NULL PRIMARY KEY, 
    [Name] VARCHAR(50) NULL,
	[DisplaySortSequence] INT NOT NULL CONSTRAINT [DF_Status_DisplaySortSequence]  DEFAULT ((-1))
)

SET IDENTITY_INSERT [dbo].[Status] ON
INSERT INTO [dbo].[Status] ([Id], [Name], [DisplaySortSequence])
VALUES 
	(-1, 'Not Found', -1)
	,(0, '', -1)
	,(1000, 'Draft', 1000)
	,(1001, 'Submitted for Review', 1010)
	,(1002, 'Review in Progress', 1020)
	,(1003, 'Declined', 1030)
	,(1004, 'Approved', 1040)
	,(1005, 'Scheduling in Progress', 1050)
	,(1006, 'Scheduled', 1060)
	,(1007, 'Completed', 1070)
SET IDENTITY_INSERT [dbo].[Status] OFF

SELECT *
FROM [dbo].[Status]

--Engagement table, Add Status column
ALTER TABLE [dbo].[Engagement]
ADD	[StatusFk] INT CONSTRAINT [DF_Engagement_StatusFk] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [FK_Engagement_Status] FOREIGN KEY ([StatusFk]) REFERENCES [dbo].[Status] ([Id])

