CREATE TABLE [dbo].[Leader] (
    [Id]                  INT          IDENTITY (1000, 1) NOT NULL,
    [SysGroupFk]          INT          CONSTRAINT [DF_Leader_SysGroupFk] DEFAULT ((0)) NOT NULL,
    [FirstName]           VARCHAR (25) CONSTRAINT [DF_Leader_FirstName] DEFAULT ('') NOT NULL,
    [LastName]            VARCHAR (25) CONSTRAINT [DF_Leader_LastName] DEFAULT ('') NOT NULL,
    [ShortName]           VARCHAR (10) CONSTRAINT [DF_Leader_ShortName] DEFAULT ('') NOT NULL,
    [ADUser]              VARCHAR (50) CONSTRAINT [DF_Leader_ADUser] DEFAULT ('') NOT NULL,
    [DisplaySortSequence] INT          CONSTRAINT [DF_Leader_DisplaySortSequence] DEFAULT ((-1)) NOT NULL,
    [Status]              BIT          CONSTRAINT [DF_Leader_Status] DEFAULT ((1)) NOT NULL,
	[IsExecutiveSponsor]	BIT			CONSTRAINT [DF_Leader_IsExecutiveSponsor]  DEFAULT ((0)) NOT NULL,
	[IsRequiredPrincipal]	BIT			CONSTRAINT [DF_Leader_IsRequiredPrincipal]  DEFAULT ((0)) NOT NULL,	
	[IsAlternatePrincipal]	BIT			CONSTRAINT [DF_Leader_IsAlternatePrincipal]  DEFAULT ((0)) NOT NULL


    CONSTRAINT [PK_Leader] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Leader_SysGroup] FOREIGN KEY ([SysGroupFk]) REFERENCES [dbo].[SysGroup] ([Id])
);

