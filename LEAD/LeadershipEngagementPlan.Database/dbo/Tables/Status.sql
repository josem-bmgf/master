CREATE TABLE [dbo].[Status]
(
	[Id] INT IDENTITY(1000,1) NOT NULL PRIMARY KEY, 
    [Name] VARCHAR(50) NULL,
	[DisplaySortSequence] INT NOT NULL CONSTRAINT [DF_Status_DisplaySortSequence]  DEFAULT ((-1))
)
