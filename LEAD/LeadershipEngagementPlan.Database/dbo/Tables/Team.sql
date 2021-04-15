CREATE TABLE [dbo].[Team] (
    [Id]         INT          IDENTITY (1000, 1) NOT NULL,
    [SysGroupFk] INT          CONSTRAINT [DF_TeamSubTeamSysGroup_SysGroupFk] DEFAULT ((0)) NOT NULL,
    [Team]       VARCHAR (50) CONSTRAINT [DF_TeamSubTeamSysGroup_SubTeam] DEFAULT ('') NOT NULL,
    [Status]     BIT          CONSTRAINT [DF_TeamSubTeamSysGroup_Status] DEFAULT ((-1)) NOT NULL,
    CONSTRAINT [PK_TeamSubTeamSysGroup] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Team_SysGroup] FOREIGN KEY ([SysGroupFk]) REFERENCES [dbo].[SysGroup] ([Id])
);

