USE [LEAD]
GO


CREATE TABLE [dbo].[Division](
	[Id] [int] IDENTITY(1000,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[DisplaySortSequence] [int] NOT NULL CONSTRAINT [DF_Division_GroupDisplaySortSequence]  DEFAULT ((-1)),
	[Status] [bit] NOT NULL CONSTRAINT [DF_Division_Status]  DEFAULT ((1)),
 CONSTRAINT [PK_Division] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
Go


