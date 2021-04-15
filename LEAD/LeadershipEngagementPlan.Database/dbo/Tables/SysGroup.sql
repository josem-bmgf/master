CREATE TABLE [dbo].[SysGroup] (
    [Id]                       INT           IDENTITY (1000, 1) NOT NULL,
    [GroupName]                VARCHAR (50)  NOT NULL,
    [GroupShortName]           VARCHAR (10)  CONSTRAINT [DF_SysGroup_GroupShortName] DEFAULT ('') NOT NULL,
    [GroupDescription]         VARCHAR (255) NOT NULL,
    [GroupDisplaySortSequence] INT           CONSTRAINT [DF_SysGroup_GroupDisplaySortSequence] DEFAULT ((-1)) NOT NULL,
    [FoundationDomainTeam]     VARCHAR (50)  CONSTRAINT [DF_SysGroup_FoundationDomainTeam] DEFAULT ('') NOT NULL,
    [RequestingTeam]           BIT           CONSTRAINT [DF_SysGroup_RequestingTeam] DEFAULT ((0)) NOT NULL,
    [Status]                   BIT           CONSTRAINT [DF_SysGroup_Status] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_SysGroup] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_SysGroup]
    ON [dbo].[SysGroup]([GroupName] ASC);

